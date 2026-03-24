# Understanding `syncDirection` - Visual Guide

## 🎯 The Big Picture

`syncDirection` controls **how data flows** between your local SQLite database and Ditto's peer-to-peer network.

```
┌─────────────────────────────────────────────────────────────┐
│                    Your Device (SQLite)                     │
└─────────────────────────────────────────────────────────────┘
                              ↕
                    [syncDirection controls this]
                              ↕
┌─────────────────────────────────────────────────────────────┐
│           Ditto P2P Network (Distributed Storage)           │
└─────────────────────────────────────────────────────────────┘
                              ↕
                    [Other devices sync here]
                              ↕
┌─────────────────────────────────────────────────────────────┐
│              Other Devices (SQLite + Ditto)                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 The Three Sync Directions

### 1. `SyncDirection.sendOnly` (Default)

**Full two-way sync - Send AND Receive**

```
Your Device                 Ditto Network              Other Devices
   ┌────┐                                                ┌────┐
   │ DB │ ──────────────────────────────────────────────→│ DB │
   │    │        Local changes pushed to Ditto          │    │
   │    │                                                │    │
   │    │ ←──────────────────────────────────────────── │    │
   └────┘        Remote changes pulled back             └────┘
                                                        
✅ Seeds initial data to Ditto
✅ Pushes local changes to Ditto
✅ Observes and pulls remote changes
✅ Applies remote updates to local DB
```

**Example:** Counter with bidirectional sync
```dart
@DittoAdapter('counters')  // Default is bidirectional
class Counter extends OfflineFirstWithSupabaseModel {
  // ... fields
}
```

**Generated Code:**
```dart
@override
Future<DittoSyncQuery?> buildObserverQuery() async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    return const DittoSyncQuery(query: "SELECT * FROM counters");
  }
  return DittoSyncQuery(
    query: "SELECT * FROM counters WHERE branchId = :branchId",
    arguments: {"branchId": branchId},
  );
}
```
☝️ **This query tells Ditto WHAT to observe/listen for**

---

### 2. `SyncDirection.sendOnly`

**Write-only sync - Send but DON'T Receive**

```
Your Device                 Ditto Network              Other Devices
   ┌────┐                                                ┌────┐
   │ DB │ ──────────────────────────────────────────────→│ DB │
   │    │        Local changes pushed to Ditto          │    │
   │    │                                                │    │
   │    │ ✗ NO LISTENING FOR REMOTE CHANGES             │    │
   └────┘                                                └────┘
                                                        
✅ Seeds initial data to Ditto
✅ Pushes local changes to Ditto
❌ Does NOT observe remote changes
❌ Does NOT pull or apply remote updates
```

**Example:** Counter with send-only sync
```dart
@DittoAdapter('counters', syncDirection: SyncDirection.sendOnly)
class Counter extends OfflineFirstWithSupabaseModel {
  // ... fields
}
```

**Generated Code:**
```dart
@override
Future<DittoSyncQuery?> buildObserverQuery() async {
  // Send-only mode: no remote observation
  return null;  // ← THIS IS THE KEY DIFFERENCE!
}
```
☝️ **Returning `null` disables observation = no remote updates pulled**

---

### 3. `SyncDirection.receiveOnly`

**Read-only sync - Receive but DON'T Send**

```
Your Device                 Ditto Network              Other Devices
   ┌────┐                                                ┌────┐
   │ DB │ ✗ NO PUSHING LOCAL CHANGES                    │ DB │
   │    │                                                │    │
   │    │                                                │    │
   │    │ ←──────────────────────────────────────────── │    │
   └────┘        Only pulls remote changes              └────┘
                                                        
❌ Does NOT seed initial data
❌ Does NOT push local changes
✅ Observes remote changes
✅ Pulls and applies remote updates
```

**Example:** Global settings with receive-only sync
```dart
@DittoAdapter('settings', syncDirection: SyncDirection.receiveOnly)
class GlobalSettings extends OfflineFirstWithSupabaseModel {
  // ... fields
}
```

**Generated Code:**
```dart
@override
Future<DittoSyncQuery?> buildObserverQuery() async {
  // Observe remote changes (same as bidirectional)
  return const DittoSyncQuery(query: "SELECT * FROM settings");
}
```
☝️ **Query is active, but seeding is disabled**

---

## 🔄 Runtime Flow: How It Actually Works

### When App Starts

```
1. App Launches
   │
   ├─→ DittoSyncRegistry.registerDefaults() called
   │   │
   │   ├─→ ensureDittoAdaptersLoaded() runs
   │   │   └─→ All adapter static initializers execute
   │   │       └─→ Each adapter registers with DittoSyncGeneratedRegistry
   │   │
   │   └─→ DittoService provides Ditto instance
   │       │
   │       ├─→ Repository is ready
   │       │
   │       └─→ DittoSyncCoordinator.setDitto(ditto) called
   │           │
   │           └─→ For EACH registered adapter:
   │               │
   │               ├─→ SEEDING (if not sendOnly or receiveOnly)
   │               │   └─→ Reads local DB data
   │               │   └─→ Pushes to Ditto via notifyLocalUpsert()
   │               │
   │               └─→ OBSERVATION SETUP
   │                   │
   │                   ├─→ Calls adapter.buildObserverQuery()
   │                   │
   │                   ├─→ If returns NULL (sendOnly):
   │                   │   └─→ ❌ No observer created
   │                   │   └─→ ❌ Remote changes ignored
   │                   │
   │                   └─→ If returns DittoSyncQuery:
   │                       └─→ ✅ Creates Ditto live query
   │                       └─→ ✅ Listens for remote changes
   │                       └─→ ✅ Calls fromDittoDocument() for each change
   │                       └─→ ✅ Upserts to local Repository
```

---

## 🔑 The Key Methods

### `buildObserverQuery()` - The Control Point

This method is **THE HEART** of sync direction:

```dart
// BIDIRECTIONAL or RECEIVE_ONLY
Future<DittoSyncQuery?> buildObserverQuery() async {
  return DittoSyncQuery(
    query: "SELECT * FROM counters WHERE branchId = :branchId",
    arguments: {"branchId": branchId},
  );
}
// ☝️ Returns a query → Ditto OBSERVES this collection
```

```dart
// SEND_ONLY
Future<DittoSyncQuery?> buildObserverQuery() async {
  return null;  // ← NO QUERY = NO OBSERVATION
}
// ☝️ Returns null → Ditto IGNORES this collection
```

### `toDittoDocument()` - Converts Local → Ditto

**Used by ALL sync directions for sending data**

```dart
Future<Map<String, dynamic>> toDittoDocument(Counter model) async {
  return {
    "id": model.id,
    "businessId": model.businessId,
    "branchId": model.branchId,
    "curRcptNo": model.curRcptNo,
    // ... all fields
  };
}
```

### `fromDittoDocument()` - Converts Ditto → Local

**Only called when `buildObserverQuery()` returns a query**

```dart
Future<Counter?> fromDittoDocument(Map<String, dynamic> document) async {
  final id = document["_id"] ?? document["id"];
  if (id == null) return null;
  
  return Counter(
    id: id,
    businessId: document["businessId"],
    branchId: document["branchId"],
    curRcptNo: document["curRcptNo"],
    // ... all fields
  );
}
```

---

## 📊 Comparison Table

| Feature | `bidirectional` | `sendOnly` | `receiveOnly` |
|---------|----------------|------------|---------------|
| **Seeds initial data** | ✅ Yes | ✅ Yes | ❌ No |
| **Pushes local changes** | ✅ Yes | ✅ Yes | ❌ No |
| **Observes remote changes** | ✅ Yes | ❌ No | ✅ Yes |
| **Pulls remote updates** | ✅ Yes | ❌ No | ✅ Yes |
| **`buildObserverQuery()` returns** | `DittoSyncQuery` | `null` | `DittoSyncQuery` |
| **Calls `fromDittoDocument()`** | ✅ Yes | ❌ No | ✅ Yes |
| **Best for** | Collaborative data | Logs, receipts | Settings, catalogs |

---

## 🎬 Real-World Scenarios

### Scenario 1: Receipt Counter (Send-Only)

```dart
@DittoAdapter('counters', syncDirection: SyncDirection.sendOnly)
class Counter extends OfflineFirstWithSupabaseModel {
  int? curRcptNo;
  int? totRcptNo;
}
```

**What happens:**
1. Device A creates receipt #1 → Counter increments → Pushed to Ditto ✅
2. Device B creates receipt #2 → Counter increments → Pushed to Ditto ✅
3. Device A does NOT pull Device B's counter (sendOnly) ❌
4. Each device maintains its own counter independently ✅

**Why use this?**
- Each device needs its own independent counter
- You want to track ALL counters in Ditto for reporting
- But you DON'T want devices to sync each other's counters

---

### Scenario 2: Product Codes (Bidirectional)

```dart
@DittoAdapter('codes')  // bidirectional by default
class ItemCode extends OfflineFirstWithSupabaseModel {
  String code;
}
```

**What happens:**
1. Device A scans code "ABC123" → Saved locally → Pushed to Ditto ✅
2. Device B receives update from Ditto → Code "ABC123" added locally ✅
3. Device B scans code "XYZ789" → Saved locally → Pushed to Ditto ✅
4. Device A receives update from Ditto → Code "XYZ789" added locally ✅

**Why use this?**
- All devices should have all codes
- Collaboration between devices is essential
- Data synchronization keeps everyone in sync

---

### Scenario 3: Product Catalog (Receive-Only)

```dart
@DittoAdapter('products', syncDirection: SyncDirection.receiveOnly)
class Product extends OfflineFirstWithSupabaseModel {
  String name;
  double price;
}
```

**What happens:**
1. Central server publishes product updates to Ditto ✅
2. All devices observe and pull product updates ✅
3. Local changes on devices are NOT pushed to Ditto ❌
4. Ensures data integrity - only central system can update

**Why use this?**
- Product catalog is centrally managed
- Local devices shouldn't publish product changes
- Read-only reference data for point-of-sale devices

---

## 🚀 Performance Impact

### Send-Only Benefits
- **Less CPU**: No observation processing
- **Less Memory**: No Ditto live query listeners
- **Less Network**: Only outgoing data
- **Faster App**: No incoming sync processing

### Receive-Only Benefits
- **No Conflicts**: Local changes don't matter
- **Data Integrity**: Only central source can write
- **Simpler Logic**: One-way data flow

### Bidirectional Trade-offs
- **More Resources**: Full observation and sync
- **Conflict Resolution**: Needs merge strategies
- **Most Flexible**: True collaboration

---

## 💡 Quick Reference

**Use `sendOnly` when:**
- Data is write-once (logs, receipts)
- Each device is independent
- You want to collect data from all devices
- Don't need to receive others' data

**Use `receiveOnly` when:**
- Data is centrally managed
- Local changes shouldn't propagate
- Read-only reference data
- Settings from central server

**Use `bidirectional` when:**
- True collaboration needed
- All devices should see all data
- Data can be created/modified anywhere
- Full synchronization required

---

## 🔍 How to Verify Sync Direction

1. **Check the model file:**
```dart
@DittoAdapter('counters', syncDirection: SyncDirection.sendOnly)
```

2. **Check the generated file header:**
```dart
// Sync Direction: sendOnly
// This adapter sends data to Ditto but does NOT receive remote updates.
```

3. **Check `buildObserverQuery()` in generated file:**
```dart
// sendOnly:
return null;

// bidirectional or receiveOnly:
return DittoSyncQuery(query: "SELECT * FROM ...");
```

---

## 🎓 Summary

**`syncDirection` is all about controlling the flow of data:**

- Set it in `@DittoAdapter(collectionName, syncDirection: ...)`
- Generator reads it and creates different code
- `buildObserverQuery()` returning `null` = No remote observation
- `buildObserverQuery()` returning a query = Active observation
- This simple mechanism gives you powerful control over sync behavior!
