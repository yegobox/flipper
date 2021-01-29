import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/order_detail.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

class HomeViewModel extends ReactiveViewModel {
  final _sharedStateService = locator<SharedStateService>();
  final DatabaseService _databaseService = ProxyService.database;

  int _tab;
  int get tab {
    return _tab;
  }

  int _items;
  int get items {
    return _items;
  }

  // ignore: always_declare_return_types
  switchTab(int tab) {
    _tab = tab;
    notifyListeners();
  }

  // ignore: always_declare_return_types
  initTab() {
    _tab = 0;
    notifyListeners();
  }

  final List<OrderDetail> _details = [];
  List<OrderDetail> get sales => _details;
  void currentSale() {
    final q = Query(_databaseService.db,
        'SELECT id,taxAmount,table,branchId,reference,isDraft,orderType,orderNumber,subTotal,orderNote,cashReceived,channels WHERE table=\$T AND active=\$A');

    q.parameters = {'T': AppTables.order, 'A': true};
    final order = q.execute();
    if (order.isNotEmpty) {
      final Order ord = Order.fromMap(order[0]);
      final od = Query(_databaseService.db,
          'SELECT id,productName,variantName,stockId,unit,sku,quantity,orderId,taxRate,table,variantId,subTotal,channels,createdAt,updatedAt WHERE table=\$T AND orderId=\$O');
      od.parameters = {'T': AppTables.orderDetail, 'O': ord.id};
      final details = od.execute();

      if (details.isNotEmpty) {
        for (Map map in details) {
          if (!_details.contains(map)) {
            _details.add(OrderDetail.fromMap(map));
          }
        }
      }
      //   notifyListeners();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
