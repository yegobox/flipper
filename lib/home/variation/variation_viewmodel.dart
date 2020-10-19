import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:logger/logger.dart';
import 'package:redux/redux.dart';

class VariationViewModel extends BaseModel {
  final Logger log = Logging.getLogger('product observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> variations;
  List<Variation> get data => variations;

 Future closeAndDelete({@required String productId, BuildContext context}) async {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    await DataManager.deleteProduct(store: store, productId: productId);
    Routing.navigator.pop();
  }

  Future handleEditItem({dynamic selections}) async {
    TaxTableData tax;
    // FIXME(richard): handle updating item
    if (selections[0] == true) {
      //then use 18 % known id in database. 0 index we know it is 18% 0 otherwise
      // tax = await store.state.database.taxDao.getByName(
      //     name: 'Vat', businessId: store.state.currentActiveBusiness.id);
    }

    // final ProductTableData product =
    //     await vm.database.productDao.getItemById(productId: widget.productId);

    // vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));

    // vm.database.productDao.updateProduct(
    //   product.copyWith(
    //     taxId: tax.id ?? product.taxId,
    //     name: _name ?? product.name,
    //     updatedAt: DateTime.now(),
    //   ),
    // );
    Routing.navigator.pop();
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    //demo of listening on users table on every entry.
    _databaseService
        .observer(
            equator: AppTables.product +
                StoreProvider.of<AppState>(context).state.branch.id,
            property: 'tableName')
        .stream
        .listen((ResultSet event) {
      // variations = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Product> list = <Product>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(value);
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}
