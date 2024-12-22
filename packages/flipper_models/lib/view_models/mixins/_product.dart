import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
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
      Map<int, TextEditingController>? rates,
      Map<int, TextEditingController>? dates,
      required String selectedProductType}) async {
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      List<Variant> updatables = [];
      for (var i = 0; i < variations!.length; i++) {
        variations[i].pkgUnitCd = packagingUnit;
        final number = randomNumber().toString().substring(0, 5);

        variations[i].itemClsCd = variations[i].itemClsCd ?? "5020230602";
        variations[i].isrccNm = "";
        variations[i].isrcRt = 0;
        variations[i].dcRt = rates?[variations[i]] == null
            ? 0.0
            : double.parse(rates![variations[i]]!.text);

        variations[i].expirationDate = dates?[variations[i].id] == null
            ? null
            : DateTime.tryParse(dates![variations[i].id]!.text);

        variations[i].color = currentColor;
        variations[i].pkg = "1";
        variations[i].itemCd = DateTime.now().generateFlipperClip();
        variations[i].modrNm = number;
        variations[i].modrId = number;
        variations[i].itemNm = variations[i].name;
        variations[i].regrId = randomNumber().toString().substring(0, 5);

        variations[i].itemTyCd = selectedProductType;

        variations[i].isrcAplcbYn = "N";
        variations[i].useYn = "N";
        variations[i].itemSeq = i;
        variations[i].itemStdNm = variations[i].name;
        variations[i].taxPercentage = 18.0;

        variations[i].tin = business!.tinNumber;

        variations[i].bhfId = business.bhfId ?? "00";
        variations[i].bcd = variations[i].bcd;
        variations[i].splyAmt = variations[i].supplyPrice;

        variations[i].orgnNatCd = "RW";

        variations[i].regrNm = variations[i].name;

        variations[i].taxTyCd = variations[i].taxTyCd ?? "B";
        variations[i].taxName = variations[i].taxTyCd ?? "B";

        variations[i].dftPrc = variations[i].retailPrice;

        variations[i].spplrItemCd = "";
        variations[i].spplrItemClsCd = "";
        variations[i].spplrItemNm = variations[i].name;
        variations[i].ebmSynced = false;

        variations[i].qtyUnitCd = "U";
        updatables.add(variations[i]);
      }

      ProxyService.strategy.addVariant(
          variations: updatables, branchId: ProxyService.box.getBranchId()!);
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
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});

    Category? activeCat = await ProxyService.strategy
        .activeCategory(branchId: ProxyService.box.getBranchId()!);
    List<Variant> variants = await ProxyService.strategy.variants(
        productId: mproduct.id, branchId: ProxyService.box.getBranchId()!);

    ProxyService.strategy
        .updateProduct(productId: mproduct.id, name: productName, color: color);

    ProxyService.strategy.updateCategory(
      categoryId: activeCat!.id,
      active: false,
      focused: false,
    );

    for (Variant variant in variants) {
      await ProxyService.strategy.updateVariant(
          updatables: [variant],
          variantId: variant.id,
          productName: productName,
          productId: mproduct.id,
          pkgUnitCd: "NT");
    }

    return ProxyService.strategy.getProduct(id: mproduct.id);
  }
}
