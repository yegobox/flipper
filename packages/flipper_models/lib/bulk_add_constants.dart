/// Max rows for editable grid + per-row TextEditingControllers.
const int kBulkEditableRowLimit = 200;

/// Files smaller than this parse on the UI isolate (avoids isolate copy overhead).
const int kBulkExcelIsolateParseMinBytes = 96 * 1024;

/// Rows shown in large-file read-only preview (each can be deleted).
const int kBulkLargeFilePreviewLimit = 20;

/// Editable page size for large imports (same granularity as preview batches).
const int kBulkLargeEditPageSize = kBulkLargeFilePreviewLimit;

/// Spreadsheet rows scanned for fast xlsx preview (header + buffer).
const int kBulkPreviewScanRowLimit = kBulkLargeFilePreviewLimit + 5;

/// When the spreadsheet "Category" cell is empty we assign this bucket (matches template sample row).
const String kBulkDefaultExcelCategoryName = 'General';

/// Rows per `POST /rra/products/bulk-add` so JSON stays under typical HTTP body limits (~2MB Axum
/// default, reverse proxies). Flutter submits multiple jobs when the import is larger.
const int kBulkRraMaxRowsPerRequest = 400;
