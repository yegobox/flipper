import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/realm_model_export.dart';
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
      required packagingUnit,
      Map<String, TextEditingController>? rates,
      Map<String, TextEditingController>? dates,
      double? retailPrice,
      double? supplyPrice,
      required String productName,
      required String selectedProductType}) async {
    ///loop variations add pkgUnitCd this come from UI but a lot of
    ///EBM fields will be hard coded to simplify the UI, so we will loop the variation
    ///and add some missing fields to simplify the UI
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      // find the related product to update its name
      final product = await ProxyService.strategy.getProduct(
          id: variations!.first.productId!,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!);
      ProxyService.strategy.updateProduct(
        productId: product!.id,
        name: productName,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
      );
      List<Variant> updatables = [];
      for (var i = 0; i < variations.length; i++) {
        variations[i].pkgUnitCd = packagingUnit;
        final number = randomNumber().toString().substring(0, 5);

        variations[i].itemClsCd = variations[i].itemClsCd ?? "5020230602";
        variations[i].isrccNm = "";
        variations[i].isrcRt = 0;
        variations[i].dcRt = rates?[variations[i]] == null
            ? 0
            : double.parse(rates![variations[i]]!.text);

        variations[i].expirationDate = dates?[variations[i].id] == null
            ? null
            : DateTime.tryParse(dates![variations[i].id]!.text);

        variations[i].color = currentColor;
        variations[i].pkg = 1;
        variations[i].itemCd = await ProxyService.strategy.itemCode(
            countryCode: "RW",
            productType: "2",
            branchId: ProxyService.box.getBranchId()!,
            packagingUnit: packagingUnit,
            quantityUnit: "CT");
        variations[i].modrNm = number;
        variations[i].productName = productName;
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

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        variations[i].orgnNatCd = "RW";
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

        /// Packaging Unit
        variations[i].qtyUnitCd = "U"; // see 4.6 in doc
        updatables.add(variations[i]);
      }

      await ProxyService.strategy.addVariant(
          variations: updatables, branchId: ProxyService.box.getBranchId()!);
      // add this variant to rra
      await VariantPatch.patchVariant(
        URI: (await ProxyService.box.getServerUrl())!,
        sendPort: (message) {
          // ProxyService.notification.sendLocalNotification(body: message);
        },
      );
      StockPatch.patchStock(
        URI: (await ProxyService.box.getServerUrl())!,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      throw e;
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
      List<Variant> variants = await ProxyService.strategy.variants(
          productId: mproduct.id, branchId: ProxyService.box.getBranchId()!);

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

      for (Variant variant in variants) {
        await ProxyService.strategy.updateVariant(
            updatables: [variant],
            variantId: variant.id,
            productName: productName,
            productId: mproduct.id,
            pkgUnitCd: "CT");
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
