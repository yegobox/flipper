
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'base_model.dart';

class MainViewModel extends BaseModel {
  final Logger log = Logging.getLogger('main view model:)');
  final DatabaseService _databaseService = ProxyService.database;

  List<Category> _categories;
  List<Category> get data => _categories;

  void listenCategory({String branchId}) {
    setBusy(true);

    _databaseService
        .observer(equator: 'category_'+branchId, property: 'tableName')
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      // ignore: always_specify_types
      // remove unnecessarry nesting "main"appended on each map value
      // ignore: always_specify_types
      for (Map map in model) {
        // ignore: always_specify_types
        map.forEach((key, value) {
          _categories.add(Category.fromMap(value));
        });
      }
     
      notifyListeners();

      setBusy(false);
    });
  }
  
}
