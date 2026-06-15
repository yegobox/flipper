import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/utils/bulk_desktop_variant_prep.dart';
import 'package:supabase_models/brick/models/all_models.dart' as newMod;
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/material.dart';

mixin ProductMixin {
  final ProductService productService = loc.getIt<ProductService>();
  String currentColor = '#0984e3';
  double _discountRate = 0;
  double get discountRate => _discountRate;

  String? _expirationDate = null;

  String? get expirationDate => _expirationDate;

  set expirationDate(String? expirationDate) {
    _expirationDate = expirationDate;
  }

  set discountRate(double discountRate) {
    _discountRate = discountRate;
  }

  Future<void> addVariant(
      {List<Variant>? variations,
      required String packagingUnit,
      Map<String, TextEditingController>? rates,
      Map<String, TextEditingController>? dates,
      double? retailPrice,
      double? supplyPrice,
      bool preserveVariationFields = false,
      required String countryofOrigin,
      required String productName,
      required String selectedProductType,
      String? color,
      Product? product,
      String? propertyTyCd,
      String? roomTypeCd,
      String? ttCatCd,
      required Function(List<Variant> variantions) onCompleteCallback,
      required ScannViewModel model,
      String? categoryId}) async {
    if (product == null) return;

    ///loop variations add pkgUnitCd this come from UI but a lot of
    ///EBM fields will be hard coded to simplify the UI, so we will loop the variation
    ///and add some missing fields to simplify the UI
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      // find the related product to update its name

      ProxyService.strategy.updateProduct(
        categoryId: categoryId,
        productId: product.id,
        name: productName,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
      );
      // get the category
      Category? category;
      if (categoryId == null || categoryId.isEmpty) {
        category = await ProxyService.strategy.ensureUncategorizedCategory(
          branchId: ProxyService.box.getBranchId()!,
        );
        categoryId = category.id;
      } else {
        category = await ProxyService.strategy.category(id: categoryId);
      }
      List<Variant> updatables = [];
      for (var i = 0; i < variations!.length; i++) {
        final existing = variations[i];
        final pkgCode = resolveRraPackagingUnitCode(
          packagingUnit,
          fallback: existing.pkgUnitCd ?? 'CT',
        );

        final discountController =
            rates != null ? rates[existing.id] : null;
        final discountText = (discountController ??
                model.getDiscountController(existing.id))
            .text;
        final dcRt = double.tryParse(discountText) ?? 0;

        final effectiveRetailPrice = preserveVariationFields
            ? (existing.retailPrice ?? retailPrice)
            : retailPrice;
        final effectiveSupplyPrice = preserveVariationFields
            ? (existing.supplyPrice ?? supplyPrice)
            : supplyPrice;

        if (existing.taxTyCd == null || existing.taxTyCd!.isEmpty) {
          throw Exception(
              'Fatal Error: Tax type (taxTyCd) must be set for variant ${existing.id}. This is a required field.');
        }

        final vn = existing.name.trim();
        final isUnsetOrPlaceholder =
            vn.isEmpty || vn == TEMP_PRODUCT || vn == CUSTOM_PRODUCT;
        var displayName = existing.name.trim();
        if (!preserveVariationFields || isUnsetOrPlaceholder) {
          displayName = productName;
        }
        var displayItemNm = existing.itemNm?.trim() ?? '';
        if (displayItemNm.isEmpty ||
            displayItemNm.toLowerCase() == 'null' ||
            (!preserveVariationFields || isUnsetOrPlaceholder)) {
          displayItemNm = displayName.isNotEmpty ? displayName : productName;
        }

        final prepared = await prepareBulkVariantLikeDesktopAdd(
          product: product,
          productName: productName,
          branchId: ProxyService.box.getBranchId()!,
          taxTyCd: existing.taxTyCd!,
          itemClsCd: existing.itemClsCd ?? '5020230602',
          itemTyCd: selectedProductType,
          retailPrice: effectiveRetailPrice ?? 0,
          supplyPrice: effectiveSupplyPrice ?? 0,
          barCode: existing.bcd ?? existing.barCode ?? existing.sku,
          sku: int.tryParse(existing.sku?.toString() ?? '') ?? randomNumber(),
          countryCode:
              countryofOrigin.trim().isNotEmpty ? countryofOrigin.trim() : 'RW',
          packagingUnitCode: pkgCode,
          categoryId: categoryId,
          categoryName: category?.name,
          business: business,
          preserveVariantId: existing.id.isNotEmpty ? existing.id : null,
        );

        prepared
          ..color = color ?? existing.color
          ..name = displayName
          ..itemNm = displayItemNm
          ..itemStdNm = productName
          ..regrNm = productName
          ..spplrItemNm = productName
          ..modrNm = displayName
          ..dcRt = dcRt
          ..itemSeq = i + 1
          ..ttCatCd = ttCatCd
          ..propertyTyCd = propertyTyCd
          ..roomTypeCd = roomTypeCd
          ..stock = existing.stock
          ..stockId = existing.stockId
          ..sku = existing.sku ?? prepared.sku
          ..imageUrl = existing.imageUrl
          ..barCode = existing.barCode
          ..bcd = existing.bcd ?? prepared.bcd
          ..ebmSynced = false;

        if (existing.addInfo != null &&
            existing.addInfo!.trim().startsWith('asset:')) {
          prepared.addInfo = existing.addInfo;
        }

        final stockQty = existing.stock?.currentStock ?? existing.qty ?? 0;
        if (stockQty > 0) {
          prepared.qty = stockQty;
          prepared.rsdQty = stockQty;
        }

        updatables.add(prepared);
      }

      await ProxyService.strategy.addVariant(
          skipRRaCall: false,
          variations: updatables,
          branchId: ProxyService.box.getBranchId()!);
      // add this variant to rra

      onCompleteCallback(updatables);
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<double> setTaxPercentage(Variant variant) async {
    newMod.Configurations? configurations =
        await ProxyService.strategy.getByTaxType(taxtype: variant.taxTyCd!);
    return configurations?.taxPercentage ?? 0;
  }

  Future<Product?> saveProduct(
      {required Product mproduct,
      required bool inUpdateProcess,
      required String productName,
      required String color}) async {
    try {
      ProxyService.analytics
          .trackEvent("product_creation", {'feature_name': 'product_creation'});

      Category? activeCat = await ProxyService.strategy
          .activeCategory(branchId: ProxyService.box.getBranchId()!);

      await ProxyService.strategy.updateProduct(
        productId: mproduct.id,
        name: productName,
        color: color,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
      );
      if (activeCat != null) {
        ProxyService.strategy.updateCategory(
          categoryId: activeCat.id,
          active: false,
          focused: false,
        );
      }
      return await ProxyService.strategy.getProduct(
          id: mproduct.id,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }
}
