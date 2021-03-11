import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/current_sale.dart';
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
  final List<CurrentSale> _currentSale = [];
  List<CurrentSale> get currentSale => _currentSale;
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
        'SELECT stock_histories.variantName,orders.id,stock_histories.quantity FROM orders JOIN stock_histories ON orders.id=stock_histories.orderId WHERE stock_histories.table=\$T AND orders.draft=\$A');

    q.parameters = {'T': AppTables.stockHistories, 'A': true};

    q.addChangeListener((List results) {
      if (results.isNotEmpty) {
        for (Map map in results) {
          _currentSale.add(CurrentSale.fromMap(map));
        }
        notifyListeners();
        // five feet apart.
      }
    });
    // clear the CurrentSale
    ProxyService.sharedState.clear.listen((e) {
      _currentSale.clear();
      notifyListeners();
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
