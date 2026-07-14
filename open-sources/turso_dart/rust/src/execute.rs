use std::task::Poll;

use crate::{error::Result, statement::Statement};

pub struct Execute {
    stmt: Statement,
}

impl Future for Execute {
    type Output = Result<u64>;

    fn poll(
        self: std::pin::Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Self::Output> {
        match self.stmt.step(None, cx)? {
            Poll::Ready(_) => {
                let n_change = self.stmt.n_change();
                Poll::Ready(Ok(n_change as u64))
            }
            Poll::Pending => Poll::Pending,
        }
    }
}

impl Execute {
    pub fn new(stmt: Statement) -> Execute {
        Execute { stmt }
    }
}
