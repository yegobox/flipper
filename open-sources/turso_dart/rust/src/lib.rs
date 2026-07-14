use std::{
    ffi::{CString, c_char, c_void},
    str::FromStr,
    sync::OnceLock,
};

use tokio::runtime::Runtime;

use crate::{
    connection::Connection,
    database::{Database, LocalDb, LocalDbConfig},
    error::Error,
    ffi_helpers::{c_char_to_str, convert_rows_to_json, json_to_params},
    ffi_response::{FFIBoolResponse, FFIResponse, FFIStringResponse},
    statement::Statement,
    sync::{SyncDatabase, SyncDb, SyncDbConfig},
    transaction::{Transaction, TransactionBehavior},
};

pub mod connection;
pub mod database;
pub mod error;
pub mod execute;
pub mod ffi_helpers;
pub mod ffi_response;
pub mod io_worker;
pub mod params;
pub mod rows;
pub mod statement;
pub mod sync;
pub mod transaction;
pub mod value;

pub enum DbHandle {
    Local(LocalDb),
    Sync(SyncDb),
}

static RUNTIME: OnceLock<Runtime> = OnceLock::new();

fn runtime() -> &'static Runtime {
    RUNTIME
        .get()
        .expect("runtime not initialized — call init first")
}

#[unsafe(no_mangle)]
pub extern "C" fn init() -> FFIResponse {
    // init_logger(is_debug);

    RUNTIME.get_or_init(|| {
        tokio::runtime::Builder::new_multi_thread()
            .enable_all()
            .build()
            .expect("failed to build tokio runtime")
    });

    FFIResponse::ok(std::ptr::null_mut())
}

#[unsafe(no_mangle)]
pub extern "C" fn connect_local(config_json: *const c_char) -> FFIResponse {
    let json = match unsafe { c_char_to_str(config_json) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };

    let config: LocalDbConfig = match serde_json::from_str(json) {
        Ok(config) => config,
        Err(e) => return FFIResponse::err(e.into()),
    };

    let handle = match runtime().block_on(LocalDb::new(&config)) {
        Ok(db) => DbHandle::Local(db),
        Err(e) => return FFIResponse::err(e),
    };

    FFIResponse::ok(Box::into_raw(Box::new(handle)) as *mut c_void)
}

#[unsafe(no_mangle)]
pub extern "C" fn connect_sync(config_json: *const c_char) -> FFIResponse {
    let json = match unsafe { c_char_to_str(config_json) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };

    let config: SyncDbConfig = match serde_json::from_str(json) {
        Ok(config) => config,
        Err(e) => return FFIResponse::err(e.into()),
    };

    let handle = match runtime().block_on(SyncDb::new(config)) {
        Ok(db) => DbHandle::Sync(db),
        Err(e) => return FFIResponse::err(e),
    };

    FFIResponse::ok(Box::into_raw(Box::new(handle)) as *mut c_void)
}

#[unsafe(no_mangle)]
pub extern "C" fn database_connect(db_ptr: *mut c_void) -> FFIResponse {
    let handle = unsafe { &*(db_ptr as *mut DbHandle) };
    match handle {
        DbHandle::Local(db) => {
            let connection = match runtime().block_on(db.connect()) {
                Ok(connection) => connection,
                Err(e) => return FFIResponse::err(e),
            };
            FFIResponse::ok(Box::into_raw(Box::new(connection)) as *mut c_void)
        }
        DbHandle::Sync(db) => {
            let connection = match runtime().block_on(db.connect()) {
                Ok(connection) => connection,
                Err(e) => return FFIResponse::err(e),
            };
            FFIResponse::ok(Box::into_raw(Box::new(connection)) as *mut c_void)
        }
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn database_pull(db_ptr: *mut c_void) -> FFIBoolResponse {
    let handle = unsafe { &*(db_ptr as *mut DbHandle) };
    match handle {
        DbHandle::Sync(db) => {
            let has_changes = match runtime().block_on(db.pull()) {
                Ok(has_changes) => has_changes,
                Err(e) => return FFIBoolResponse::err(e),
            };
            FFIBoolResponse::ok(has_changes)
        }
        _ => FFIBoolResponse::err(Error::new("not a sync db")),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn database_push(db_ptr: *mut c_void) -> FFIResponse {
    let handle = unsafe { &*(db_ptr as *mut DbHandle) };
    match handle {
        DbHandle::Sync(db) => match runtime().block_on(db.push()) {
            Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
            Err(e) => return FFIResponse::err(e),
        },
        _ => FFIResponse::err(Error::new("not a sync db")),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn database_dispose(db_ptr: *mut c_void) {
    if !db_ptr.is_null() {
        let _ = unsafe { Box::from_raw(db_ptr as *mut DbHandle) };
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_query(
    conn_ptr: *mut c_void,
    sql: *const c_char,
    params_json: *const c_char,
) -> FFIStringResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIStringResponse::err(e),
    };
    let params = match json_to_params(params_json) {
        Ok(params) => params,
        Err(e) => return FFIStringResponse::err(e),
    };
    match runtime().block_on(async {
        let mut rows = connection.query(sql, params).await?;
        convert_rows_to_json(&mut rows).await
    }) {
        Ok(json) => FFIStringResponse::ok(json),
        Err(e) => FFIStringResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_execute(
    conn_ptr: *mut c_void,
    sql: *const c_char,
    params_json: *const c_char,
) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };
    let params = match json_to_params(params_json) {
        Ok(params) => params,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        connection.execute(sql, params).await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_execute_batch(
    conn_ptr: *mut c_void,
    sql: *const c_char,
) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        connection.execute_batch(sql).await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_prepare(conn_ptr: *mut c_void, sql: *const c_char) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        let statement = connection.prepare(sql).await?;
        Ok(Box::into_raw(Box::new(statement)) as *mut c_void)
    }) {
        Ok(ptr) => FFIResponse::ok(ptr),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_prepare_cached(
    conn_ptr: *mut c_void,
    sql: *const c_char,
) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        let statement = connection.prepare_cached(sql).await?;
        Ok(Box::into_raw(Box::new(statement)) as *mut c_void)
    }) {
        Ok(ptr) => FFIResponse::ok(ptr),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_prepare_execute_batch(
    conn_ptr: *mut c_void,
    sql: *const c_char,
) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(json) => json,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        connection.prepare_execute_batch(sql).await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_transaction(
    conn_ptr: *mut c_void,
    behavior: *const c_char,
) -> FFIResponse {
    let connection = unsafe { &*(conn_ptr as *mut Connection) };
    let behavior = match unsafe { c_char_to_str(behavior) } {
        Ok(behavior) => match TransactionBehavior::from_str(behavior) {
            Ok(behavior) => behavior,
            Err(e) => return FFIResponse::err(e),
        },
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        let transaction = connection.transaction(behavior).await?;
        Ok(Box::into_raw(Box::new(transaction)) as *mut c_void)
    }) {
        Ok(ptr) => FFIResponse::ok(ptr),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn connection_dispose(conn_ptr: *mut c_void) {
    if !conn_ptr.is_null() {
        let _ = unsafe { Box::from_raw(conn_ptr as *mut Connection) };
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn statement_query(
    stmt_ptr: *mut c_void,
    params_json: *const c_char,
) -> FFIStringResponse {
    let statement = unsafe { &mut *(stmt_ptr as *mut Statement) };
    let params = match json_to_params(params_json) {
        Ok(params) => params,
        Err(e) => return FFIStringResponse::err(e),
    };
    match runtime().block_on(async {
        let mut rows = statement.query(params).await?;
        convert_rows_to_json(&mut rows).await
    }) {
        Ok(json) => FFIStringResponse::ok(json),
        Err(e) => FFIStringResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn statement_execute(
    stmt_ptr: *mut c_void,
    params_json: *const c_char,
) -> FFIResponse {
    let statement = unsafe { &mut *(stmt_ptr as *mut Statement) };
    let params = match json_to_params(params_json) {
        Ok(params) => params,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        statement.execute(params).await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn statement_dispose(stmt_ptr: *mut c_void) {
    if !stmt_ptr.is_null() {
        let _ = unsafe { Box::from_raw(stmt_ptr as *mut Statement) };
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn transaction_prepare(tx_ptr: *mut c_void, sql: *const c_char) -> FFIResponse {
    let transaction = unsafe { &mut *(tx_ptr as *mut Transaction) };
    let sql = match unsafe { c_char_to_str(sql) } {
        Ok(sql) => sql,
        Err(e) => return FFIResponse::err(e),
    };
    match runtime().block_on(async {
        let statement = transaction.prepare(sql).await?;
        Ok(Box::into_raw(Box::new(statement)) as *mut c_void)
    }) {
        Ok(ptr) => FFIResponse::ok(ptr),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn transaction_commit(tx_ptr: *mut c_void) -> FFIResponse {
    let transaction = unsafe { Box::from_raw(tx_ptr as *mut Transaction) };
    match runtime().block_on(async {
        transaction.commit().await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn transaction_rollback(tx_ptr: *mut c_void) -> FFIResponse {
    let transaction = unsafe { Box::from_raw(tx_ptr as *mut Transaction) };
    match runtime().block_on(async {
        transaction.rollback().await?;
        Ok(())
    }) {
        Ok(()) => FFIResponse::ok(std::ptr::null_mut()),
        Err(e) => FFIResponse::err(e),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn transaction_dispose(tx_ptr: *mut c_void) {
    if !tx_ptr.is_null() {
        let _ = unsafe { Box::from_raw(tx_ptr as *mut Transaction) };
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn free_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe {
            drop(CString::from_raw(ptr));
        }
    }
}
