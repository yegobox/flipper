library flipper_models;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

class DiscountViewModel extends ProductViewModel {
  Future<void> save({required String name, double? amount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    await ProxyService.isar
        .saveDiscount(branchId: branchId, name: name, amount: amount);
  }

  update({required String name, required double amount, required String id}) {
    ProxyService.isar.update(
      data: {'name': name, "amount": amount, "id": id},
    );
  }
}
