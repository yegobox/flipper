#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct FFIResponse {
  void *ptr;
  char *error_message;
} FFIResponse;

typedef struct FFIBoolResponse {
  bool value;
  char *error_message;
} FFIBoolResponse;

typedef struct FFIStringResponse {
  char *value;
  char *error_message;
} FFIStringResponse;

struct FFIResponse init(void);

struct FFIResponse connect_local(const char *config_json);

struct FFIResponse connect_sync(const char *config_json);

struct FFIResponse database_connect(void *db_ptr);

struct FFIBoolResponse database_pull(void *db_ptr);

struct FFIResponse database_push(void *db_ptr);

void database_dispose(void *db_ptr);

struct FFIStringResponse connection_query(void *conn_ptr, const char *sql, const char *params_json);

struct FFIResponse connection_execute(void *conn_ptr, const char *sql, const char *params_json);

struct FFIResponse connection_execute_batch(void *conn_ptr, const char *sql);

struct FFIResponse connection_prepare(void *conn_ptr, const char *sql);

struct FFIResponse connection_prepare_cached(void *conn_ptr, const char *sql);

struct FFIResponse connection_prepare_execute_batch(void *conn_ptr, const char *sql);

struct FFIResponse connection_transaction(void *conn_ptr, const char *behavior);

void connection_dispose(void *conn_ptr);

struct FFIStringResponse statement_query(void *stmt_ptr, const char *params_json);

struct FFIResponse statement_execute(void *stmt_ptr, const char *params_json);

void statement_dispose(void *stmt_ptr);

struct FFIResponse transaction_prepare(void *tx_ptr, const char *sql);

struct FFIResponse transaction_commit(void *tx_ptr);

struct FFIResponse transaction_rollback(void *tx_ptr);

void transaction_dispose(void *tx_ptr);

void free_string(char *ptr);
