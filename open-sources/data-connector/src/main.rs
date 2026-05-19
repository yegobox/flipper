mod ditto_auth;

use clap::Parser;
use data_connector::destinations::supabase::SupabaseDestination;
use data_connector::sources::ditto::DittoSource;
use data_connector::Pipeline;
use ditto_auth::YbAuthHandler;
use dittolive_ditto::prelude::*;
use sqlx::postgres::PgPoolOptions;
use std::path::Path;
use std::str::FromStr;
use std::sync::Arc;

const DEFAULT_APIHUB_DOMAIN: &str = "https://apihub.yegobox.com";

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Ditto App ID (UUID)
    #[arg(long, env = "DITTO_APP_ID")]
    ditto_app_id: String,

    /// Raw Ditto user id (appended with @flipper.rw for JWT login)
    #[arg(long, env = "DITTO_USER_ID")]
    ditto_user_id: String,

    /// API Hub base URL for Ditto JWT (default: production)
    #[arg(long, env = "APIHUB_DOMAIN", default_value = DEFAULT_APIHUB_DOMAIN)]
    apihub_domain: String,

    /// Supabase Database URL
    #[arg(long, env = "DATABASE_URL")]
    database_url: String,

    /// Source Collection Name
    #[arg(long, default_value = "items")]
    source_collection: String,

    /// Destination Table Name
    #[arg(long, default_value = "items")]
    destination_table: String,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();
    let env_path = Path::new(env!("CARGO_MANIFEST_DIR")).join(".env");
    dotenvy::from_path(&env_path).ok();

    let args = Args::parse();

    tracing::info!("Starting data-connector...");

    let auth_handler = YbAuthHandler::new(
        args.apihub_domain.clone(),
        args.ditto_user_id.clone(),
        args.ditto_app_id.clone(),
    );

    let ditto = Ditto::builder()
        .with_root(Arc::new(PersistentRoot::new("ditto_data")?))
        .with_identity(|root| {
            OnlineWithAuthentication::new(
                root,
                AppId::from_str(&args.ditto_app_id)?,
                auth_handler,
                true,
                None,
            )
        })?
        .build()?;

    let ditto = Arc::new(ditto);
    ditto.start_sync()?;

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&args.database_url)
        .await?;

    let source = DittoSource::new(ditto, &args.source_collection);
    let destination = SupabaseDestination::new(pool, &args.destination_table);

    let pipeline = Pipeline::new(source, destination);

    tracing::info!("Pipeline running. Syncing from Ditto to Supabase...");
    pipeline.run().await?;

    Ok(())
}
