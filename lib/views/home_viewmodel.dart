import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/stock_history.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

class HomeViewModel extends ReactiveViewModel {
  final _sharedStateService = locator<SharedStateService>();
  final DatabaseService _databaseService = ProxyService.database;
  final List<StockHistory> _orders = [];
  List<StockHistory> get orders => _orders;
  final Logger log = Logging.getLogger('O1:)');
  int _tab;
  int get tab {
    return _tab;
  }

  int _items;
  int get items {
    return _items;
  }

  void switchTab(int tab) {
    _tab = tab;
    notifyListeners();
  }

  void initTab() {
    _tab = 0;
    notifyListeners();
  }

  void countItemOnCurrentOrder() {
    final q = Query(_databaseService.db,
        'SELECT stocks_histories.id,stocks_histories.orderId,stocks_histories.table,stocks_histories.variantId,stocks_histories.variantName,stocks_histories.note,stocks_histories.updatedAt,stocks_histories.createdAt,stocks_histories.stockId,stocks_histories.reason,stocks_histories.quantity,stocks_histories.channels FROM stocks_histories JOIN orders ON stocks_histories.orderId=orders.id WHERE orders.active=\$ACTIVE AND stocks_histories.orderId=\$OID');

    final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);

    q.parameters = {
      'ACTIVE': true,
      'OID': pOrder.id
    }; //looking for active order joined with stock_histories

    q.addChangeListener((List orders) {
      if (orders.isNotEmpty) {
        for (Map map in orders) {
          print(map);
          if (!_orders.contains(StockHistory.fromMap(map))) {
            _orders.add(StockHistory.fromMap(map));
          }
        }
        notifyListeners();
      }
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
