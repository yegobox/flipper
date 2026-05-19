use crate::{DataEvent, Destination, Error};
use async_trait::async_trait;
use sqlx::{Pool, Postgres};

pub struct SupabaseDestination {
    pool: Pool<Postgres>,
    table_name: String,
}

impl SupabaseDestination {
    pub fn new(pool: Pool<Postgres>, table_name: &str) -> Self {
        Self {
            pool,
            table_name: table_name.to_string(),
        }
    }
}

#[async_trait]
impl Destination for SupabaseDestination {
    async fn write(&self, event: DataEvent) -> Result<(), Error> {
        match event {
            DataEvent::Insert(value) => {
                sqlx::query(&format!("INSERT INTO {} (data) VALUES ($1)", self.table_name))
                    .bind(value)
                    .execute(&self.pool)
                    .await
                    .map_err(|e| Error::Destination(e.into()))?;
            }
            DataEvent::Update(_value) => {
                // Example: UPDATE table_name SET data = $1 WHERE id = $2
            }
            DataEvent::Delete(_value) => {
                // Example: DELETE FROM table_name WHERE id = $1
            }
        }
        Ok(())
    }

    async fn write_batch(&self, events: Vec<DataEvent>) -> Result<(), Error> {
        for event in events {
            self.write(event).await?;
        }
        Ok(())
    }
}
