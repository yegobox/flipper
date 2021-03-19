import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
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
  final List<Order> _currentSale = [];
  List<Order> get currentSale => _currentSale;
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

  /// get current sale orders these are orders that has status of pending.
  /// if the order marked completed or parked then it does not show on current sale
  /// an order can be marked as parked when added to a ticket for later sale
  /// and can be marked as completed when a cashier has done taking cash on specific order.
  /// Note that a ticket can have many orders on it. the mothod alos listen on when it is time
  /// to clear the count and pending oder and start over.
  void countItemOnCurrentOrder() {
    final q =
        Query(_databaseService.db, 'SELECT  *  WHERE table=\$T AND status=\$S');

    q.parameters = {'T': AppTables.order, 'S': 'pending'};

    q.addChangeListener((List results) {
      if (results.isNotEmpty) {
        for (Map map in results) {
          // _databaseService.delete(id: CurrentSale.fromMap(map).orderId);
          // _databaseService.delete(id: CurrentSale.fromMap(map).stockHistoryId);
          map.forEach((key, value) {
            //  _databaseService.delete(id: value['id']);
            _currentSale.add(Order.fromMap(value));
          });
        }
        notifyListeners();
      }
    });
    // clear the CurrentSale
    ProxyService.sharedState.clear.listen((e) {
      final q = Query(
          _databaseService.db, 'SELECT  id  WHERE table=\$T AND status=\$S');
      q.parameters = {'T': AppTables.order, 'S': 'pending'};
      final results = q.execute();
      if (results.isNotEmpty) {
        for (Map id in results) {
          _databaseService.delete(id: id['id']);
        }
      }
      _currentSale.clear();
      notifyListeners();
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
