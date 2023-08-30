import 'package:flipper_models/isar_models.dart';

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
    List<Favorite> res = await ProxyService.isar.getFavorites();
    return res;
  }

  Future<String> deleteFavoriteByIndex(int favIndex) async {
    Favorite? target = await getFavoriteByIndex(favIndex);
    await ProxyService.isar.deleteFavoriteByIndex(favIndex: favIndex);
    notifyListeners();
    ProxyService.sync.push();
    if (target != null) {
      return target.productId!;
    }
    return '403';
  }

  Future<Favorite?> getFavoriteById(int favId) async {
    Favorite? res = await ProxyService.isar.getFavoriteById(favId: favId);
    return res;
  }

  Future<Favorite?> getFavoriteByIndex(int favIndex) async {
    Favorite? res =
        await ProxyService.isar.getFavoriteByIndex(favIndex: favIndex);
    return res;
  }

  Future<Product?> getProductById(String prodIndex) async {
    Product? res = await ProxyService.isar.getProduct(id: prodIndex);
    return res;
  }
}
