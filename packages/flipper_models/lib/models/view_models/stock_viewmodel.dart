library flipper_models;

import 'package:flipper_models/models/models.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class StockViewModel extends BaseViewModel {
  List<StockSync> _stocks = [];
  get stocks => _stocks;

  loadStockByProductId({required int productId}) async {
    _stocks = await ProxyService.api.stocks(productId: productId);
    notifyListeners();
  }
}
