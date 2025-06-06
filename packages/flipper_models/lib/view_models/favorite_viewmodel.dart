import 'package:flipper_models/db_model_export.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';

class FavoriteViewModel extends ProductViewModel {
  final AppService app = loc.getIt<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final ProductService productService = loc.getIt<ProductService>();

  get categories => app.categories;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  Future<List<Favorite>> getFavorites() async {
    List<Favorite> res = await ProxyService.strategy.getFavorites();
    return res;
  }

  Future<String> deleteFavoriteByIndex(String favIndex) async {
    Favorite? target = await getFavoriteByIndex(favIndex);
    await ProxyService.strategy.deleteFavoriteByIndex(favIndex: favIndex);
    notifyListeners();

    if (target != null) {
      return target.productId!;
    }
    return "403";
  }

  Future<Favorite?> getFavoriteById(String favId) async {
    Favorite? res = await ProxyService.strategy.getFavoriteById(favId: favId);
    return res;
  }

  Future<Favorite?> getFavoriteByIndex(String favIndex) async {
    Favorite? res =
        await ProxyService.strategy.getFavoriteByIndex(favIndex: favIndex);
    return res;
  }

  Future<Product?> getProductById(String prodIndex) async {
    Product? res = await ProxyService.strategy.getProduct(
        id: prodIndex,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!);
    return res;
  }
}
