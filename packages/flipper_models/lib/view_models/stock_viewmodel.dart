import 'package:flipper_models/stock.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class StockViewModel extends BaseViewModel {
  List<Stock> _stocks = [];
  get stocks => _stocks;

  loadStockByProductId({required String productId}) async {
    _stocks = await ProxyService.api.stocks(productId: productId);
    notifyListeners();
  }
}
