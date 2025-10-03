# VAT Migration Guide: From Local Storage to EBM Database

## Overview
This guide documents the migration from using `ProxyService.box.vatEnabled()` (local storage) to using the EBM (Electronic Billing Machine) database as the single source of truth for VAT configuration.

## Changes Made

### 1. Created Centralized EBM Provider
**File:** `/packages/flipper_models/lib/providers/ebm_provider.dart`

Added a helper function for non-widget contexts:
```dart
Future<bool> getVatEnabledFromEbm() async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;
    
    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    return ebm?.vatEnabled ?? false;
  } catch (e) {
    return false;
  }
}
```

### 2. Updated outer_variant_provider.dart ✅
**File:** `/packages/flipper_models/lib/providers/outer_variant_provider.dart`

Changes:
- Added `_isVatEnabled` field to cache VAT status
- Fetch VAT status from EBM in `build()` method using `getVatEnabledFromEbm()`
- Updated `resetForVatChange()` to be async and refresh VAT cache
- Replaced `ProxyService.box.vatEnabled()` with cached `_isVatEnabled` in:
  - `_filterInMemory()`
  - `_fetchVariants()`

### 3. Updated tax_config_form.dart ✅
**File:** `/packages/flipper_dashboard/lib/features/config/widgets/tax_config_form.dart`

Changes:
- VAT toggle now read-only and controlled by EBM
- Uses `ebmVatEnabledProvider` to watch VAT status
- Removed ability to manually toggle VAT
- Added `ref.invalidate(ebmVatEnabledProvider)` after saving

## Files Still Needing Updates

### High Priority (Widget/Provider Contexts)
These files can use `ref.watch(ebmVatEnabledProvider)`:

1. **TableVariants.dart** ✅ (Already using `ebmVatEnabledProvider`)
2. **DesktopProductAdd.dart** - Line 430, 619 (One already uses provider)
   - Line 430: Replace `ProxyService.box.vatEnabled()` with `ref.watch(ebmVatEnabledProvider).value ?? false`

### Medium Priority (Async Contexts)
These files should use `await getVatEnabledFromEbm()`:

3. **variants_provider.dart** - Lines 18, 38
   ```dart
   // Current:
   taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D']
   
   // Replace with:
   final vatEnabled = await getVatEnabledFromEbm();
   taxTyCds: vatEnabled ? ['A', 'B', 'C'] : ['D']
   ```

4. **metric_provider.dart** - Line 14
5. **product_viewmodel.dart** - Lines 250, 312, 366
6. **coreViewModel.dart** - Lines 464, 471
7. **riverpod_states.dart** - Lines 161, 274, 652
8. **purchase_mixin.dart** - Lines 125, 158
9. **cron_service.dart** - Lines 205, 332
10. **inventory_service.dart** - Lines 157, 244
11. **admin_settings_service.dart** - Line 16
12. **AdminControl.dart** - Line 285
13. **add_product_view.dart** - Line 116
14. **HandleScannWhileSelling.dart** - Line 58
15. **SearchProduct.dart** - Line 52
16. **TransactionItemTable.dart** - Line 847
17. **bootstrapTestData.dart** - Line 64

### Low Priority (Receipt/Printing)
These files are in receipt printing context and may need special handling:

18. **omni_printer.dart** - Lines 574, 702, 734, 891
19. **a4_items_table.dart** - Lines 62, 76
20. **receipt_summary_widget.dart** - Lines 279, 335

For receipt printing, consider:
- Passing VAT status as a parameter from the calling code
- Fetching it once at the start of the print job
- Caching it in the Print class instance

## Migration Strategy

### For Riverpod Providers:
```dart
// Add import
import 'package:flipper_models/providers/ebm_provider.dart';

// In build() method:
final vatEnabled = await getVatEnabledFromEbm();

// Or watch in widget context:
final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
vatEnabledAsync.when(
  data: (vatEnabled) {
    // Use vatEnabled here
  },
  loading: () => // Handle loading,
  error: (e, s) => // Handle error,
);
```

### For ViewModels and Services:
```dart
// Add import
import 'package:flipper_models/providers/ebm_provider.dart';

// Replace synchronous call
final vatEnabled = ProxyService.box.vatEnabled();

// With async call
final vatEnabled = await getVatEnabledFromEbm();
```

### For Consumer Widgets:
```dart
Consumer(
  builder: (context, ref, child) {
    final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
    return vatEnabledAsync.when(
      data: (vatEnabled) {
        // Your widget code using vatEnabled
      },
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error loading VAT status'),
    );
  },
)
```

## Testing Checklist

After migration, verify:
- [ ] VAT toggle in tax config is read-only
- [ ] VAT status reflects EBM configuration per branch
- [ ] Product filtering works correctly (A,B,C vs D tax codes)
- [ ] Receipt printing shows correct VAT calculations
- [ ] Search and variant filtering respects VAT settings
- [ ] Switching branches updates VAT status correctly
- [ ] Changes to EBM configuration propagate to UI

## Rollback Plan

If issues arise:
1. The `ProxyService.box.vatEnabled()` method still exists
2. Local storage is still being written to for backward compatibility
3. Can temporarily revert to local storage while debugging
4. EBM database `vat_enabled` column remains as source of truth

## Benefits

1. **Single Source of Truth**: EBM database is authoritative
2. **Per-Branch Configuration**: Each branch can have different VAT settings
3. **Audit Trail**: Changes tracked in database
4. **Consistency**: No drift between local storage and database
5. **Multi-Device**: Settings sync across devices

## Notes

- Local storage (`vatEnabled` key) is still written to for backward compatibility
- The `ebmVatEnabledProvider` handles errors gracefully (defaults to false)
- All async methods have fallback to false on error
- Widget contexts should prefer using the provider for reactivity
