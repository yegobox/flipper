use std::{
    pin::Pin,
    sync::Arc,
    task::{Context, Poll},
    time::Duration,
};

use bytes::Bytes;
use serde::Deserialize;
use turso_sync_sdk_kit::rsapi::PartialSyncOpts;

use crate::{
    connection::Connection,
    database::Database,
    error::{Error, Result},
    io_worker::IoWorker,
};

pub trait SyncDatabase: Database {
    fn push(&self) -> impl Future<Output = Result<()>>;
    fn pull(&self) -> impl Future<Output = Result<bool>>;
}

const DEFAULT_CLIENT_NAME: &str = "turso-sync-rust";

#[derive(Debug, Clone, Copy, Deserialize)]
pub enum RemoteEncryptionCipher {
    Aes256Gcm,
    Aes128Gcm,
    ChaCha20Poly1305,
    Aegis128L,
    Aegis128X2,
    Aegis128X4,
    Aegis256,
    Aegis256X2,
    Aegis256X4,
}

impl RemoteEncryptionCipher {
    /// Returns the total reserved bytes as required by the server
    pub fn reserved_bytes(&self) -> usize {
        match self {
            Self::Aes256Gcm | Self::Aes128Gcm | Self::ChaCha20Poly1305 => 28,
            Self::Aegis128L | Self::Aegis128X2 | Self::Aegis128X4 => 32,
            Self::Aegis256 | Self::Aegis256X2 | Self::Aegis256X4 => 48,
        }
    }
}

impl std::str::FromStr for RemoteEncryptionCipher {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "aes256gcm" | "aes-256-gcm" => Ok(Self::Aes256Gcm),
            "aes128gcm" | "aes-128-gcm" => Ok(Self::Aes128Gcm),
            "chacha20poly1305" | "chacha20-poly1305" => Ok(Self::ChaCha20Poly1305),
            "aegis128l" | "aegis-128l" => Ok(Self::Aegis128L),
            "aegis128x2" | "aegis-128x2" => Ok(Self::Aegis128X2),
            "aegis128x4" | "aegis-128x4" => Ok(Self::Aegis128X4),
            "aegis256" | "aegis-256" => Ok(Self::Aegis256),
            "aegis256x2" | "aegis-256x2" => Ok(Self::Aegis256X2),
            "aegis256x4" | "aegis-256x4" => Ok(Self::Aegis256X4),
            _ => Err(format!(
                "unknown cipher: '{s}'. Supported: aes256gcm, aes128gcm, chacha20poly1305, \
                 aegis128l, aegis128x2, aegis128x4, aegis256, aegis256x2, aegis256x4"
            )),
        }
    }
}

pub struct SyncDb {
    sync: Arc<turso_sync_sdk_kit::rsapi::TursoDatabaseSync<Bytes>>,
    io: Arc<IoWorker>,
}

impl SyncDb {
    pub async fn new(config: SyncDbConfig) -> Result<SyncDb> {
        // Compose the experimental_features comma-separated string from the
        // boolean flags exposed on this Builder. Today only `index_method`
        // is wired; future synced-compatible flags can be added here.
        let experimental_features = {
            let mut features: Vec<&str> = Vec::new();
            if config.experimental_index_method {
                features.push("index_method");
            }
            if features.is_empty() {
                None
            } else {
                Some(features.join(","))
            }
        };

        // Build core database config for the embedded engine.
        let db_config = turso_sdk_kit::rsapi::TursoDatabaseConfig {
            path: config.path.clone(),
            experimental_features,
            // IMPORTANT: async IO must be turned on to delegate IO to this layer.
            async_io: true,
            encryption: None,
            vfs: None,
            io: None,
            db_file: None,
        };

        let url = if let Some(remote_url) = &config.remote_url {
            Some(normalize_base_url(remote_url).map_err(|e| Error::new(&e))?)
        } else {
            None
        };

        // Calculate reserved_bytes from cipher if provided.
        let reserved_bytes = config
            .remote_encryption_cipher
            .map(|cipher| cipher.reserved_bytes());

        // Build sync engine config.
        let sync_config = turso_sync_sdk_kit::rsapi::TursoDatabaseSyncConfig {
            path: config.path.clone(),
            remote_url: url.clone(),
            client_name: config
                .client_name
                .clone()
                .unwrap_or_else(|| DEFAULT_CLIENT_NAME.to_string()),
            long_poll_timeout_ms: config
                .long_poll_timeout
                .map(|d| d.as_millis().min(u32::MAX as u128) as u32),
            bootstrap_if_empty: config.bootstrap_if_empty,
            reserved_bytes,
            partial_sync_opts: config.partial_sync_config_experimental.clone(),
            remote_encryption_key: config.remote_encryption_key.clone(),
            push_operations_threshold: None,
            pull_bytes_threshold: None,
        };

        // Create sync wrapper.
        let sync =
            turso_sync_sdk_kit::rsapi::TursoDatabaseSync::<Bytes>::new(db_config, sync_config)
                .map_err(Error::from)?;

        // IO worker will process SyncEngine IO queue on a dedicated tokio thread.
        let io_worker = IoWorker::spawn(sync.clone(), url, config.auth_token.clone());

        // Create (bootstrap + open) database in one go.
        let op = sync.create();
        drive_operation_result(op, io_worker.clone()).await?;

        Ok(Self {
            sync,
            io: io_worker,
        })
    }
}

#[derive(Deserialize)]
pub struct SyncDbConfig {
    // Absolute or relative path to local database file (":memory:" is supported).
    path: String,
    // Remote URL base. Supports https://, http:// and libsql:// (translated to https://).
    remote_url: Option<String>,
    // Optional authorization token provider (static string or async callback).
    auth_token: Option<String>,
    // Optional custom client identifier used by the sync engine for telemetry/tracing.
    client_name: Option<String>,
    // Optional long-poll timeout when waiting for server changes.
    long_poll_timeout: Option<Duration>,
    // Whether to bootstrap a database if it's empty (download schema and initial data).
    bootstrap_if_empty: bool,
    // Partial sync configuration (EXPERIMENTAL).
    partial_sync_config_experimental: Option<PartialSyncOpts>,
    // Encryption key (base64-encoded) for the Turso Cloud database
    remote_encryption_key: Option<String>,
    // Encryption cipher for the Turso Cloud database
    remote_encryption_cipher: Option<RemoteEncryptionCipher>,
    // Whether to enable the experimental `index_method` engine feature
    // (e.g. `CREATE INDEX … USING fts (...)`). Mirrors the local Builder's
    // `experimental_index_method` flag so synced databases can use the
    // same SQL surface as their local-only counterparts.
    experimental_index_method: bool,
}

impl Database for SyncDb {
    async fn connect(&self) -> Result<crate::connection::Connection> {
        let op = self.sync.connect();
        let result = drive_operation_result(op, self.io.clone()).await?;
        match result {
            Some(
                turso_sync_sdk_kit::turso_async_operation::TursoAsyncOperationResult::Connection {
                    connection,
                },
            ) => {
                // Provide extra_io callback to kick IO worker when driver needs to make progress.
                let io = self.io.clone();
                let extra_io = Arc::new(move |waker| {
                    io.register(waker);
                    io.kick();
                    Ok(())
                });
                Ok(Connection::create(connection, Some(extra_io)))
            }
            _ => Err(Error::new("unexpected result type from connect operation")),
        }
    }
}

impl SyncDatabase for SyncDb {
    async fn push(&self) -> Result<()> {
        let op = self.sync.push_changes();
        drive_operation_result(op, self.io.clone()).await?;
        Ok(())
    }

    async fn pull(&self) -> Result<bool> {
        // First, wait for changes...
        let op = self.sync.wait_changes();
        let result = drive_operation_result(op, self.io.clone()).await?;
        let mut has_changes = false;

        if let Some(
            turso_sync_sdk_kit::turso_async_operation::TursoAsyncOperationResult::Changes {
                changes,
            },
        ) = result
        {
            if !changes.empty() {
                has_changes = true;
                // Then, apply them.
                let op_apply = self.sync.apply_changes(changes);
                drive_operation_result(op_apply, self.io.clone()).await?;
            }
        }

        Ok(has_changes)
    }
}

async fn drive_operation_result(
    op: Box<turso_sync_sdk_kit::turso_async_operation::TursoDatabaseAsyncOperation>,
    io: Arc<IoWorker>,
) -> Result<Option<turso_sync_sdk_kit::turso_async_operation::TursoAsyncOperationResult>> {
    let fut = AsyncOpFuture::new(op, io);
    fut.await
}

// Custom Future that integrates with TursoDatabaseAsyncOperation and our IO worker.
struct AsyncOpFuture {
    op: Option<Box<turso_sync_sdk_kit::turso_async_operation::TursoDatabaseAsyncOperation>>,
    io: Arc<IoWorker>,
}

impl AsyncOpFuture {
    fn new(
        op: Box<turso_sync_sdk_kit::turso_async_operation::TursoDatabaseAsyncOperation>,
        io: Arc<IoWorker>,
    ) -> Self {
        Self { op: Some(op), io }
    }
}

impl Future for AsyncOpFuture {
    type Output =
        Result<Option<turso_sync_sdk_kit::turso_async_operation::TursoAsyncOperationResult>>;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        let this = unsafe { self.get_unchecked_mut() };
        let Some(op) = &this.op else {
            return Poll::Ready(Err(Error::new(
                "operation future has been already completed",
            )));
        };

        this.io.register(cx.waker().clone());

        // Try to resume the operation.
        match op.resume() {
            Ok(turso_sdk_kit::rsapi::TursoStatusCode::Done) => {
                // Try to take the result (may be None).
                let result = op.take_result().map(Some).or_else(|err| match err {
                    turso_sdk_kit::rsapi::TursoError::Misuse(msg)
                        if msg.contains("operation has no result") =>
                    {
                        Ok(None)
                    }
                    other => Err(Error::from(other)),
                })?;
                // Drop the op and complete.
                this.op.take();
                Poll::Ready(Ok(result))
            }
            Ok(turso_sdk_kit::rsapi::TursoStatusCode::Io) => {
                // Kick IO worker to process queued IO.
                this.io.kick();
                // Wait until IO worker makes progress and wakes us.
                Poll::Pending
            }
            Ok(turso_sdk_kit::rsapi::TursoStatusCode::Row) => {
                // Not expected from top-level sync operations.
                Poll::Ready(Err(Error::new("unexpected row status in sync operation")))
            }
            Err(e) => Poll::Ready(Err(Error::from(e))),
        }
    }
}

// Normalize remote base URL, mapping libsql:// to https:// and validating allowed schemes.
fn normalize_base_url(input: &str) -> std::result::Result<String, String> {
    let s = input.trim();
    let s = if let Some(rest) = s.strip_prefix("libsql://") {
        format!("https://{rest}")
    } else {
        s.to_string()
    };
    // Accept http or https only
    if !(s.starts_with("https://") || s.starts_with("http://")) {
        return Err(format!("unsupported remote URL scheme: {input}"));
    }
    // Ensure no trailing slash to make join predictable.
    let base = s.trim_end_matches('/').to_string();
    Ok(base)
}
