use std::sync::Arc;
use std::task::Waker;

use crate::error::Error;
use crate::error::Result;
use crate::params::Params;
use crate::rows::Rows;
use crate::statement::Statement;
use crate::transaction::Transaction;
use crate::transaction::TransactionBehavior;

const INNER_NOT_SET: &str = "connection was not created";

#[derive(Clone)]
pub struct Connection {
    inner: Option<Arc<turso_sdk_kit::rsapi::TursoConnection>>,
    pub(crate) extra_io: Option<Arc<dyn Fn(Waker) -> Result<()> + Send + Sync>>,
}

impl Connection {
    pub fn create(
        conn: Arc<turso_sdk_kit::rsapi::TursoConnection>,
        extra_io: Option<Arc<dyn Fn(Waker) -> Result<()> + Send + Sync>>,
    ) -> Self {
        Connection {
            inner: Some(conn),
            extra_io,
        }
    }

    pub async fn query(&self, sql: &str, params: Params) -> Result<Rows> {
        let mut stmt = self.prepare(sql).await?;
        stmt.query(params).await
    }

    pub async fn execute(&self, sql: &str, params: Params) -> Result<u64> {
        let mut stmt = self.prepare(sql).await?;
        stmt.execute(params).await
    }

    pub async fn execute_batch(&self, sql: &str) -> Result<()> {
        self.prepare_execute_batch(sql).await?;
        Ok(())
    }

    pub async fn prepare(&self, sql: &str) -> Result<Statement> {
        let conn = self.inner.as_ref().ok_or(Error::new(INNER_NOT_SET))?;
        let stmt = conn.prepare_single(sql)?;
        Ok(Statement::new(stmt, self.clone()))
    }

    pub async fn prepare_cached(&self, sql: &str) -> Result<Statement> {
        let conn = self.inner.as_ref().ok_or(Error::new(INNER_NOT_SET))?;
        let stmt = conn.prepare_cached(sql)?;
        Ok(Statement::new(stmt, self.clone()))
    }

    pub async fn prepare_execute_batch(&self, sql: &str) -> Result<()> {
        let conn = self.inner.as_ref().ok_or(Error::new(INNER_NOT_SET))?;
        let mut sql: &str = sql.as_ref();
        while let Some((stmt, offset)) = conn.prepare_first(sql)? {
            let mut stmt = Statement::new(stmt, self.clone());
            let _ = stmt.execute(Params::None).await?;
            sql = &sql[offset..];
        }
        Ok(())
    }

    pub async fn transaction(&self, behavior: TransactionBehavior) -> Result<Transaction> {
        Transaction::new(self.clone(), behavior).await
    }
}
