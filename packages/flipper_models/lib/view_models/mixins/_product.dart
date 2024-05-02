import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/realm_model_export.dart';
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
    for (var variant in variations!) {
      RegExp regExp = RegExp(r'^([^:]*):');

      variant.pkgUnitCd = regExp.firstMatch(packagingUnit!)!.group(1)!;
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
    int result = await ProxyService.isar.addVariant(
      variations: variations,
    );
    return result;
  }

  /// Add a product into the system
  Future<Product?> saveProduct(
      {required Product mproduct, required bool inUpdateProcess}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});

    mproduct.name = productName!;
    mproduct.barCode = productService.barCode.toString();
    mproduct.color = currentColor;

    Category? activeCat = await ProxyService.isar
        .activeCategory(branchId: ProxyService.box.getBranchId()!);

    activeCat?.active = false;
    activeCat?.focused = false;

    mproduct.categoryId = activeCat?.id!;

    await ProxyService.isar.update(data: activeCat);

    mproduct.action = inUpdateProcess ? AppActions.updated : AppActions.created;

    await ProxyService.isar.update(data: mproduct);
    List<Variant> variants =
        await ProxyService.isar.getVariantByProductId(productId: mproduct.id);

    for (Variant variant in variants) {
      variant.productName = productName!;

      variant.productId = mproduct.id!;
      variant.pkgUnitCd = "NT";
      variant.action =
          inUpdateProcess ? AppActions.updated : AppActions.created;
      await ProxyService.isar.update(data: variant);
    }

    return await ProxyService.isar.getProduct(id: mproduct.id!);
  }
}
