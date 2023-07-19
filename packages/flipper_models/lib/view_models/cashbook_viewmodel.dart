import 'package:flipper_models/isar_models.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';

class CashbookViewModel extends ProductViewModel {
  // extends ReactiveViewModel
  final AppService app = loc.locator<AppService>();
  // ignore: annotate_overrides, overridden_fields

  get categories => app.categories;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  Stream<List<Transaction>> getTransactions() async* {
    Stream<List<Transaction>> res = await ProxyService.isar.getTransactions();
    yield* res;
  }

  Stream<List<Transaction>> getLocalTransactions() async* {
    Stream<List<Transaction>> res = await ProxyService.isar.getLocalTransactionsStream();
    yield* res;
  }

  Stream<List<Transaction>> getCashInTransactions() async* {
    Stream<List<Transaction>> res = await ProxyService.isar.getCashInTransactions();
    yield* res;
  }

  Stream<List<Transaction>> getCashOutTransactions() async* {
    Stream<List<Transaction>> res = await ProxyService.isar.getCashOutTransactions();
    yield* res;
  }

  Future<int> deleteTransactionByIndex(int transactionIndex) async {
    Transaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.isar.deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();
    ProxyService.app.pushDataToServer();
    if (target != null) {
      return target.id!;
    }
    return 403;
  }

  Future<Transaction?> getTransactionByIndex(int transactionIndex) async {
    Transaction? res =
        await ProxyService.isar.getTransactionById(id: transactionIndex);
    return res;
  }

}
