/// Max rows for editable grid + per-row TextEditingControllers.
const int kBulkEditableRowLimit = 200;

/// Files smaller than this parse on the UI isolate (avoids isolate copy overhead).
const int kBulkExcelIsolateParseMinBytes = 96 * 1024;

/// Rows shown in large-file read-only preview (each can be deleted).
const int kBulkLargeFilePreviewLimit = 20;
