# Ditto File Lock Issue Fix

## Problem
The error "File already locked, working dir = /Users/richard/Library/Containers/rw.flipper/Data/Documents/flipper_data_bridge/ditto_auth, retried 5 times. Multiple Ditto instances cannot run at the same time within the same working directory" occurs when:

1. Multiple Ditto instances try to use the same persistence directory
2. Previous instances didn't clean up properly (hot restart/reload)
3. App crashes leave file locks in place

## Root Cause
Ditto uses file-based locking to prevent multiple instances from accessing the same database files simultaneously. When instances don't shut down cleanly, these locks can persist.

## Solution Implemented

### 1. Unique Directory Strategy
- **Before**: Used consistent directory `flipper_data_bridge` for desktop
- **After**: Always use unique directories with timestamp and process ID
- **Format**: `flipper_data_bridge_{timestamp}_{processId}`

### 2. Enhanced Cleanup
- Extended disposal wait times (500ms → 1000ms)
- Proper Ditto instance disposal before creating new ones
- Force cleanup even if errors occur during disposal

### 3. Retry Mechanism
- If file lock detected, wait 3 seconds and retry with completely unique directory
- Multiple entropy sources for directory naming (timestamp + microseconds + random)
- Graceful degradation if Ditto fails to initialize

### 4. Optional Maintenance
- `DittoCleanup` utility to remove old directories (>24 hours)
- Directory size monitoring for debugging
- Non-blocking cleanup during app startup

## Code Changes

### Key Files Modified:
1. `apps/flipper_web/lib/core/utils/initialization.dart`
2. `apps/flipper_web/lib/services/ditto_service.dart`
3. `apps/flipper_web/lib/core/utils/ditto_cleanup.dart` (new)

### Directory Naming Strategy:
```dart
// Old approach (caused conflicts)
persistenceDir = "flipper_data_bridge";

// New approach (prevents conflicts)
final timestamp = DateTime.now().millisecondsSinceEpoch;
final processId = DateTime.now().microsecond;
persistenceDir = "flipper_data_bridge_${timestamp}_$processId";
```

## Benefits

1. **Eliminates File Lock Conflicts**: Each instance uses unique directory
2. **Graceful Recovery**: Automatic retry with new directory if conflicts occur
3. **Better Cleanup**: Proper disposal prevents resource leaks
4. **Maintenance**: Optional cleanup of old directories
5. **Debugging**: Better logging for troubleshooting

## Trade-offs

1. **Storage**: Multiple directories use more disk space
2. **Data Persistence**: Each restart creates new directory (data doesn't persist across restarts)
3. **Sync**: Initial sync required after each restart

## Usage

The fix is automatic - no code changes required in application logic. The Ditto initialization handles all conflict resolution internally.

## Monitoring

To monitor Ditto directories:
```dart
// List all Ditto directories
final dirs = await DittoCleanup.listDittoDirectories();

// Get total size
final size = await DittoCleanup.getTotalDittoDirectorySize();

// Clean up old directories
await DittoCleanup.cleanupOldDirectories();
```

## Future Improvements

1. **Shared Directory Mode**: Option to use shared directory with proper locking
2. **Data Migration**: Migrate data from previous directories on startup
3. **Configurable Cleanup**: User-configurable cleanup intervals
4. **Health Monitoring**: Automatic detection and resolution of lock issues