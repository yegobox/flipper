import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_services/locator.dart' as loc;

mixin ProductMixin {
  final ProductService productService = loc.getIt<ProductService>();
  String currentColor = '#0984e3';

  Future<void> addVariant(
      {List<Variant>? variations, required packagingUnit}) async {
    ///loop variations add pkgUnitCd this come from UI but a lot of
    ///EBM fields will be hard coded to simplify the UI, so we will loop the variation
    ///and add some missing fields to simplify the UI
    Business business = await ProxyService.local
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      ProxyService.realm.realm!.write(() {
        List<Variant> updatables = [];
        for (var i = 0; i < variations!.length; i++) {
          String itemPrefix = "FLIPPER-";
          String clip = itemPrefix +
              DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);
          variations[i].pkgUnitCd = packagingUnit;
          final number = randomNumber().toString().substring(0, 5);

          variations[i].itemClsCd = variations[i].itemClsCd ?? "5020230602";
          variations[i].isrccNm = "";
          variations[i].isrcRt = 0;
          variations[i].color = currentColor;
          variations[i].pkg = "1";
          variations[i].itemCd = clip;
          variations[i].modrNm = number;
          variations[i].modrId = number;
          variations[i].itemNm = variations[i].name;
          variations[i].regrId = randomNumber().toString().substring(0, 5);
          variations[i].rsdQty = variations[i].qty;
          variations[i].itemTyCd = "2"; // this is a finished product
          /// available type for itemTyCd are 1 for raw material and 3 for service
          /// is insurance applicable default is not applicable
          variations[i].isrcAplcbYn = "N";
          variations[i].useYn = "N";
          variations[i].itemSeq = i;
          variations[i].itemStdNm = variations[i].name;
          variations[i].taxPercentage = 18.0;
          variations[i].tin = business.tinNumber;

          variations[i].bhfId = business.bhfId ?? "00";
          variations[i].bcd = variations[i].name;
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

        ProxyService.realm.addVariant(
            variations: updatables, branchId: ProxyService.box.getBranchId()!);
      });
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      throw e;
    }
  }

  /// Add a product into the system
  Future<Product?> saveProduct(
      {required Product mproduct,
      required bool inUpdateProcess,
      required String productName,
      required String color}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});

    Category? activeCat = await ProxyService.realm
        .activeCategory(branchId: ProxyService.box.getBranchId()!);
    List<Variant> variants = await ProxyService.realm.variants(
        productId: mproduct.id, branchId: ProxyService.box.getBranchId()!);
    ProxyService.realm.realm!.write(() {
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

      mproduct.action =
          inUpdateProcess ? AppActions.updated : AppActions.created;

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

        variant.action =
            inUpdateProcess ? AppActions.updated : AppActions.created;
      }
    });

    return ProxyService.realm.getProduct(id: mproduct.id!);
  }
}
