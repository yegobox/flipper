use std::{
    sync::{Arc, Mutex},
    task::Poll,
};

use turso_sdk_kit::rsapi::TursoStatement;

use crate::{
    connection::Connection,
    error::{Error, Result},
    execute::Execute,
    params::Params,
    rows::{Column, Row, Rows},
};

#[derive(Clone)]
pub struct Statement {
    inner: Arc<Mutex<Box<TursoStatement>>>,
    conn: Connection,
}

impl Statement {
    pub fn new(stmt: Box<TursoStatement>, conn: Connection) -> Self {
        Self {
            inner: Arc::new(Mutex::new(stmt)),
            conn,
        }
    }

    pub fn step(
        &self,
        columns: Option<usize>,
        cx: &mut std::task::Context<'_>,
    ) -> Poll<Result<Option<Row>>> {
        let mut stmt = self.inner.lock().unwrap();
        match stmt.step(Some(cx.waker()))? {
            turso_sdk_kit::rsapi::TursoStatusCode::Row => {
                if let Some(columns) = columns {
                    let mut values = Vec::with_capacity(columns);
                    for i in 0..columns {
                        let value = stmt.row_value(i)?;
                        values.push(value);
                    }
                    Poll::Ready(Ok(Some(Row { values })))
                } else {
                    Poll::Ready(Err(Error::new("unexpected row during execution")))
                }
            }
            turso_sdk_kit::rsapi::TursoStatusCode::Done => Poll::Ready(Ok(None)),
            turso_sdk_kit::rsapi::TursoStatusCode::Io => {
                stmt.run_io()?;
                if let Some(extra_io) = &self.conn.extra_io {
                    extra_io(cx.waker().clone())?;
                }
                Poll::Pending
            }
        }
    }

    pub async fn query(&mut self, params: Params) -> Result<Rows> {
        self.reset()?;

        let mut stmt = self.inner.lock().unwrap();
        match params {
            Params::None => (),
            Params::Positional(values) => {
                for (i, value) in values.into_iter().enumerate() {
                    stmt.bind_positional(i + 1, value.into())?;
                }
            }
            Params::Named(values) => {
                for (name, value) in values.into_iter() {
                    let position = stmt.named_position(name)?;
                    stmt.bind_positional(position, value.into())?;
                }
            }
        }

        let rows = Rows::new(self.clone());
        Ok(rows)
    }

    pub async fn execute(&mut self, params: Params) -> Result<u64> {
        self.reset()?;

        match params {
            Params::None => (),
            Params::Positional(values) => {
                for (i, value) in values.into_iter().enumerate() {
                    let mut stmt = self.inner.lock().unwrap();
                    stmt.bind_positional(i + 1, value.into())?;
                }
            }
            Params::Named(values) => {
                for (name, value) in values.into_iter() {
                    let mut stmt = self.inner.lock().unwrap();
                    let position = stmt.named_position(name)?;
                    stmt.bind_positional(position, value.into())?;
                }
            }
        }

        let execute = Execute::new(self.clone());
        execute.await
    }

    pub fn column_count(&self) -> usize {
        self.inner.lock().unwrap().column_count()
    }

    pub fn column_name(&self, idx: usize) -> Result<String> {
        let stmt = self.inner.lock().unwrap();
        if idx >= stmt.column_count() {
            return Err(Error::new(&format!(
                "column index {idx} out of bounds (statement has {} columns)",
                stmt.column_count()
            )));
        }
        Ok(stmt
            .column_name(idx)
            .expect("column index must be within valid range"))
    }

    pub fn column_names(&self) -> Vec<String> {
        let stmt = self.inner.lock().unwrap();
        let n = stmt.column_count();
        (0..n)
            .map(|i| {
                stmt.column_name(i)
                    .expect("column index must be within valid range")
            })
            .collect()
    }

    pub fn column_index(&self, name: &str) -> Result<usize> {
        let stmt = self.inner.lock().unwrap();
        let n = stmt.column_count();
        for i in 0..n {
            let col_name = stmt
                .column_name(i)
                .expect("column index must be within valid range");
            if col_name.as_str().eq_ignore_ascii_case(name) {
                return Ok(i);
            }
        }
        Err(Error::new(&format!(
            "column '{name}' not found in result set"
        )))
    }

    pub fn columns(&self) -> Vec<Column> {
        let stmt = self.inner.lock().unwrap();

        let n = stmt.column_count();

        let mut cols = Vec::with_capacity(n);

        for i in 0..n {
            let name = stmt
                .column_name(i)
                .expect("column index must be within valid range");
            let decl_type = stmt.column_decltype(i);
            cols.push(Column { name, decl_type });
        }

        cols
    }

    pub fn reset(&self) -> Result<()> {
        let mut stmt = self.inner.lock().unwrap();
        stmt.reset()?;
        Ok(())
    }

    pub fn n_change(&self) -> u64 {
        self.inner.lock().unwrap().n_change() as u64
    }
}
