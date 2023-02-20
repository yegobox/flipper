library flipper_models;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

class DiscountViewModel extends ProductViewModel {
  Future<void> save({required String name, double? amount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    await ProxyService.isarApi
        .saveDiscount(branchId: branchId, name: name, amount: amount);
  }

  update({required String name, required double amount, required int id}) {
    ProxyService.isarApi.update(
      data: {'name': name, "amount": amount, "id": id},
    );
  }
}
