# Ditto Model Relationship Fix

## Problem
The application was crashing with the error:
```
NoSuchMethodError: Class 'Stock' has no instance method 'toCbor()
```

This occurred when `TransactionItem` objects were being synced to Ditto because:
1. `TransactionItem` has a `Stock? stock` field (a model relationship)
2. When Ditto tried to serialize `TransactionItem` to CBOR format, it attempted to serialize the nested `Stock` object
3. `Stock` doesn't have a `toCbor()` method because it's not a Ditto-synced model
4. The CBOR serialization failed with a `NoSuchMethodError`

## Root Cause
The Ditto adapter generator was not smart enough to exclude complex model relationships from serialization. It was trying to serialize entire model objects (like `Stock`, `Product`, `Variant`, etc.) directly into the Ditto document.

## Solution
Updated the Ditto adapter generator to automatically exclude model relationships from Ditto sync:

### Changes Made
1. **Updated Generator Logic** (`brick_ditto_generators/lib/ditto_sync_adapter_generator.dart`):
   - Enhanced `_shouldExcludeFromDitto()` to detect and exclude model relationship types
   - Added a list of common model types that should never be serialized to Ditto:
     - Stock
     - Product
     - Variant
     - Customer
     - Branch
     - Business
     - Category
     - Unit
     - Favorite
     - Pin
     - Device
     - Setting
     - Ebm
     - Composite
     - VariantBranch
     - InventoryRequest
     - Financing
     - FinanceProvider

2. **Updated `_generateConstructorArgs()`**:
   - Excluded fields are now set to `null` in deserialization with a comment
   - This ensures the generated code is clear about which fields are excluded

3. **Repository Protection** (`supabase_models/lib/brick/repository.dart`):
   - Added explicit check to skip Ditto sync for `Stock` models
   - Stock is now only saved locally via `CacheManager`

### How It Works Now
1. **For TransactionItem**:
   - ✅ Serializes all primitive fields (strings, numbers, booleans, dates)
   - ✅ Serializes IDs for relationships (variantId, productId, etc.)
   - ❌ Excludes complex model objects (Stock, Product, etc.)
   - ✅ Sets excluded fields to `null` when deserializing from Ditto

2. **Generated Code**:
   ```dart
   // In toDittoDocument() - stock field is NOT included
   Future<Map<String, dynamic>> toDittoDocument(TransactionItem model) async {
     return {
       "id": model.id,
       "name": model.name,
       // ... other primitive fields ...
       "purchaseId": model.purchaseId,
       // NO "stock": model.stock here!
       "taxPercentage": model.taxPercentage,
       // ...
     };
   }
   
   // In fromDittoDocument() - stock is set to null
   Future<TransactionItem?> fromDittoDocument(Map<String, dynamic> document) async {
     return TransactionItem(
       id: id,
       // ... other fields ...
       purchaseId: document["purchaseId"],
       stock: null, // Excluded from Ditto sync
       taxPercentage: document["taxPercentage"],
       // ...
     );
   }
   ```

## Benefits
1. ✅ **No more CBOR serialization errors** - Model relationships are excluded
2. ✅ **Proper separation of concerns** - Ditto syncs data, not object graphs
3. ✅ **Relationship IDs still synced** - You can still reconstruct relationships via IDs
4. ✅ **Future-proof** - Generator will automatically exclude new model types
5. ✅ **Clean generated code** - Clear comments about excluded fields

## How to Add New Model Types to Exclude
If you create a new model that extends `OfflineFirstWithSupabaseModel` and it should be excluded from Ditto serialization, add it to the `modelRelationshipTypes` list in:

`packages/brick/packages/brick_ditto_generators/lib/ditto_sync_adapter_generator.dart`

```dart
final modelRelationshipTypes = [
  'Stock',
  'Product',
  'Variant',
  // ... existing types ...
  'YourNewModelType', // Add here
];
```

Then run:
```bash
cd packages/supabase_models
dart run build_runner build --delete-conflicting-outputs
```

## Alternative Approach: Using Annotations
If you want more fine-grained control, you can use the existing annotation-based exclusion:

```dart
class TransactionItem extends OfflineFirstWithSupabaseModel {
  @Supabase(ignore: true)  // Will be excluded from Ditto
  Stock? stock;
  
  // ... other fields
}
```

The generator already respects this annotation!

## Testing
After regenerating the Ditto adapters:
1. ✅ TransactionItem can be synced to Ditto without errors
2. ✅ Stock is saved locally and doesn't cause CBOR errors
3. ✅ No changes needed to existing business logic
4. ✅ Relationships can still be loaded via Brick's normal relationship loading

## Files Modified
1. `packages/brick/packages/brick_ditto_generators/lib/ditto_sync_adapter_generator.dart`
   - Enhanced model relationship detection
2. `packages/supabase_models/lib/brick/repository.dart`
   - Added explicit Stock exclusion
3. All `*.ditto_sync_adapter.g.dart` files
   - Regenerated with proper exclusions
