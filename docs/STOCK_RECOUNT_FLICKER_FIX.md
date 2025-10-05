# Stock Recount Flicker Fix

## Problem

When visiting an existing stock recount, the screen was flickering. This was caused by a rebuild loop.

## Root Cause

The issue was in the `build` method of `_StockRecountActiveScreenState`:

```dart
// BEFORE (PROBLEMATIC CODE)
final isDraft = recount.status == 'draft';

// Check submit status on init
if (isDraft) {
  Future.microtask(() => _checkCanSubmit());
}

return Scaffold(...);
```

### Why This Caused Flickering:

1. **FutureBuilder rebuilds** when the future completes
2. **On each rebuild**, `Future.microtask(() => _checkCanSubmit())` was called
3. **`_checkCanSubmit()` calls `setState()`**, triggering another rebuild
4. **Infinite rebuild loop** → flickering screen

## Solution

Move the validation check to `initState()` instead of calling it in the `build` method:

```dart
// AFTER (FIXED CODE)
@override
void initState() {
  super.initState();
  // Check if we can submit on initial load
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkCanSubmit();
  });
}
```

### Why This Works:

1. **`initState()` runs only once** when the widget is first created
2. **`addPostFrameCallback()`** ensures the check happens after the first frame is built
3. **No rebuild loop** - the check only runs once on screen load
4. **The check still runs after add/remove operations** via explicit calls in those methods

## Changes Made

### File: `stock_recount_active_screen.dart`

#### 1. Added `initState()` method:
```dart
@override
void initState() {
  super.initState();
  // Check if we can submit on initial load
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkCanSubmit();
  });
}
```

#### 2. Removed problematic code from `build` method:
```dart
// REMOVED:
if (isDraft) {
  Future.microtask(() => _checkCanSubmit());
}
```

## Testing

### Before Fix:
- ❌ Screen flickers when opening existing recount
- ❌ Multiple unnecessary API calls
- ❌ Poor user experience

### After Fix:
- ✅ Screen loads smoothly without flickering
- ✅ Validation check runs once on load
- ✅ Validation still runs after add/remove operations
- ✅ Better performance

## Best Practices Applied

1. **Never call `setState()` from `build()` method** (directly or indirectly via callbacks)
2. **Use `initState()` for one-time initialization**
3. **Use `addPostFrameCallback()` when you need context or widget to be fully built**
4. **Avoid `Future.microtask()` in build methods** - it doesn't prevent the rebuild issue

## Related Code Flow

```
Screen Load
    ↓
initState() called
    ↓
addPostFrameCallback() scheduled
    ↓
First frame built
    ↓
_checkCanSubmit() runs
    ↓
Items fetched and validated
    ↓
setState() updates _canSubmit flag
    ↓
UI updates (Submit button enabled/disabled)
    ↓
(User adds/removes items)
    ↓
_checkCanSubmit() called explicitly
    ↓
Validation re-runs
```

## Status

✅ **Fixed** - No more flickering when opening existing stock recounts

## Date

October 5, 2025
