library flipper_models;

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

class DiscountViewModel extends ProductViewModel {
  Future<void> save({required String name, double? amount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    await ProxyService.strategy
        .saveDiscount(branchId: branchId, name: name, amount: amount);
  }
}
