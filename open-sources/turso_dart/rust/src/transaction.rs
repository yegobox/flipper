use std::{str::FromStr, sync::Arc};

use crate::{
    connection::Connection,
    error::{Error, Result},
    params::Params,
    statement::Statement,
};

pub enum TransactionBehavior {
    Deferred,
    Immediate,
    Exclusive,
}

impl FromStr for TransactionBehavior {
    type Err = Error;
    fn from_str(s: &str) -> Result<Self> {
        match s {
            "deferred" => Ok(TransactionBehavior::Deferred),
            "immediate" => Ok(TransactionBehavior::Immediate),
            "exclusive" => Ok(TransactionBehavior::Exclusive),
            _ => Err(Error::new("invalid transaction behavior")),
        }
    }
}

pub struct Transaction {
    conn: Arc<Connection>,
}

impl Transaction {
    pub async fn new(conn: Connection, behavior: TransactionBehavior) -> Result<Transaction> {
        let query = match behavior {
            TransactionBehavior::Deferred => "BEGIN DEFERRED",
            TransactionBehavior::Immediate => "BEGIN IMMEDIATE",
            TransactionBehavior::Exclusive => "BEGIN EXCLUSIVE",
        };
        conn.execute(query, Params::None)
            .await
            .map(move |_| Transaction {
                conn: Arc::new(conn),
            })
    }

    pub async fn prepare(&self, sql: &str) -> Result<Statement> {
        self.conn.prepare(sql).await
    }

    pub async fn commit(self) -> Result<()> {
        let _ = self.conn.execute("COMMIT", Params::None).await;
        Ok(())
    }

    pub async fn rollback(self) -> Result<()> {
        self.conn.execute("ROLLBACK", Params::None).await?;
        Ok(())
    }
}
