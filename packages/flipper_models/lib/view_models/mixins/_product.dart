import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_services/locator.dart' as loc;

mixin ProductMixin {
  String? productName;

  final ProductService productService = loc.getIt<ProductService>();
  String currentColor = '#0984e3';

  Future<int> addVariant({List<Variant>? variations}) async {
    int result = await ProxyService.isar.addVariant(
      variations: variations!,
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

    mproduct.categoryId = activeCat?.id;

    await ProxyService.isar.update(data: activeCat);

    mproduct.action = inUpdateProcess ? AppActions.updated : AppActions.created;

    await ProxyService.isar.update(data: mproduct);
    List<Variant> variants =
        await ProxyService.isar.getVariantByProductId(productId: mproduct.id);

    for (Variant variant in variants) {
      variant.productName = productName!;

      variant.productId = mproduct.id;
      variant.pkgUnitCd = "NT";
      variant.action =
          inUpdateProcess ? AppActions.updated : AppActions.created;
      await ProxyService.isar.update(data: variant);
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant);
      }
    }
    ProxyService.sync.push();

    return await ProxyService.isar.getProduct(id: mproduct.id);
  }
}
