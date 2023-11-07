import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/all.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';

class CashbookViewModel extends ProductViewModel with SharebleMethods {
  final AppService app = loc.getIt<AppService>();

  get categories => app.categories;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  Future<String> deleteTransactionByIndex(String transactionIndex) async {
    ITransaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.isar
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();
    ProxyService.sync.push();
    if (target != null) {
      return target.id;
    }
    return '403';
  }

  Future<ITransaction?> getTransactionByIndex(String transactionIndex) async {
    ITransaction? res =
        await ProxyService.isar.getTransactionById(id: transactionIndex);
    return res;
  }
}
