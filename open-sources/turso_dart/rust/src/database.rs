use std::sync::Arc;

use serde::Deserialize;
use turso_sdk_kit::rsapi::TursoError;

use crate::{connection::Connection, error::Result};

pub trait Database {
    fn connect(&self) -> impl std::future::Future<Output = Result<Connection>> + Send;
}

#[derive(Clone)]
pub struct LocalDb {
    inner: Arc<turso_sdk_kit::rsapi::TursoDatabase>,
}

impl Database for LocalDb {
    async fn connect(&self) -> Result<Connection> {
        let conn = self.inner.connect()?;
        Ok(Connection::create(conn, None))
    }
}

impl LocalDb {
    pub async fn new(config: &LocalDbConfig) -> Result<Self> {
        let features = LocalDb::build_features_string(config);
        let encryption = if let Some(encryption_opts_chiper) = &config.encryption_opts_chiper
            && let Some(encryption_opts_hexkey) = &config.encryption_opts_hexkey
        {
            Some(turso_sdk_kit::rsapi::EncryptionOpts {
                cipher: encryption_opts_chiper.clone(),
                hexkey: encryption_opts_hexkey.clone(),
            })
        } else {
            None
        };
        let db =
            turso_sdk_kit::rsapi::TursoDatabase::new(turso_sdk_kit::rsapi::TursoDatabaseConfig {
                path: config.path.clone(),
                experimental_features: features,
                async_io: true,
                encryption: encryption,
                vfs: config.vfs.clone(),
                io: None,
                db_file: None,
            });
        while let Some(io_c) = db.open()?.io() {
            // At this point IO must already be created
            let io = db
                .io()
                .expect("IO must have been set on the first call to db open");
            io_c.wait_async(io.as_ref())
                .await
                .map_err(TursoError::from)?;
        }
        Ok(Self { inner: db })
    }

    fn build_features_string(config: &LocalDbConfig) -> Option<String> {
        let mut features = Vec::new();
        if config.enable_encryption {
            features.push("encryption");
        }
        if config.enable_attach {
            features.push("attach");
        }
        if config.enable_custom_types {
            features.push("custom_types");
        }
        if config.enable_index_method {
            features.push("index_method");
        }
        if config.enable_materialized_views {
            features.push("views");
        }
        if config.enable_vacuum {
            features.push("vacuum");
        }
        if config.enable_generated_columns {
            features.push("generated_columns");
        }
        if config.enable_multiprocess_wal {
            features.push("multiprocess_wal");
        }
        if config.enable_without_rowid {
            features.push("without_rowid");
        }
        if features.is_empty() {
            return None;
        }
        Some(features.join(","))
    }
}

#[derive(Deserialize)]
pub struct LocalDbConfig {
    path: String,
    enable_encryption: bool,
    enable_attach: bool,
    enable_custom_types: bool,
    enable_index_method: bool,
    enable_materialized_views: bool,
    enable_vacuum: bool,
    enable_generated_columns: bool,
    enable_multiprocess_wal: bool,
    enable_without_rowid: bool,
    vfs: Option<String>,
    encryption_opts_chiper: Option<String>,
    encryption_opts_hexkey: Option<String>,
}
