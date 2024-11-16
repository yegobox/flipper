import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firestore_models/firestore_models.dart' as newMod;
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/power_sync/schema.dart';
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
    ///loop variations add pkgUnitCd this come from UI but a lot of
    ///EBM fields will be hard coded to simplify the UI, so we will loop the variation
    ///and add some missing fields to simplify the UI
    Business business = await ProxyService.local
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      ProxyService.local.realm!.writeN(
          tableName: variantTable,
          writeCallback: () {
            List<Variant> updatables = [];
            for (var i = 0; i < variations!.length; i++) {
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
              variations[i].pkg = "1";
              variations[i].itemCd = DateTime.now().generateFlipperClip();
              variations[i].modrNm = number;
              variations[i].modrId = number;
              variations[i].itemNm = variations[i].name;
              variations[i].regrId = randomNumber().toString().substring(0, 5);
              variations[i].rsdQty = variations[i].qty;
              variations[i].qty = variations[i].qty;
              variations[i].itemTyCd = selectedProductType;

              /// available type for itemTyCd are 1 for raw material and 3 for service
              /// is insurance applicable default is not applicable
              variations[i].isrcAplcbYn = "N";
              variations[i].useYn = "N";
              variations[i].itemSeq = i;
              variations[i].itemStdNm = variations[i].name;
              variations[i].taxPercentage = 18.0;
              // await setTaxPercentage(variations[i]);

              variations[i].tin = business.tinNumber;

              variations[i].bhfId = business.bhfId ?? "00";
              variations[i].bcd = variations[i].bcd;
              variations[i].splyAmt = variations[i].supplyPrice;

              /// country of origin for this item we default until we support something different
              /// and this will happen when we do import.
              variations[i].orgnNatCd = "RW";

              /// registration name
              variations[i].regrNm = variations[i].name;

              /// taxation type code
              variations[i].taxTyCd = variations[i].taxTyCd ??
                  "B"; // available types A(A-EX),B(B-18.00%),C,D
              variations[i].taxName = variations[i].taxTyCd ?? "B";
              // default unit price
              variations[i].dftPrc = variations[i].retailPrice;

              // NOTE: I believe bellow item are required when saving purchase
              variations[i].spplrItemCd = "";
              variations[i].spplrItemClsCd = "";
              variations[i].spplrItemNm = variations[i].name;
              variations[i].ebmSynced = false;

              /// Packaging Unit
              variations[i].qtyUnitCd = "U"; // see 4.6 in doc
              updatables.add(variations[i]);
            }

            ProxyService.local.addVariant(
                variations: updatables,
                branchId: ProxyService.box.getBranchId()!);

            return updatables;
          },
          onAdd: (data) {
            for (var item in data) {
              ProxyService.backUp.replicateData(variantTable, item);
            }
          });
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

  /// Add a product into the system
  Future<Product?> saveProduct(
      {required Product mproduct,
      required bool inUpdateProcess,
      required String productName,
      required String color}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});

    Category? activeCat = await ProxyService.local
        .activeCategory(branchId: ProxyService.box.getBranchId()!);
    List<Variant> variants = await ProxyService.local.variants(
        productId: mproduct.id, branchId: ProxyService.box.getBranchId()!);
    ProxyService.local.realm!.writeN(
      tableName: productsTable,
      writeCallback: () {
        mproduct.name = productName;
        mproduct.barCode = productService.barCode.toString();
        mproduct.color = color;

        // Update activeCat only if necessary
        if (activeCat?.active != false) {
          activeCat?.active = false;
        }
        if (activeCat?.focused != false) {
          activeCat?.focused = false;
        }

        // Update mproduct.id only if it hasn't been set yet
        if (mproduct.categoryId == null) {
          mproduct.categoryId = activeCat?.id!;
        }

        // Fetch variants asynchronously outside the loop

        // Update variants efficiently using a for loop with conditional updates
        for (Variant variant in variants) {
          if (variant.productName != productName) {
            variant.productName = productName;
          }

          if (variant.productId != mproduct.id) {
            variant.productId = mproduct.id!;
          }

          // Update pkgUnitCd only if necessary (assuming it's not always changing)
          if (variant.pkgUnitCd != "NT") {
            variant.pkgUnitCd = "NT";
          }
        }
        return mproduct;
      },
      onAdd: (data) {
        ProxyService.backUp.replicateData(productsTable, data);
      },
    );

    return ProxyService.local.getProduct(id: mproduct.id!);
  }
}
