# Fix: Generator Class Name Extraction

## Problem

The `ditto_registry_aggregator` generator was inferring class names from file names instead of reading the actual class name from the file content. This caused issues when the class name didn't match the expected pattern.

### Example Issue

**File:** `transaction.model.dart`  
**Expected by old generator:** `TransactionDittoAdapter`  
**Actual class name:** `ITransaction` → Should generate `ITransactionDittoAdapter`

The old logic:
```dart
final className = fileName
    .split('.')
    .first
    .split('_')
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join('');
```

This would convert:
- `transaction.model.dart` → `Transaction` ❌ (Wrong!)
- `item_code.model.dart` → `ItemCode` ✅ (Happens to work)

## Solution

The generator now extracts the actual class name from the file content using a regex pattern:

```dart
// Extract the actual class name from the file
final classNameMatch = RegExp(
  r'@DittoAdapter\([^)]+\)\s*class\s+(\w+)\s+extends',
).firstMatch(content);

if (classNameMatch != null) {
  classNames[input.path] = classNameMatch.group(1)!;
}
```

This pattern:
1. Finds `@DittoAdapter(...)` annotation
2. Matches the `class` keyword
3. Captures the class name (any word characters)
4. Matches `extends` to ensure we're getting the class declaration

## Result

### Before Fix
```dart
transaction_model.TransactionDittoAdapter.registryToken; // ❌ Doesn't exist
```

### After Fix
```dart
transaction_model.ITransactionDittoAdapter.registryToken; // ✅ Correct
```

## Benefits

1. **Works with any class naming convention:**
   - `ITransaction` → `ITransactionDittoAdapter`
   - `Counter` → `CounterDittoAdapter`
   - `ItemCode` → `ItemCodeDittoAdapter`

2. **No more guessing:** Reads the actual class name from source

3. **Handles edge cases:**
   - Classes with prefixes (I, Base, Abstract, etc.)
   - Classes with custom naming not following file name pattern
   - Classes with numbers or special patterns

## Files Modified

- `packages/brick/packages/brick_ditto_generators/lib/ditto_registry_aggregator.dart`
  - Added `classNames` map to store path → class name mapping
  - Added regex to extract actual class name from file content
  - Updated generator to use extracted class name instead of inferred name

## Testing

The fix was verified by regenerating `ditto_models_loader.g.dart` and confirming:
- `ITransactionDittoAdapter` is correctly referenced
- No compilation errors
- All other adapters remain correctly referenced
