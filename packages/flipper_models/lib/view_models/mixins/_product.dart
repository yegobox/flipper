import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_services/locator.dart' as loc;

mixin ProductMixin {
  String? productName;

  final ProductService productService = loc.getIt<ProductService>();
  String currentColor = '#0984e3';

  Future<int> addVariant(
      {List<Variant>? variations, required packagingUnit}) async {
    ///loop variations add pkgUnitCd this come from UI but a lot of
    ///EBM fields will be hard coded to simplify the UI, so we will loop the variation
    ///and add some missing fields to simplify the UI
    Business business = await ProxyService.realm
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    try {
      for (var variant in variations!) {
        variant.pkgUnitCd = packagingUnit;
        final number = randomNumber().toString().substring(0, 5);
        variant.itemClsCd =
            "5020230602"; // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
        variant.itemCd = randomNumber().toString().substring(0, 5);
        variant.modrNm = number;
        variant.modrId = number;
        variant.itemNm = variant.name;
        variant.pkgUnitCd = "BJ";
        variant.regrId = randomNumber().toString().substring(0, 5);
        variant.rsdQty = variant.qty;
        variant.itemTyCd = "2"; // this is a finished product
        /// available type for itemTyCd are 1 for raw material and 3 for service
        /// is insurance applicable default is not applicable
        variant.isrcAplcbYn = "N";
        variant.useYn = "N";
        variant.itemSeq = randomNumber().toString();
        variant.itemStdNm = variant.name;
        variant.taxPercentage = 18.0;
        variant.tin = business.tinNumber;
        variant.bhfId =
            "00"; //TODO: for now we are hardcoding this which can be wrong
        variant.bcd = variant.name;

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        variant.orgnNatCd = "RW";

        /// registration name
        variant.regrNm = variant.name;

        /// taxation type code
        variant.taxTyCd = "B"; // available types A(A-EX),B(B-18.00%),C,D
        // default unit price
        variant.dftPrc = variant.retailPrice;

        // NOTE: I believe bellow item are required when saving purchase
        ///but I wonder how to get them when saving an item.
        variant.spplrItemCd = randomNumber().toString().substring(0, 5);
        variant.spplrItemClsCd = randomNumber().toString().substring(0, 5);
        variant.spplrItemNm = variant.name;

        /// Packaging Unit
        variant.qtyUnitCd = "U"; // see 4.6 in doc
      }
      int result = await ProxyService.realm.addVariant(
        variations: variations,
      );
      return result;
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      throw e;
    }
  }

  /// Add a product into the system
  Future<Product?> saveProduct(
      {required Product mproduct, required bool inUpdateProcess}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});
    ProxyService.realm.realm!.writeAsync(() async {
      Category? activeCat = await ProxyService.realm
          .activeCategory(branchId: ProxyService.box.getBranchId()!);

      ProxyService.realm.realm!.writeAsync(() async {
        mproduct.name = productName!;
        mproduct.barCode = productService.barCode.toString();
        mproduct.color = currentColor;

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
        List<Variant> variants = await ProxyService.realm
            .getVariantByProductId(productId: mproduct.id);

        // Update variants efficiently using a for loop with conditional updates
        for (Variant variant in variants) {
          if (variant.productName != productName) {
            variant.productName = productName!;
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
    });

    return await ProxyService.realm.getProduct(id: mproduct.id!);
  }
}
