# Testing the Stock Recount Feature

## Quick Start Guide

### 1. Clean and Rebuild
```bash
cd /Users/richard/Developer/flipper

# Clean the build
flutter clean

# Get dependencies
flutter pub get

# Regenerate code (important for Ditto adapters and brick models)
dart run build_runner build --delete-conflicting-outputs
```

### 2. Restart IDE
- In VS Code: Open Command Palette (Cmd+Shift+P)
- Type "Dart: Restart Analysis Server"
- Press Enter

### 3. Run the App
```bash
flutter run
```

## How to Test

### Test 1: Navigation
1. Login to the app
2. Look for "Stock Recount" in the side menu (with inventory icon)
3. Click on it
4. Should see the Stock Recount List screen

### Test 2: Create New Recount
1. On the Stock Recount List screen, click "New Recount" (FAB button)
2. Should navigate to the Active Session screen
3. Should see:
   - Device name at the top
   - Status badge showing "DRAFT" in orange
   - Empty state: "No items yet"

### Test 3: Add Products to Recount
1. In the "Add Product" section:
   - Type a product name in the search field
   - Wait for autocomplete dropdown
   - Click on a product from the dropdown
2. Product should be selected (shown in blue info box)
3. Enter a quantity in the "Quantity" field
4. Click "Add" button
5. Product should appear in the items list below
6. Should show:
   - Product name
   - Previous quantity
   - Counted quantity
   - Difference (with color: green/red/grey)

### Test 4: Submit Recount
1. After adding several products
2. Click "Submit" button in the app bar
3. Confirmation dialog should appear
4. Click "Submit"
5. Should see success message
6. Should navigate back to list screen
7. Recount should now show status "SUBMITTED" in blue

### Test 5: View Completed Recount
1. On the list screen, click on a submitted recount
2. Should open in view-only mode
3. Should NOT show:
   - "Add Product" section
   - Delete buttons on items
   - Submit button
4. Should show all items with their counts

### Test 6: Filter and Search
1. On the list screen, use filter chips:
   - Click "Draft" - should show only draft recounts
   - Click "Submitted" - should show only submitted
   - Click "Synced" - should show synced recounts
   - Click "All" - should show everything
2. Use search box:
   - Type device name or notes
   - List should filter in real-time

### Test 7: Delete Draft Recount
1. Find a draft recount in the list
2. Click the delete icon (red trash icon)
3. Confirmation dialog should appear
4. Click "Delete"
5. Recount should disappear from the list

## Expected Behavior

### Status Flow
```
DRAFT → SUBMITTED → SYNCED
```

- **DRAFT** (Orange): Recount in progress, can edit/delete
- **SUBMITTED** (Blue): Recount submitted, stock updated, syncing to server
- **SYNCED** (Green): Recount synced, complete

### Stock Updates
When a recount is submitted:
1. `Stock.currentStock` is updated to the counted quantity
2. `Stock.ebmSynced` is set to `false` (triggers RRA tax reporting)
3. Status changes from DRAFT to SUBMITTED

### Real-time Updates
- Multiple devices can view/edit the same recount
- Changes sync via Ditto P2P
- List screen updates in real-time when recounts change

## Troubleshooting

### Compile Errors About Missing Methods
If you see errors like "The method 'startRecountSession' isn't defined":
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `dart run build_runner build --delete-conflicting-outputs`
4. Restart Dart Analysis Server in VS Code
5. Restart VS Code if needed

### No Branch Selected Error
- Make sure you're logged in
- Make sure a branch is selected
- Check `ProxyService.box.getBranchId()` returns a valid ID

### Products Not Showing in Search
- Make sure you have products in the database
- Check that products have variants
- Verify branchId is correct

### Recount Not Appearing in List
- Check you're viewing the correct status filter
- Try clicking "All" filter
- Check that the recount was created for the current branch

## Database Verification

To verify the data is being saved correctly:

```dart
// In a test or debug scenario:
final branchId = ProxyService.box.getBranchId();

// Check recounts exist
final recounts = await ProxyService.strategy.getRecounts(
  branchId: branchId!,
);
print('Found ${recounts.length} recounts');

// Check items in a recount
if (recounts.isNotEmpty) {
  final items = await ProxyService.strategy.getRecountItems(
    recountId: recounts.first.id,
  );
  print('Recount has ${items.length} items');
}
```

## Key Files to Check

If issues persist, check these files:
- `packages/flipper_models/lib/sync/interfaces/database_sync_interface.dart` - Interface should include StockRecountInterface
- `packages/flipper_models/lib/sync/core/core_sync.dart` - Should have StockRecountMixin
- `packages/supabase_models/lib/brick/models/stock_recount.model.dart` - Model definition
- `packages/flipper_models/lib/sync/mixins/stock_recount_mixin.dart` - Business logic

## Success Criteria

✅ Can navigate to Stock Recount screen
✅ Can create new recount session
✅ Can search and add products
✅ Can see real-time item list with differences
✅ Can submit recount
✅ Can view submitted recounts (read-only)
✅ Can filter by status
✅ Can search recounts
✅ Can delete draft recounts
✅ Status badges show correct colors
✅ Stock levels update after submission
