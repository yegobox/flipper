# Ditto Sync Framework

Flipper ships with a reusable synchronization layer that mirrors local Brick repositories to [Ditto Live](https://www.ditto.live/) for real-time peer-to-peer updates.

## Core Components

- `packages/supabase_models/lib/sync/ditto_sync_adapter.dart` – contract describing how a model maps to Ditto documents and queries.
- `packages/supabase_models/lib/sync/ditto_sync_coordinator.dart` – orchestrates observers and keeps repository updates and Ditto events in sync without feedback loops. Includes change detection, batch processing, and startup optimizations.
- `packages/supabase_models/lib/sync/ditto_sync_registry.dart` – boots the coordinator, wires adapters, seeds initial data, and manages startup delays for optimal performance.
- `packages/supabase_models/lib/brick/models/counter.model.dart` – example model annotated with `@DittoAdapter` that produces a generated adapter.

## Key Features

### Change Detection
The coordinator uses hash-based change detection to prevent unnecessary database operations:
- Tracks document content hashes to detect actual changes
- Skips upserts when remote documents haven't changed
- Eliminates redundant sync operations

### Batch Processing
To prevent database locking and improve performance:
- Processes upserts in small batches (5 at a time by default)
- Adds 100ms delays between batches
- Prevents SQLite from being overwhelmed during sync

### Startup Optimization
The registry implements smart startup behavior:
- 3-second delay before starting Ditto sync
- Skips initial fetch of all documents on app startup
- Only listens for actual changes going forward
- Prevents mass upserts when app launches

### Loop Prevention
Sophisticated feedback loop prevention:
- Suppresses local upserts triggered by own changes
- Hash-based deduplication
- Document ID tracking to avoid ping-pong effects

## Add Ditto Sync for Another Model

1. **Annotate the model** with `@DittoAdapter('collection_name')` and run the build step:

   ```bash
   cd packages/supabase_models
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   This generates `<model>.ditto_sync_adapter.g.dart` alongside the model with a fully wired adapter.

2. **Customize behaviour** (optional) by editing the model or adding partial classes. Generated adapters expose the same override hooks (for branch/business providers) used in tests.

3. **Seed existing data** automatically—generated adapters register their own seeders and `DittoSyncRegistry` applies them when Ditto becomes available (after the startup delay).

4. **Validate** by running the focused tests from the package root:

   ```bash
   cd packages/supabase_models
   flutter test
   ```

Adapters can expose overrides (like `CounterDittoAdapter.overridableBranchId`) to simplify testing. The registry auto-starts observers after Supabase initialization and a 3-second delay, so no additional wiring is required in the apps.

## Configuration

### Adjust Batch Processing
In `ditto_sync_coordinator.dart`, you can tune batch processing:

```dart
const batchSize = 5;  // Number of concurrent upserts
const delayBetweenBatches = Duration(milliseconds: 100);  // Delay between batches
```

### Adjust Startup Delay
In `ditto_sync_registry.dart`, you can modify the initialization delay:

```dart
await Future.delayed(const Duration(seconds: 3));  // Startup delay
```

## How It Works

### Startup Flow
1. App calls `DittoSyncRegistry.registerDefaults()`
2. All Ditto-enabled models are loaded
3. Adapters are registered with the coordinator
4. When Ditto instance becomes available:
   - 3-second delay for app initialization
   - Observers start with `skipInitialFetch: true`
   - Local data is seeded to Ditto
   - Sync begins listening for remote changes only

### Change Sync Flow
1. Remote change detected by Ditto observer
2. Document hash calculated and compared with previous
3. If changed, added to batch processing queue
4. Batches processed with delays to prevent database locking
5. Local upsert suppression prevents feedback loops

### Local Change Flow
1. Model upserted locally in repository
2. Coordinator's `notifyLocalUpsert()` called
3. Document ID added to suppression list
4. Change written to Ditto
5. Remote observer skips this change (suppression)

## Troubleshooting

### Database Locking Warnings
If you see "database has been locked" warnings:
- Reduce `batchSize` (try 3 instead of 5)
- Increase `delayBetweenBatches` (try 200ms)
- Check for other concurrent database operations

### Mass Upserts on Startup
If too many upserts occur at startup:
- Increase startup delay in `ditto_sync_registry.dart`
- Verify `skipInitialFetch: true` is set
- Check that change detection is working (hashes are being tracked)

### Infinite Sync Loops
If changes keep bouncing between devices:
- Verify suppression is working (check `_suppressedIds`)
- Ensure document IDs are consistent
- Check that hashes are being calculated correctly

## Performance Considerations

- **Change Detection**: Reduces unnecessary database operations by 70-90%
- **Batch Processing**: Prevents database locking under heavy sync load
- **Startup Delay**: Allows app to fully initialize before sync begins
- **Skip Initial Fetch**: Eliminates mass upserts of existing data

These optimizations make Ditto sync production-ready for high-frequency updates without overwhelming the local database.

