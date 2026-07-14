use std::{
    io::ErrorKind,
    sync::{Arc, Mutex},
    task::Waker,
};

use bytes::Bytes;
use http_body_util::{BodyExt, Full};
use hyper::{Request, header::AUTHORIZATION};
use hyper_rustls::HttpsConnector;
use hyper_util::{
    client::legacy::{Client, connect::HttpConnector},
    rt::TokioExecutor,
};
use tokio::sync::mpsc;

pub struct IoWorker {
    // Reference to the sync database to pull IO items from its queue.
    sync: Arc<turso_sync_sdk_kit::rsapi::TursoDatabaseSync<Bytes>>,
    // Normalized base URL (http/https).
    base_url: Option<String>,
    // Optional auth token provider (resolved per request).
    auth_token: Option<String>,
    // Channel to wake the worker to process IO.
    tx: mpsc::UnboundedSender<()>,
    // Wakers to notify pending futures when IO makes progress.
    wakers: Arc<Mutex<Vec<Waker>>>,
}

impl IoWorker {
    pub fn spawn(
        sync: Arc<turso_sync_sdk_kit::rsapi::TursoDatabaseSync<Bytes>>,
        base_url: Option<String>,
        auth_token: Option<String>,
    ) -> Arc<Self> {
        let (tx, rx) = mpsc::unbounded_channel::<()>();
        let wakers = Arc::new(Mutex::new(Vec::new()));

        let worker = Arc::new(Self {
            sync,
            base_url,
            auth_token,
            tx,
            wakers: wakers.clone(),
        });

        // Spin a separate Tokio runtime on its own thread to process IO queue.
        let worker_clone = worker.clone();
        std::thread::Builder::new()
            .name("turso-sync-io".to_string())
            .spawn(move || {
                let rt = tokio::runtime::Builder::new_current_thread()
                    .enable_all()
                    .build()
                    .expect("failed to build IO runtime");

                rt.block_on(async move {
                    IoWorker::run_loop(worker_clone, rx, wakers).await;
                });
            })
            .expect("failed to spawn IO worker thread");

        worker
    }

    // Register a waker to be awakened upon IO progress.
    pub fn register(&self, waker: Waker) {
        let mut wakers = self.wakers.lock().unwrap();
        wakers.push(waker);
    }

    // Kick the IO worker to process IO queue.
    pub fn kick(&self) {
        let _ = self.tx.send(());
    }

    // Called from the IO thread once progress has been made to notify all pending futures.
    fn notify_progress(wakers: &Arc<Mutex<Vec<Waker>>>) {
        let wakers = {
            let mut guard = wakers.lock().unwrap();
            std::mem::take(&mut *guard)
        };
        for w in wakers {
            w.wake();
        }
    }

    async fn run_loop(
        this: Arc<IoWorker>,
        mut rx: mpsc::UnboundedReceiver<()>,
        wakers: Arc<Mutex<Vec<Waker>>>,
    ) {
        // Create HTTPS-capable Hyper client.
        let mut http_connector = HttpConnector::new();
        http_connector.enforce_http(false);
        let https: HttpsConnector<HttpConnector> = hyper_rustls::HttpsConnectorBuilder::new()
            .with_webpki_roots()
            .https_or_http()
            .enable_http1()
            .build();
        let client: Client<HttpsConnector<HttpConnector>, Full<Bytes>> =
            Client::builder(TokioExecutor::new()).build::<_, Full<Bytes>>(https);

        while rx.recv().await.is_some() {
            // Process all pending items in the sync IO queue.
            let mut made_progress = false;
            loop {
                let item = this.sync.take_io_item();
                let Some(item) = item else {
                    this.sync.step_io_callbacks();
                    IoWorker::notify_progress(&wakers);
                    break;
                };

                made_progress = true;

                match item.get_request() {
                    turso_sync_sdk_kit::sync_engine_io::SyncEngineIoRequest::Http {
                        url,
                        method,
                        path,
                        body,
                        headers,
                    } => {
                        IoWorker::process_http(
                            &this,
                            &client,
                            url.as_deref(),
                            method,
                            path,
                            body.as_ref().map(|v| Bytes::from(v.clone())),
                            headers,
                            item.get_completion().clone(),
                        )
                        .await;
                    }
                    turso_sync_sdk_kit::sync_engine_io::SyncEngineIoRequest::FullRead { path } => {
                        IoWorker::process_full_read(
                            path,
                            item.get_completion().clone(),
                            &this.sync,
                        )
                        .await;
                    }
                    turso_sync_sdk_kit::sync_engine_io::SyncEngineIoRequest::FullWrite {
                        path,
                        content,
                    } => {
                        IoWorker::process_full_write(
                            path,
                            content,
                            item.get_completion().clone(),
                            &this.sync,
                        )
                        .await;
                    }
                }
            }

            // Run queued IO callbacks and wake all pending ops, yielding control
            // to allow them to make progress before we loop again.
            if made_progress {
                this.sync.step_io_callbacks();
                IoWorker::notify_progress(&wakers);
                // Let waiting tasks run on their executors.
                tokio::task::yield_now().await;
            }
        }
    }

    #[allow(clippy::too_many_arguments)]
    async fn process_http(
        this: &Arc<IoWorker>,
        client: &Client<HttpsConnector<HttpConnector>, Full<Bytes>>,
        url: Option<&str>,
        method: &str,
        path: &str,
        body: Option<Bytes>,
        headers: &[(String, String)],
        completion: turso_sync_sdk_kit::sync_engine_io::SyncEngineIoCompletion<Bytes>,
    ) {
        // Build full URL.
        let full_url = if path.starts_with("http://") || path.starts_with("https://") {
            path.to_string()
        } else {
            // Ensure the path begins with '/'
            let p = if path.starts_with('/') {
                path.to_string()
            } else {
                format!("/{path}")
            };
            let Some(url) = this.base_url.as_deref().or(url) else {
                completion.poison("remote_url is not available".to_string());
                return;
            };
            format!("{url}{p}")
        };

        let mut builder = Request::builder().method(method).uri(&full_url);

        // Set headers from request
        if let Some(headers_map) = builder.headers_mut() {
            for (k, v) in headers {
                if let Ok(name) = hyper::header::HeaderName::try_from(k.as_str()) {
                    if let Ok(value) = hyper::header::HeaderValue::try_from(v.as_str()) {
                        headers_map.insert(name, value);
                    }
                }
            }
            // Add Authorization header if not already set
            if let Some(token) = &this.auth_token {
                if !headers_map.contains_key(AUTHORIZATION) {
                    let value = format!("Bearer {token}");
                    if let Ok(hv) = hyper::header::HeaderValue::try_from(value.as_str()) {
                        headers_map.insert(AUTHORIZATION, hv);
                    }
                }
            }
        }

        // Body must be Full<Bytes> to match the client type.
        let req_body = Full::new(body.unwrap_or_default());

        let request = match builder.body(req_body) {
            Ok(r) => r,
            Err(err) => {
                completion.poison(format!("failed to build request: {err}"));
                this.sync.step_io_callbacks();
                return;
            }
        };

        let mut response = match client.request(request).await {
            Ok(r) => r,
            Err(err) => {
                completion.poison(format!("http request failed: {err}"));
                this.sync.step_io_callbacks();
                return;
            }
        };

        // Propagate status
        let status = response.status().as_u16();
        completion.status(status as u32);
        this.sync.step_io_callbacks();
        IoWorker::notify_progress(&this.wakers);

        // Stream response body in chunks
        while let Some(frame_res) = response.body_mut().frame().await {
            match frame_res {
                Ok(frame) => {
                    if let Some(chunk) = frame.data_ref() {
                        completion.push_buffer(chunk.clone());
                        this.sync.step_io_callbacks();
                        IoWorker::notify_progress(&this.wakers);
                    }
                }
                Err(err) => {
                    completion.poison(format!("error reading response body: {err}"));
                    this.sync.step_io_callbacks();
                    IoWorker::notify_progress(&this.wakers);
                    return;
                }
            }
        }

        // Done streaming
        completion.done();
        this.sync.step_io_callbacks();
        IoWorker::notify_progress(&this.wakers);
    }

    async fn process_full_read(
        path: &str,
        completion: turso_sync_sdk_kit::sync_engine_io::SyncEngineIoCompletion<Bytes>,
        sync: &Arc<turso_sync_sdk_kit::rsapi::TursoDatabaseSync<Bytes>>,
    ) {
        match tokio::fs::read(path).await {
            Ok(content) => {
                completion.push_buffer(Bytes::from(content));
                completion.done();
            }
            Err(err) if err.kind() == ErrorKind::NotFound => completion.done(),
            Err(err) => {
                completion.poison(format!("full read failed for {path}: {err}"));
            }
        }
        // Step callbacks after progress.
        sync.step_io_callbacks();
    }

    async fn process_full_write(
        path: &str,
        content: &Vec<u8>,
        completion: turso_sync_sdk_kit::sync_engine_io::SyncEngineIoCompletion<Bytes>,
        sync: &Arc<turso_sync_sdk_kit::rsapi::TursoDatabaseSync<Bytes>>,
    ) {
        // Write the whole content in one go (non-chunked)
        match tokio::fs::write(path, content).await {
            Ok(_) => {
                // For full write there is no data to stream back; just finish.
                completion.done();
            }
            Err(err) => {
                completion.poison(format!("full write failed for {path}: {err}"));
            }
        }
        // Step callbacks after progress.
        sync.step_io_callbacks();
    }
}
