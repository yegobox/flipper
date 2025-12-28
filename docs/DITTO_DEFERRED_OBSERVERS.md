# Ditto Deferred Observer Registration

## Problem
Previously, Ditto observers were registered automatically during app startup (in `main.dart`). This caused issues because:
1. Observers were registered BEFORE the user selected a branch
2. Queries with `WHERE branchId = :branchId` would fail or hang when `branchId` was NULL
3. `skipInitialFetch:false` caused the app to hang on startup

## Solution: Deferred Observer Registration
Observers are now registered in two phases:

### Phase 1: App Startup (main.dart)
```dart
await DittoSyncRegistry.registerDefaults();
```

This call:
- ✅ Loads Ditto models
- ✅ Registers adapters
- ✅ Initializes Ditto coordinator
- ❌ Does NOT register observers yet

### Phase 2: After Branch Selection (login_choices.dart)

**Option A: Register observers for ALL models**
```dart
// After branchId is set in ProxyService.box
await DittoSyncRegistry.registerObservers();
```

**Option B: Register observers for SPECIFIC models only (recommended)**
```dart
// After branchId is set, register only Counter observer
await DittoSyncRegistry.registerObserversForTypes([Counter]);
```

This call:
- ✅ Registers observers for specified models only
- ✅ Starts listening for Ditto changes on those models
- ✅ Triggers initial data pull from Ditto Cloud (if skipInitialFetch: false)
- ✅ Safe because branchId is now set
- ✅ More efficient - only syncs what you need

## Code Changes

### 1. DittoSyncCoordinator
Added new public methods:
```dart
// Register observers for specific types
Future<void> registerObserversForTypes(List<Type> types, {bool skipInitialFetch = false})

// Register observers for all types
Future<void> registerObserversForAllTypes({bool skipInitialFetch = false})
```

Modified behavior:
- `setDitto()` no longer auto-starts observers
- `registerAdapter()` no longer auto-starts observers
- Observers must be manually started via the above methods

### 2. DittoSyncRegistry
Added new methods:
```dart
// Register ALL observers
Future<void> registerObservers()

// Register observers for SPECIFIC types only
Future<void> registerObserversForTypes(List<Type> types, {bool skipInitialFetch = false})
```

Added state tracking:
- `_observersRegistered` flag prevents duplicate registration
- Auto-calls `registerDefaults()` if not yet initialized

### 3. LoginChoices (_setDefaultBranch)
After setting branchId:
```dart
await ProxyService.box.writeString(key: 'branchId', value: branch.id!);

// ✨ NOW REGISTER OBSERVER FOR COUNTER ONLY
await DittoSyncRegistry.registerObserversForTypes([Counter]);

// Or register all observers:
// await DittoSyncRegistry.registerObservers();
```

## Benefits
1. ✅ No more app hangs on startup
2. ✅ Queries work correctly with branchId filter
3. ✅ Cloud data syncs properly to local device
4. ✅ Observers only active when needed
5. ✅ Better separation of concerns
6. ✅ **Selective sync - register only the models you need**

## Migration Guide
If you have custom code that relies on observers being available at startup:

**Before:**
```dart
// Observers were active immediately after DittoSyncRegistry.registerDefaults()
```

**After (Option A - All models):**
```dart
// Step 1: Initialize Ditto
await DittoSyncRegistry.registerDefaults();

// Step 2: Set branchId
ProxyService.box.writeInt(key: 'branchId', value: branchId);

// Step 3: Register observers for all models
await DittoSyncRegistry.registerObservers();
```

**After (Option B - Specific models, recommended):**
```dart
// Step 1: Initialize Ditto
await DittoSyncRegistry.registerDefaults();

// Step 2: Set branchId
ProxyService.box.writeInt(key: 'branchId', value: branchId);

// Step 3: Register observers for specific models only
await DittoSyncRegistry.registerObserversForTypes([Counter, Product, Stock]);
```

## Testing
To verify observers are working:

**For Counter model only:**
1. Launch app
2. Login and select branch
3. Check logs for: `🔔 Registering Ditto observer for Counter model only...`
4. Check logs for: `✅ Counter observer registered successfully`
5. Create/update a Counter in Ditto Cloud Portal
6. Should see local SQLite updated via observer callback
7. Other models (Product, Stock, etc.) will NOT sync

**For all models:**
1. Launch app
2. Login and select branch
3. Check logs for: `🔔 Registering Ditto observers after branch selection...`
4. Check logs for: `✅ Observers registered successfully`
5. Create/update any model in Ditto Cloud Portal
6. Should see local SQLite updated via observer callback

## Troubleshooting

### Observers not triggering
- Verify `registerObservers()` was called after branch selection
- Check logs for observer registration success
- Verify branchId is set: `ProxyService.box.getBranchId()`

### App still hanging
- Ensure `skipInitialFetch:true` in `setDitto()` call
- Check if observers are being registered too early
- Verify no other code is calling `registerObserversForAllTypes()` before branch selection
