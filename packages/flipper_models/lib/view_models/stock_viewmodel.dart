library flipper_models;

import 'package:flipper_models/isar/stock.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class StockViewModel extends BaseViewModel {
  List<Stock?> _stocks = [];
  get stocks => _stocks;

  loadStockByProductId({required int productId}) async {
    _stocks = await ProxyService.isar.stocks(productId: productId);
    notifyListeners();
  }
}
