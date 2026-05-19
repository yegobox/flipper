use std::sync::Mutex;
use std::time::Duration;

use anyhow::Context;
use dittolive_ditto::identity::DittoAuthenticationEventHandler;
use dittolive_ditto::identity::DittoAuthenticator;
use serde::Deserialize;
use tokio::runtime::Handle;

const AUTH_PROVIDER: &str = "auth-provider-01";
const FLIPPER_USER_SUFFIX: &str = "@flipper.rw";

#[derive(Debug, Deserialize)]
struct DittoLoginResponse {
    token: String,
}

/// Fetches a Ditto JWT from Yego API Hub (same endpoint as flipper_web).
pub async fn fetch_ditto_jwt(
    apihub_base: &str,
    raw_user_id: &str,
    app_id: &str,
) -> anyhow::Result<String> {
    let base = apihub_base.trim_end_matches('/');
    let url = format!("{base}/v2/api/auth/ditto/login");
    let user_id = format!("{raw_user_id}{FLIPPER_USER_SUFFIX}");

    let response = reqwest::Client::new()
        .post(&url)
        .header("Content-Type", "application/json")
        .json(&serde_json::json!({
            "userId": user_id,
            "appId": app_id,
        }))
        .send()
        .await
        .with_context(|| format!("POST {url}"))?;

    let status = response.status();
    let body = response.text().await.unwrap_or_default();
    if !status.is_success() {
        anyhow::bail!("Ditto login failed: {status} - {body}");
    }

    let data: DittoLoginResponse =
        serde_json::from_str(&body).context("parse Ditto login response")?;
    Ok(data.token)
}

/// Handles Ditto auth callbacks by fetching a JWT from API Hub and logging in.
#[derive(Clone)]
pub struct YbAuthHandler {
    apihub_base: String,
    raw_user_id: String,
    app_id: String,
    /// Main Tokio runtime; Ditto auth callbacks run on native threads without a runtime.
    runtime: Handle,
    /// Join concurrent authentication_required / expiring_soon calls.
    auth_in_flight: std::sync::Arc<Mutex<()>>,
}

impl YbAuthHandler {
    pub fn new(apihub_base: String, raw_user_id: String, app_id: String) -> Self {
        Self {
            apihub_base,
            raw_user_id,
            app_id,
            runtime: Handle::current(),
            auth_in_flight: std::sync::Arc::new(Mutex::new(())),
        }
    }

    fn perform_authentication(&self, auth: DittoAuthenticator) {
        let _guard = match self.auth_in_flight.lock() {
            Ok(g) => g,
            Err(_) => return,
        };

        let apihub_base = self.apihub_base.clone();
        let raw_user_id = self.raw_user_id.clone();
        let app_id = self.app_id.clone();

        let result = self.runtime.block_on(async {
            let token = fetch_ditto_jwt(&apihub_base, &raw_user_id, &app_id).await?;
            auth.login(&token, AUTH_PROVIDER)
                .map_err(|e| anyhow::anyhow!("ditto auth.login: {e}"))
        });

        match result {
            Ok(_) => tracing::info!(
                user = %format!("{raw_user_id}{FLIPPER_USER_SUFFIX}"),
                "Ditto authentication successful"
            ),
            Err(e) => tracing::error!("Ditto authentication failed: {e:#}"),
        }
    }
}

impl DittoAuthenticationEventHandler for YbAuthHandler {
    fn authentication_required(&self, auth: DittoAuthenticator) {
        tracing::info!("Ditto authentication required");
        self.perform_authentication(auth);
    }

    fn authentication_expiring_soon(
        &self,
        auth: DittoAuthenticator,
        seconds_remaining: Duration,
    ) {
        tracing::info!(
            remaining_secs = seconds_remaining.as_secs(),
            "Ditto authentication expiring soon, refreshing"
        );
        self.perform_authentication(auth);
    }
}
