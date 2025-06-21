import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
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
      required String countryofOrigin,
      required String productName,
      required String selectedProductType,
      String? color,
      Product? product,
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
      Category? category =
          await ProxyService.strategy.category(id: categoryId!);
      List<Variant> updatables = [];
      for (var i = 0; i < variations!.length; i++) {
        // Parse the packagingUnit string to extract code and name
        if (packagingUnit.isNotEmpty) {
          final parts = packagingUnit.split(':');
          if (parts.length >= 4) {
            // Format: "CODE:NUMBER:SHORT_DESCRIPTION:LONG_DESCRIPTION"
            final unitCode = parts[0];
            // Set all unit-related fields
            variations[i].pkgUnitCd = unitCode;
          } else {
            // Fallback if the format is different
            variations[i].pkgUnitCd = parts[0];
          }
        } else {
          // Fallback for non-string or empty packagingUnit
          final unitStr = packagingUnit.toString();
          variations[i].pkgUnitCd = unitStr;
        }
        final number = randomNumber().toString().substring(0, 5);

        variations[i].itemClsCd = variations[i].itemClsCd ?? "5020230602";
        variations[i].isrccNm = "";
        variations[i].isrcRt = 0;
        variations[i].categoryId = category?.id;
        variations[i].categoryName = category?.name;
        variations[i].dcRt = rates?[variations[i]] == null
            ? 0
            : double.parse(rates![variations[i]]!.text);

        variations[i].color = color;
        variations[i].pkg = 1;
        variations[i].itemCd = await ProxyService.strategy.itemCode(
            countryCode: countryofOrigin,
            productType: selectedProductType,
            branchId: ProxyService.box.getBranchId()!,
            packagingUnit: packagingUnit,
            quantityUnit: "CT");
        variations[i].modrNm = number;
        variations[i].productName = productName;
        variations[i].productId = product.id;
        variations[i].modrId = number;
        variations[i].prc = retailPrice;
        variations[i].supplyPrice = supplyPrice;
        variations[i].retailPrice = retailPrice;
        variations[i].regrId = randomNumber().toString().substring(0, 5);

        variations[i].itemTyCd = selectedProductType;

        /// available type for itemTyCd are 1 for raw material and 3 for service
        /// is insurance applicable default is not applicable
        variations[i].isrcAplcbYn = "N";
        variations[i].useYn = "N";
        variations[i].itemSeq = i;
        variations[i].itemStdNm = productName;
        variations[i].taxPercentage = 18.0;

        variations[i].tin = business!.tinNumber;

        variations[i].bhfId = business.bhfId ?? "00";
        variations[i].bcd = variations[i].bcd;
        variations[i].splyAmt = variations[i].supplyPrice;

        /// country of origin for this item comes from the selected country in CountryOfOriginSelector
        /// and this will happen when we do import.
        variations[i].orgnNatCd = countryofOrigin;
        variations[i].itemNm = productName;
        variations[i].name = productName;

        /// registration name
        variations[i].regrNm = productName;

        /// taxation type code
        variations[i].taxTyCd = variations[i].taxTyCd ??
            "B"; // available types A(A-EX),B(B-18.00%),C,D
        variations[i].taxName = variations[i].taxTyCd ?? "B";
        // default unit price
        variations[i].dftPrc = variations[i].retailPrice;

        // NOTE: I believe bellow item are required when saving purchase
        variations[i].spplrItemCd = "";
        variations[i].spplrItemClsCd = "";
        variations[i].spplrItemNm = productName;
        variations[i].ebmSynced = false;

        // Unit fields are already set above

        updatables.add(variations[i]);
      }

      await ProxyService.strategy.addVariant(
          variations: updatables, branchId: ProxyService.box.getBranchId()!);
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
    return configurations!.taxPercentage!;
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
