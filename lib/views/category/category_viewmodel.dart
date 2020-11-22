import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/category.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/shared_state_service.dart';

class CategoryViewModel extends BaseModel {
  final Logger log = Logging.getLogger('category observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  final List<Category> _category =[];
  final _sharedStateService = locator<SharedStateService>();
  List<Category> get data => _category;


  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getCategory({BuildContext context}) {
   
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.category};
    
    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          if(!_category.contains(Category.fromMap(value))){
             _category.add(Category.fromMap(value));
              notifyListeners();
          }
        });
        
      }
    });
  }

  void createCategory({String name}) {
    assert(_sharedStateService.user.id !=null);
    assert(_sharedStateService.branch.id!=null);
    final id = Uuid().v1();
     final Map<String, dynamic> category = {
      'active': true,
      'table': AppTables.category,
      'branchId': _sharedStateService.branch.id,
      'focused': false,
      'id':id,
      'channels':[_sharedStateService.user.id],
      'name': name
    };
    _databaseService.insert(id: id, data: category);
  }
}
