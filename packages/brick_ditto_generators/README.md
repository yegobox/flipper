# Brick Ditto Generators

Code generators for Ditto synchronization adapters in the Flipper project.

## Overview

This package provides build-time code generation for creating Ditto sync adapters from annotated model classes. The generators create adapter classes that handle bidirectional synchronization between local SQLite storage and Ditto's peer-to-peer sync system.

## Usage

### 1. Annotate Your Model

Add the `@DittoAdapter` annotation to your model class:

```dart
// Bidirectional sync (default)
@DittoAdapter('counters')
class Counter extends OfflineFirstWithSupabaseModel {
  // ... your model fields
}

// Send-only (pushes initial data, but doesn't receive remote updates)
@DittoAdapter('logs', syncDirection: SyncDirection.sendOnly)
class AuditLog extends OfflineFirstWithSupabaseModel {
  // ... your model fields
}

// Receive-only (receives remote data, but doesn't push local changes)
@DittoAdapter('settings', syncDirection: SyncDirection.receiveOnly)
class GlobalSettings extends OfflineFirstWithSupabaseModel {
  // ... your model fields
}
```

#### Sync Direction Options

- **`SyncDirection.bidirectional`** (default): Full two-way sync. The model both sends local changes to Ditto and receives remote updates.

- **`SyncDirection.sendOnly`**: The model pushes initial data and local changes to Ditto, but does NOT fetch remote updates back to the local database. Use this for write-only data like audit logs, telemetry, or events that you want to share but don't need to receive.

- **`SyncDirection.receiveOnly`**: The model receives data from Ditto but does NOT push local changes. Use this for read-only reference data like global settings or product catalogs that are managed centrally.

### 2. Required Imports

**IMPORTANT**: The generated adapter file is created as a `part of` file, so the parent model file MUST include these imports:

```dart
import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
```

### 3. Add Part Directive

Include the part directive in your model file:

```dart
part 'your_model.model.ditto_sync_adapter.g.dart';
```

### 4. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Complete Example

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

part 'counter.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'counters'),
)
@DittoAdapter('counters')
class Counter extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;
  
  int? businessId;
  int? branchId;
  String? receiptType;
  
  Counter({
    String? id,
    required this.branchId,
    required this.businessId,
    required this.receiptType,
  }) : id = id ?? const Uuid().v4();
}
```

## Generated Features

The generator creates an adapter class with the following features:

- **Branch Filtering**: Automatically filters sync based on `branchId` if present
- **Serialization**: Converts models to/from Ditto documents
- **Query Building**: Generates observer queries for Ditto sync
- **Seeding**: Initial data seeding from SQLite to Ditto
- **Test Overrides**: Allows overriding branch/business ID providers for testing

## Troubleshooting

### Missing Imports Error

If you see errors about undefined classes (like `Query`, `ProxyService`, `Repository`, etc.), ensure all required imports are present in your model file. The generator creates a `part of` file, so it relies on the parent file's imports.

### Check Generated File Header

The generated file includes a comment block listing all required imports. Compare this with your model file to ensure nothing is missing.

### Re-run Generation

After adding missing imports, re-run the code generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

- **DittoSyncAdapterGenerator**: Main generator class that creates adapter code
- **DittoAdapter**: Annotation to mark models for generation
- **Generated Adapters**: Extend `DittoSyncAdapter<T>` and implement all sync logic

## Dependencies

The generated code relies on:
- brick_core: Query/Where classes
- brick_offline_first: Offline-first policies
- flipper_services: ProxyService for branch/business context
- supabase_models: Repository and sync coordinators
