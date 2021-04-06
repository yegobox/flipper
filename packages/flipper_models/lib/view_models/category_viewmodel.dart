import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
// import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'Queries.dart';
import 'base_model.dart';

class CategoryViewModel extends BaseModel {
  final Logger log = Logging.getLogger('category observer:)');

  final DatabaseService _databaseService = ProxyService.database;

  final List<Category> _category = [];

  Category _focusedCategory;

  Category get focusedCategory => _focusedCategory;

  final sharedStateService = locator<SharedStateService>();

  List<Category> get categories => _category;

  void getCategory({BuildContext context}) {
    final q = Query(_databaseService.db, Queries.Q_9);

    assert(sharedStateService.branch.id != null);

    q.parameters = {
      'VALUE': AppTables.category,
      'BRANCHID': sharedStateService.branch.id
    };

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        if (!_category.contains(Category.fromMap(map))) {
          //if we get the category that exist that only changed from one property change it from a list
          for (var i = 0; i < _category.length; i++) {
            if (_category[i].id == Category.fromMap(map).id) {
              //the object was in the list so no need to re-add it twice we need to change the object in list first
              _category.removeWhere((item) => item.id == _category[i].id);
            }
          }
          if (Category.fromMap(map).focused) {
            _focusedCategory = Category.fromMap(map);
          }
          _category.add(Category.fromMap(map));
          notifyListeners();
        }
      }
    });
  }

  void createCategory({String name}) {
    if (name.isNotEmpty) {
      assert(sharedStateService.user.id != null);
      assert(sharedStateService.branch.id != null);
      final id = Uuid().v1().substring(0, 10);
      final Map<String, dynamic> category = {
        'active': true,
        'table': AppTables.category,
        'branchId': sharedStateService.branch.id,
        'focused': false,
        'id': id,
        'channels': [sharedStateService.user.id],
        'name': name
      };
      _databaseService.insert(id: id, data: category);
    }
  }

  /// should always set the prev category to false
  /// keep moving selected category highlight
  Future<void> updateCategory({@required Category category}) async {
    //remove focus from previous focused category
    final prevCategory = _databaseService.getById(id: _focusedCategory.id);
    assert(prevCategory != null);
    prevCategory.properties['focused'] = false;

    _databaseService.update(document: prevCategory);
    //done updating previous selected category

    //then update the current category to select
    final Document getCategory = _databaseService.getById(id: category.id);

    assert(getCategory != null);

    getCategory.properties['focused'] = category.focused == true ? false : true;

    _databaseService.update(document: getCategory);

    final Document updatedCategory = _databaseService.getById(id: category.id);
    if (Category.fromMap(updatedCategory.map).focused) {
      _focusedCategory = Category.fromMap(updatedCategory.map);
    }
  }
}
