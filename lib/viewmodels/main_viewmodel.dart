
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';

import 'base_model.dart';

class MainViewModel extends BaseModel {
  final Logger log = Logging.getLogger('main view model:)');
  final DatabaseService _databaseService = ProxyService.database;

  List<Category> _categories;
  List<Category> get data => _categories;

  void listenCategory({String branchId}) {
    setBusy(true);

    // _databaseService
    //     .observer(equator: AppTables.category, property: 'table')
    //     .stream
    //     .listen((ResultSet event) {
    //   final List<Map<String, dynamic>> model = event.map((Result result) {
    //     return result.toMap();
    //   }).toList();
     
    //   for (Map map in model) {
        
    //     map.forEach((key, value) {
    //       log.i(value);
          
    //     });
    //   }

    //   notifyListeners();

    //   setBusy(false);
    // });
  }
}
