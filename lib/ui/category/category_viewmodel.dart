import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/category.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CategoryViewModel extends BaseModel {
  final Logger log = Logging.getLogger('category observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Category> _category;
  List<Category> get data => _category;

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    //demo of listening on users table on every entry.
    _databaseService
        .observer(
            equator: AppTables.category,
            property: 'table')
        .stream
        .listen((ResultSet event) {
      // _category = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Category> list = <Category>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(Category.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}
