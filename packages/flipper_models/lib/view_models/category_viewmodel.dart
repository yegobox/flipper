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

  Category _focusedCategory;

  Category get focusedCategory => _focusedCategory;

  final sharedStateService = locator<SharedStateService>();

  final List<Category> categories = [];

  void getCategories() {
    final q = Query(_databaseService.db, Queries.Q_9);

    assert(sharedStateService.branch.id != null);

    q.parameters = {
      'VALUE': AppTables.category,
      'BRANCHID': sharedStateService.branch.id
    };
    categories.clear();

    final results = q.execute();

    for (Map map in results.allResults) {
      if (Category.fromMap(map).focused) {
        _focusedCategory = Category.fromMap(map);
      }
      categories.add(Category.fromMap(map));
    }
    print(categories);
    notifyListeners();
  }

  /// should always set the prev category to false
  /// keep moving selected category highlight
  Future<void> updateCategory({@required Category category}) async {
    //remove focus from previous focused category
    final String id = _focusedCategory == null ? 'null' : _focusedCategory.id;
    final Document prevCategory = _databaseService.getById(id: id);
    if (prevCategory == null) {
      nextFocus(category);
    } else {
      prevFocus(prevCategory);
      nextFocus(category);
    }
    getCategories();
  }

  void prevFocus(Document prevCategory) {
    prevCategory.properties['focused'] = false;

    _databaseService.update(document: prevCategory);
  }

  void nextFocus(Category category) {
    final Document getCategory = _databaseService.getById(id: category.id);

    assert(getCategory != null);

    getCategory.properties['focused'] = category.focused == true ? false : true;

    _databaseService.update(document: getCategory);

    final Document updatedCategory = _databaseService.getById(id: category.id);
    if (Category.fromMap(updatedCategory.map).focused) {
      _focusedCategory = Category.fromMap(updatedCategory.map);
    }
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
}
