import 'package:flipper_dashboard/features/import_purchase/assign_variant_modal.dart';
import 'package:flipper_dashboard/features/import_purchase/ipm_purchase_line_defaults.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;

/// Accept / decline rules for supplier purchases, shared by the desktop
/// [ImportPurchasePage] and the mobile purchases screen.
///
/// RRA invoices list the supplier's items, so each line must be matched to a
/// catalog item (or created as one) before the purchase can be accepted.
/// Manually recorded purchases (`regTyCd == 'M'`) were entered against the
/// catalog already and need no matching.
mixin PurchaseApprovalMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// Catalog variant id → supplier lines matched to it.
  final Map<String, List<model.Variant>> itemMapper = {};

  /// Shows feedback to the user (toast / snackbar).
  void notifyPurchase(String message, {bool success = true});

  /// Messages are raised across async gaps, so they don't read [context].
  FlipperAppLocalizations get _l10n => FlipperL10n.current;

  /// Lines of [purchase] that still need matching before it can be accepted.
  int unmappedLineCount(model.Purchase purchase) {
    if (purchase.regTyCd == 'M') return 0;
    return (purchase.variants ?? const <model.Variant>[])
        .where((line) => !isPurchaseLineMapped(line))
        .length;
  }

  /// Whether [line] has been matched to (or created as) a catalog item.
  bool isPurchaseLineMapped(model.Variant line) {
    return itemMapper.values.any((list) => list.any((v) => v.id == line.id));
  }

  /// Matches a supplier line to an existing catalog item, or creates one.
  Future<IpmPurchaseMappingSaveResult> savePurchaseMapping(
    model.Variant line,
    IpmPurchaseMappingResult result,
  ) async {
    final name = result.name.trim();
    if (name.isEmpty) {
      notifyPurchase(_l10n.importPurchaseNameRequired, success: false);
      return const IpmPurchaseMappingSaveResult(success: false);
    }
    if (result.supplyPrice <= 0 || result.retailPrice <= 0) {
      notifyPurchase(_l10n.importPurchaseSetBothPrices, success: false);
      return const IpmPurchaseMappingSaveResult(success: false);
    }
    if (result.mode == IpmPurchaseMappingMode.mapExisting &&
        result.catalogVariant == null) {
      notifyPurchase(_l10n.importPurchaseSelectExistingVariant, success: false);
      return const IpmPurchaseMappingSaveResult(success: false);
    }

    line.name = name;
    line.itemNm = name;
    line.supplyPrice = result.supplyPrice;
    line.retailPrice = result.retailPrice;
    line.prc = result.retailPrice;
    line.dftPrc = result.retailPrice;

    for (final list in itemMapper.values) {
      list.removeWhere((v) => v.id == line.id);
    }
    itemMapper.removeWhere((_, list) => list.isEmpty);

    if (result.mode == IpmPurchaseMappingMode.mapExisting) {
      setState(() {
        itemMapper.putIfAbsent(result.catalogVariant!.id, () => []).add(line);
      });
      notifyPurchase(_l10n.importPurchaseMappedToExisting);
      return const IpmPurchaseMappingSaveResult(success: true);
    }

    try {
      final catalogVariant = await createIpmCatalogVariant(
        name: name,
        supplyPrice: result.supplyPrice,
        retailPrice: result.retailPrice,
      );
      if (!mounted) {
        return const IpmPurchaseMappingSaveResult(success: false);
      }
      final branchId = ProxyService.box.getBranchId() ?? '';
      ref.read(outerVariantsProvider(branchId).notifier).addVariants([
        catalogVariant,
      ]);
      for (final catalog in posStockFilteredCatalogs(branchId)) {
        if (ref.exists(catalog)) {
          ref.read(catalog.notifier).addVariants([catalogVariant]);
        }
      }
      setState(() {
        itemMapper.putIfAbsent(catalogVariant.id, () => []).add(line);
      });
      final itemCd = catalogVariant.itemCd;
      notifyPurchase(
        itemCd != null && itemCd.isNotEmpty
            ? _l10n.importPurchaseCreatedVariantWithCode(itemCd)
            : _l10n.importPurchaseCreatedVariant,
      );
      return IpmPurchaseMappingSaveResult(
        success: true,
        createdItemCd: itemCd,
        closeModal: false,
      );
    } catch (e) {
      notifyPurchase(
        _l10n.importPurchaseCouldNotCreateVariant('$e'),
        success: false,
      );
      return const IpmPurchaseMappingSaveResult(success: false);
    }
  }

  /// Accepts or declines [purchase]; returns true when it went through.
  Future<bool> decidePurchase(
    model.Purchase purchase, {
    required bool accept,
  }) async {
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    if (accept) {
      final unmapped = unmappedLineCount(purchase);
      if (unmapped > 0) {
        notifyPurchase(
          _l10n.importPurchaseLinesNeedMapping(unmapped),
          success: false,
        );
        return false;
      }
    }
    try {
      if (accept) {
        await notifier.approvePurchase(
          purchase: purchase,
          itemMapper: itemMapper,
        );
      } else {
        await notifier.rejectPurchase(purchase: purchase);
      }
      itemMapper.clear();
      notifyPurchase(
        accept
            ? _l10n.importPurchasePurchaseAccepted
            : _l10n.importPurchasePurchaseDeclined,
      );
      return true;
    } catch (e) {
      notifyPurchase(
        accept
            ? _l10n.importPurchaseCouldNotAccept('$e')
            : _l10n.importPurchaseCouldNotDecline('$e'),
        success: false,
      );
      return false;
    }
  }
}
