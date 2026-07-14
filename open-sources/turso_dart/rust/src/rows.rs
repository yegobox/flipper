use std::future::Future;

use crate::error::{Error, Result};
use crate::statement::Statement;
use crate::value::Value;

pub struct Rows {
    inner: Statement,
}

impl Rows {
    pub fn new(inner: Statement) -> Self {
        Self { inner }
    }

    pub fn column_count(&self) -> usize {
        self.inner.column_count()
    }

    pub fn column_name(&self, idx: usize) -> Result<String> {
        self.inner.column_name(idx)
    }

    pub fn column_names(&self) -> Vec<String> {
        self.inner.column_names()
    }

    pub fn column_index(&self, name: &str) -> Result<usize> {
        self.inner.column_index(name)
    }

    pub fn columns(&self) -> Vec<Column> {
        self.inner.columns()
    }

    pub async fn next(&mut self) -> Result<Option<Row>> {
        struct Next {
            columns: usize,
            stmt: Statement,
        }

        impl Future for Next {
            type Output = Result<Option<Row>>;

            fn poll(
                self: std::pin::Pin<&mut Self>,
                cx: &mut std::task::Context<'_>,
            ) -> std::task::Poll<Self::Output> {
                self.stmt.step(Some(self.columns), cx)
            }
        }

        let next = Next {
            columns: self.inner.column_count(),
            stmt: self.inner.clone(),
        };

        next.await
    }
}

pub struct Row {
    pub values: Vec<turso_sdk_kit::rsapi::Value>,
}

impl Row {
    pub fn get_value(&self, idx: usize) -> Result<Value> {
        let val = self.values.get(idx).ok_or_else(|| {
            Error::new(&format!(
                "column index {idx} out of bounds (row has {} columns)",
                self.values.len()
            ))
        })?;
        match val {
            turso_sdk_kit::rsapi::Value::Numeric(turso_sdk_kit::rsapi::Numeric::Integer(i)) => {
                Ok(Value::Integer(*i))
            }
            turso_sdk_kit::rsapi::Value::Numeric(turso_sdk_kit::rsapi::Numeric::Float(f)) => {
                Ok(Value::Real(f64::from(*f)))
            }
            turso_sdk_kit::rsapi::Value::Null => Ok(Value::Null),
            turso_sdk_kit::rsapi::Value::Text(text) => {
                Ok(Value::Text(text.value.clone().into_owned()))
            }
            turso_sdk_kit::rsapi::Value::Blob(items) => Ok(Value::Blob(items.to_vec())),
        }
    }

    pub fn get<T>(&self, idx: usize) -> Result<T>
    where
        T: turso_sdk_kit::rsapi::FromValue,
    {
        let val = self.values.get(idx).ok_or_else(|| {
            Error::new(&format!(
                "column index {idx} out of bounds (row has {} columns)",
                self.values.len()
            ))
        })?;
        T::from_sql(val.clone()).map_err(|err| Error::new(&err.to_string()))
    }

    pub fn column_count(&self) -> usize {
        self.values.len()
    }
}

pub struct Column {
    pub name: String,
    pub decl_type: Option<String>,
}

impl Column {
    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn decl_type(&self) -> Option<&str> {
        self.decl_type.as_deref()
    }
}
