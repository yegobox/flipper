pub mod destinations;
pub mod sources;

use async_trait::async_trait;
use futures::Stream;
use serde_json::Value;
use std::pin::Pin;

/// Represents a change event from a source.
#[derive(Debug, Clone)]
pub enum DataEvent {
    Insert(Value),
    Update(Value),
    Delete(Value),
}

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Source error: {0}")]
    Source(#[from] anyhow::Error),
    #[error("Destination error: {0}")]
    Destination(anyhow::Error),
    #[error("Other error: {0}")]
    Other(String),
}

/// A Source is responsible for providing a stream of data events.
#[async_trait]
pub trait Source: Send + Sync {
    /// Starts observing changes and returns a stream of DataEvents.
    async fn observe(
        &self,
    ) -> Result<Pin<Box<dyn Stream<Item = Result<DataEvent, Error>> + Send>>, Error>;
}

/// A Destination is responsible for receiving data and persisting it.
#[async_trait]
pub trait Destination: Send + Sync {
    /// Writes a single event to the destination.
    async fn write(&self, event: DataEvent) -> Result<(), Error>;

    /// Writes a batch of events to the destination.
    async fn write_batch(&self, events: Vec<DataEvent>) -> Result<(), Error>;
}

/// The Pipeline orchestrates the flow from Source to Destination.
pub struct Pipeline<S, D>
where
    S: Source,
    D: Destination,
{
    source: S,
    destination: D,
}

impl<S, D> Pipeline<S, D>
where
    S: Source + 'static,
    D: Destination + 'static,
{
    pub fn new(source: S, destination: D) -> Self {
        Self {
            source,
            destination,
        }
    }

    pub async fn run(self) -> anyhow::Result<()> {
        use futures::StreamExt;

        let stream = self.source.observe().await?;

        // Basic high-throughput processing: batching events.
        // We can use `ready_chunks` or similar to group events that arrive quickly.
        let mut chunks = stream.ready_chunks(100); // Batch up to 100 events

        while let Some(batch) = chunks.next().await {
            let events: Vec<DataEvent> = batch
                .into_iter()
                .filter_map(|res| res.ok())
                .collect();

            if !events.is_empty() {
                self.destination
                    .write_batch(events)
                    .await
                    .map_err(|e| anyhow::anyhow!(e))?;
            }
        }

        Ok(())
    }
}
