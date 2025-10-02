# Ditto Sync Optimization

## Problem
The app was experiencing severe database locking issues during Ditto synchronization:
- Database locked for 10+ seconds
- Mass upserts on app startup causing SQLite failures
- Ditto observers triggering upserts even when no data changed
- Infinite loop of upserts between Ditto and SQLite

## Root Causes
1. **Initial fetch triggers mass upserts**: When observers start, they fetch ALL existing documents and try to upsert them immediately
2. **No change detection**: Every document from Ditto triggers an upsert, even if the data is identical
3. **Concurrent operations**: All upserts happen simultaneously, overwhelming SQLite
4. **Immediate startup**: Sync starts before app is fully initialized

## Solutions Implemented

### 1. Change Detection (Hash-based)
**File**: `ditto_sync_coordinator.dart`
- Added `_documentHashes` map to track document content
- Calculate hash of each document to detect actual changes
- Skip upserts when document content hasn't changed
- Only process documents with actual data changes

```dart
final currentHash = _calculateHash(payload);
final previousHash = _documentHashes[type]?[docId];

if (!isInitialFetch && previousHash == currentHash) {
  // Skip unchanged document
  continue;
}
```

### 2. Batch Processing with Delays
**File**: `ditto_sync_coordinator.dart`
- Process upserts in small batches (5 at a time)
- Add 100ms delay between batches
- Prevents database locking by spreading operations over time
- Use `Future.wait()` for parallel processing within batches

```dart
const batchSize = 5;
const delayBetweenBatches = Duration(milliseconds: 100);

for (var i = 0; i < upsertTasks.length; i += batchSize) {
  final batch = upsertTasks.sublist(i, end);
  await Future.wait(batch);
  if (end < upsertTasks.length) {
    await Future.delayed(delayBetweenBatches);
  }
}
```

### 3. Skip Initial Fetch on Startup
**File**: `ditto_sync_coordinator.dart` & `ditto_sync_registry.dart`
- Added `skipInitialFetch` parameter to `setDitto()`
- On app startup, skip the initial fetch of all documents
- Only listen for actual changes going forward
- Prevents mass upserts when app starts

```dart
await DittoSyncCoordinator.instance.setDitto(ditto, skipInitialFetch: true);
```

### 4. Startup Delay
**File**: `ditto_sync_registry.dart`
- Added 3-second delay before starting Ditto sync
- Allows app to fully initialize first
- Repository, database, and UI are ready before sync begins

```dart
await Future.delayed(const Duration(seconds: 3));
await DittoSyncCoordinator.instance.setDitto(ditto, skipInitialFetch: true);
```

### 5. Improved Logging
- More descriptive log messages
- Document IDs in logs for better debugging
- Batch processing progress indicators
- Clear indicators of skipped operations

## Benefits

1. **No more database locking**: Batched operations prevent SQLite from being overwhelmed
2. **Faster startup**: App doesn't try to sync everything on launch
3. **Reduced unnecessary work**: Only process actual changes, not duplicate data
4. **Better performance**: Fewer database operations = faster app
5. **Loop prevention**: Change detection prevents ping-pong between Ditto and SQLite

## Configuration

You can adjust these values in `ditto_sync_coordinator.dart`:

```dart
// Batch size (number of concurrent upserts)
const batchSize = 5;

// Delay between batches (milliseconds)
const delayBetweenBatches = Duration(milliseconds: 100);
```

And in `ditto_sync_registry.dart`:

```dart
// Startup delay before Ditto sync begins
await Future.delayed(const Duration(seconds: 3));
```

## Testing

To test the changes:
1. Launch the app fresh
2. Verify no mass upserts in logs
3. Create/update data on another device
4. Verify only changed items sync
5. Check no database locking warnings

## Future Improvements

Consider these additional optimizations:
1. **Smart batching**: Adjust batch size based on device performance
2. **Priority queue**: Sync user-facing data before background data
3. **Incremental sync**: Track last sync timestamp, only fetch newer documents
4. **Conflict resolution**: Better handling when same document changes on multiple devices
5. **Retry logic**: Exponential backoff for failed upserts
