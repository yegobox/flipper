import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class DiscountViewModel extends ReactiveViewModel {
  @override
  List<ReactiveServiceMixin> get reactiveServices => [];

  Future<void> save({required String name, double? amount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    await ProxyService.api
        .saveDiscount(branchId: branchId, name: name, amount: amount);
  }
}
