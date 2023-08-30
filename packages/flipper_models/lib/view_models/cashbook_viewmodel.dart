import 'package:flipper_models/isar_models.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';

class CashbookViewModel extends ProductViewModel {
  final AppService app = loc.getIt<AppService>();

  get categories => app.categories;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  Stream<List<Transaction>> getTransactions() async* {
    Stream<List<Transaction>> res =
        await ProxyService.isar.transactionsStreams();
    yield* res;
  }

  Stream<List<Transaction>> getLocalTransactions() async* {
    Stream<List<Transaction>> res =
        await ProxyService.isar.transactionsStreams();
    yield* res;
  }

  Stream<List<Transaction>> getCashInTransactions() async* {
    Stream<List<Transaction>> res =
        await ProxyService.isar.transactionsStreams(isCashOut: false);
    yield* res;
  }

  Stream<List<Transaction>> getCashOutTransactions() async* {
    Stream<List<Transaction>> res =
        await ProxyService.isar.transactionsStreams(isCashOut: true);
    yield* res;
  }

  Future<String> deleteTransactionByIndex(String transactionIndex) async {
    Transaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.isar
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();
    ProxyService.sync.push();
    if (target != null) {
      return target.id;
    }
    return '403';
  }

  Future<Transaction?> getTransactionByIndex(String transactionIndex) async {
    Transaction? res =
        await ProxyService.isar.getTransactionById(id: transactionIndex);
    return res;
  }
}
