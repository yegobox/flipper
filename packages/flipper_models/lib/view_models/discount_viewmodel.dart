import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/proxy.dart';

class DiscountViewModel extends ProductViewModel {
  Future<void> save({required String name, double? amount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    await ProxyService.api
        .saveDiscount(branchId: branchId, name: name, amount: amount);

    loadProducts();
  }

  update({required String name, required double amount, required int id}) {
    ProxyService.api.update(
      data: {'name': name, "amount": amount, "id": id},
      endPoint: 'discount/$id',
    );
    loadProducts();
  }
}
