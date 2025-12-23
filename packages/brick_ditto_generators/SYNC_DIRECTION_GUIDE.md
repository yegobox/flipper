# Ditto Sync Direction Guide

## Overview

The `@DittoAdapter` annotation now supports specifying the synchronization direction for your models. This allows fine-grained control over how data flows between your local database and Ditto's peer-to-peer network.

## Sync Direction Options

### 1. Bidirectional (Default)

**Full two-way synchronization**

```dart
@DittoAdapter('counters')
// or explicitly:
@DittoAdapter('counters', syncDirection: SyncDirection.bidirectional)
class Counter extends OfflineFirstWithSupabaseModel {
  // ...
}
```

**Behavior:**
- ✅ Seeds initial data from local DB to Ditto
- ✅ Pushes local changes to Ditto
- ✅ Receives and applies remote updates from Ditto
- ✅ Full conflict resolution and merge logic

**Use Cases:**
- Transactions
- Inventory items
- Customer records
- Any data that needs to be shared and synchronized across devices

### 2. Send-Only

**Write-only synchronization**

```dart
@DittoAdapter('audit_logs', syncDirection: SyncDirection.sendOnly)
class AuditLog extends OfflineFirstWithSupabaseModel {
  // ...
}
```

**Behavior:**
- ✅ Seeds initial data from local DB to Ditto
- ✅ Pushes all local changes to Ditto
- ❌ Does NOT fetch or apply remote updates
- ❌ `buildObserverQuery()` returns `null` to disable observation

**Use Cases:**
- Audit logs / Activity logs
- Telemetry and analytics events
- Receipts and invoices (write once, share everywhere)
- Error reports
- Usage metrics
- Any data you want to share but never need to receive back

**Benefits:**
- Reduces sync overhead (no incoming data processing)
- Perfect for append-only data
- Still benefits from Ditto's P2P distribution
- Other devices can read the data, but this device won't pull it back

### 3. Receive-Only

**Read-only synchronization**

```dart
@DittoAdapter('global_settings', syncDirection: SyncDirection.receiveOnly)
class GlobalSettings extends OfflineFirstWithSupabaseModel {
  // ...
}
```

**Behavior:**
- ❌ Does NOT seed local data to Ditto
- ❌ Does NOT push local changes
- ✅ Receives and applies remote updates from Ditto
- ✅ `buildObserverQuery()` is active for receiving data

**Use Cases:**
- Global settings and configuration
- Product catalogs
- Reference data
- Price lists
- Any centrally-managed read-only data

**Benefits:**
- Ensures local changes don't accidentally overwrite central data
- Perfect for data managed by admins or central systems
- Devices only consume, never produce

## Implementation Details

### Generated Code Differences

#### Bidirectional
```dart
@override
Future<DittoSyncQuery?> buildObserverQuery() async {
  final branchId = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
  if (branchId == null) {
    return const DittoSyncQuery(query: "SELECT * FROM counters");
  }
  return DittoSyncQuery(
    query: "SELECT * FROM counters WHERE branchId = :branchId",
    arguments: {"branchId": branchId},
  );
}
```

#### Send-Only
```dart
@override
Future<DittoSyncQuery?> buildObserverQuery() async {
  // Send-only mode: no remote observation
  return null;
}
```

### Seeding Behavior

**Important:** Seeding (initial data push) works for ALL sync directions:

- **Bidirectional**: Seeds on startup, then syncs both ways
- **Send-Only**: Seeds on startup, then only pushes new changes
- **Receive-Only**: Does NOT seed (since it shouldn't push data)

## Migration Guide

### Changing an Existing Model

If you want to change a model from bidirectional to send-only:

1. Update the annotation:
```dart
// Before
@DittoAdapter('audit_logs')

// After
@DittoAdapter('audit_logs', syncDirection: SyncDirection.sendOnly)
```

2. Regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. The generated adapter will automatically:
   - Stop observing remote changes
   - Continue seeding existing data
   - Continue pushing new local changes

### Considerations

**Data Already in Ditto:**
- Changing to `sendOnly` won't delete existing data in Ditto
- Other devices with bidirectional sync can still read/write it
- This device will just stop pulling updates

**Reverting Back:**
- Change back to `bidirectional`
- Regenerate
- The device will resume receiving updates

## Best Practices

### Use Send-Only When:
- ✅ Data is write-once (receipts, logs, events)
- ✅ You want to share data but not receive it back
- ✅ Reducing sync bandwidth is important
- ✅ Data has a clear origin device

### Use Receive-Only When:
- ✅ Data is centrally managed
- ✅ Local changes should never be synced
- ✅ You need read-only access to shared data
- ✅ Data is reference or configuration data

### Use Bidirectional When:
- ✅ Multiple devices need to read AND write
- ✅ Collaboration is required
- ✅ Conflict resolution is needed
- ✅ Full sync is the default requirement

## Troubleshooting

### Send-Only Not Working?

**Symptom:** Device still receiving remote updates

**Check:**
1. Verify the generated file has `return null;` in `buildObserverQuery()`
2. Ensure you regenerated after changing the annotation
3. Check the header comment shows "Sync Direction: sendOnly"

### Data Not Seeding?

**Symptom:** Initial data not appearing in Ditto

**Check:**
1. Seeding happens once per app session
2. Check debug logs for "Ditto seeded X records"
3. Verify data exists in local SQLite
4. For receive-only, seeding is disabled by design

### Performance Issues?

**Solution:**
- Consider using `sendOnly` for high-volume append-only data
- This reduces processing overhead from incoming sync
- Especially useful for logs, telemetry, and events

## Examples

### Complete Send-Only Example

```dart
import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';

part 'audit_log.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'audit_logs'),
)
@DittoAdapter('audit_logs', syncDirection: SyncDirection.sendOnly)
class AuditLog extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  
  @Sqlite(index: true)
  final int? branchId;
  
  final String action;
  final String userId;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  
  AuditLog({
    String? id,
    required this.branchId,
    required this.action,
    required this.userId,
    required this.timestamp,
    this.metadata,
  }) : id = id ?? const Uuid().v4();
}
```

## Summary

The sync direction feature gives you precise control over data flow:

- **Bidirectional**: The default, works for most cases
- **Send-Only**: Perfect for logs, events, and write-once data
- **Receive-Only**: Ideal for centrally-managed reference data

Choose the right direction for each model to optimize performance and ensure correct data flow patterns in your application.
