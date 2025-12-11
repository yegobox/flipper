# Variant Model Validation Patterns and Implementation

Based on analysis of the codebase, here are the actual validation patterns used for the Variant model fields:

## Field Length Validations

### modrId and modrNm Pattern
- **modrId**: Uses first 5 characters of UUID in the model constructor: `const Uuid().v4().substring(0, 5)`
- **modrNm**: Uses either:
  - First 5 characters of UUID in model constructor: `const Uuid().v4().substring(0, 5)`  
  - First 8 characters of random string in tax operations: `randomString().substring(0, 8)`

### regrId Pattern
- **regrId**: Uses first 15 characters of random number: `randomNumber().toString().substring(0, 15)`

## Code Examples from Implementation

### In variant.model.dart constructor:
```dart
Variant({
  // ... other parameters
  String? modrId,
  // ... other parameters
}) : id = id ?? const Uuid().v4(),
     // ... other assignments
     modrId = modrId ?? const Uuid().v4().substring(0, 5);
```

### In rw_tax.dart mapping function:
```dart
modrId: item.modrId ?? randomString().substring(0, 8),
modrNm: item.modrNm ?? randomString().substring(0, 8),
regrId: item.regrId?.toString() ?? randomNumber().toString().substring(0, 15),
```

### In other files:
```dart
// In purchase_mixin.dart and coreViewModel.dart:
variant.modrId = randomNumber().toString().substring(0, 5);

// In transaction contexts:
"modrId": transaction.id.substring(0, 5),
"modrNm": transaction.id.substring(0, 5),
```

## Validation Implementation Recommendations

### For modrId:
- Length: Exactly 5 characters when auto-generated via UUID
- Pattern: `uuid.substring(0, 5)` - alphanumeric characters from UUID
- Validation: If manually provided, should be 5 characters long

### For modrNm:
- Length: Either 5 or 8 characters depending on context
- Pattern: `uuid.substring(0, 5)` for internal operations or `randomString().substring(0, 8)` for tax operations
- Validation: If manually provided, should be 5 or 8 characters long

### For regrId:
- Length: Up to 15 characters when auto-generated
- Pattern: `randomNumber().toString().substring(0, 15)`
- Validation: If manually provided, should be up to 15 characters long

## Actual Usage Contexts

1. **Model Construction**: Uses 5-character UUID substrings
2. **Tax Operations**: Uses 8-character random strings 
3. **Transaction Contexts**: Uses 5-character substrings from transaction IDs
4. **Purchase Operations**: Uses 5-character substrings from random numbers

## Validation Summary

| Field | Auto-generated | Length | Source |
|-------|----------------|---------|---------|
| modrId | Yes | 5 chars | UUID.substring(0, 5) |
| modrNm | Yes | 5 or 8 chars | UUID.substring(0, 5) or randomString().substring(0, 8) |
| regrId | Yes | Up to 15 chars | randomNumber().toString().substring(0, 15) |

These patterns ensure consistency with the existing codebase while providing proper validation constraints.