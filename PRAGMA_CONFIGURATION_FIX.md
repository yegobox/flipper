# SQLite PRAGMA Configuration Fix

## Problem
PRAGMA commands were failing with error:
```
DatabaseException(Error Domain=SqfliteDarwinDatabase Code=0 "not an error" UserInfo={NSLocalizedDescription=not an error}) 
sql 'PRAGMA journal_mode=WAL;' args []
```

## Root Cause
On certain database implementations (especially sqflite on Darwin/macOS/iOS), **PRAGMA commands can only be executed during database initialization**, specifically in the `onConfigure` callback of `OpenDatabaseOptions`.

Attempting to execute PRAGMA commands after the database is already open will fail with cryptic errors.

## Solution
Moved all PRAGMA configuration into the `onConfigure` callback in `ConnectionManager.getConnection()`:

### Before (❌ Broken)
```dart
// In database_manager.dart
await connectionManager.executeOperation(dbPath, (db) async {
  await db.execute('PRAGMA journal_mode=WAL;'); // ❌ Fails on Darwin platforms
  // ... more PRAGMA commands
});
```

### After (✅ Working)
```dart
// In connection_manager.dart
final db = await _databaseFactory.openDatabase(
  path,
  options: OpenDatabaseOptions(
    onConfigure: (db) async {
      if (configurePragmas) {
        await db.execute('PRAGMA journal_mode=WAL;'); // ✅ Works on all platforms
        await db.execute('PRAGMA synchronous=FULL;');
        await db.execute('PRAGMA auto_vacuum=FULL;');
        // ... all other PRAGMA commands
      }
    },
  ),
);
```

## Changes Made

### 1. `connection_manager.dart`
- Added `configurePragmas` parameter to `getConnection()`
- Moved all PRAGMA configuration into `onConfigure` callback
- Configuration only runs when `configurePragmas: true` is passed

### 2. `database_manager.dart`
- Updated `configureDatabaseSettings()` to:
  1. Close existing connection (if any)
  2. Open new connection with `configurePragmas: true`
  3. Run integrity checks AFTER configuration

## PRAGMA Settings Applied

### Core Settings (All Platforms)
- **WAL mode**: Better concurrency and crash resistance
- **Synchronous FULL**: Safest against corruption
- **Auto-vacuum FULL**: Prevents database bloat
- **Busy timeout 30s**: Better concurrent access handling
- **WAL autocheckpoint 1000**: Regular checkpointing

### Desktop Optimizations (Windows/Linux)
- **Cache size 8MB**: Better performance
- **Page size 4096**: Optimal for modern systems
- **Temp store MEMORY**: Faster temporary operations

### Mobile Optimizations (Android/iOS)
- **Cache size 4MB**: Conservative for mobile devices

## Testing
Run the app and look for these console messages:

```
🔧 [ConnectionManager] Configuring PRAGMA settings in onConfigure...
✅ [ConnectionManager] WAL mode enabled
✅ [ConnectionManager] Synchronous mode set to FULL
✅ [ConnectionManager] Auto-vacuum enabled
✅ [ConnectionManager] Busy timeout set to 30 seconds
✅ [ConnectionManager] Cache size set to 4MB (Mobile)
✅ [ConnectionManager] WAL autocheckpoint enabled
🎉 [ConnectionManager] PRAGMA configuration completed in onConfigure!
✅ [DatabaseManager] Database integrity check passed
✅ [DatabaseManager] Database quick check passed
🎉 [DatabaseManager] Database configuration completed successfully!
```

## Why This Matters
- **Crash Resistance**: WAL mode + FULL synchronous prevents corruption
- **Performance**: Proper cache sizing and page size optimization
- **Reliability**: Integrity checks verify database health
- **Cross-Platform**: Works on all platforms (macOS, iOS, Android, Windows, Linux)

## Related Files
- `/packages/supabase_models/lib/brick/repository/connection_manager.dart`
- `/packages/supabase_models/lib/brick/repository/database_manager.dart`
- `/packages/supabase_models/lib/brick/repository.dart`
