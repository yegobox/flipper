import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import 'Queries.dart';

class CategoryViewModel extends ReactiveViewModel {
  final Logger log = Logging.getLogger('category observer:)');

  final DatabaseService _db = ProxyService.database;

  Category _focusedCategory;

  Category get focusedCategory => _focusedCategory;

  final state = locator<SharedStateService>();

  List<Category> categories = [];

  void getCategories() {
    final q = Query(_db.db, Queries.Q_9);

    assert(state.branch.id != null);

    q.parameters = {'VALUE': AppTables.category, 'BRANCHID': state.branch.id};

    categories.clear();

    final results = q.execute();

    for (Map map in results.allResults) {
      if (Category.fromMap(map).focused) {
        _focusedCategory = Category.fromMap(map);
      }
      categories.add(Category.fromMap(map));
    }
    state.setCategories(categories: categories);
    notifyListeners();
    notifyListeners();
  }

  /// should always set the prev category to false
  /// keep moving selected category highlight
  Future<void> updateCategory({@required Category category}) async {
    //remove focus from previous focused category
    final String id = _focusedCategory == null ? 'null' : _focusedCategory.id;
    final Document prevCategory = _db.getById(id: id);
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

    _db.update(document: prevCategory);
  }

  void nextFocus(Category category) {
    final Document getCategory = _db.getById(id: category.id);

    assert(getCategory != null);

    getCategory.properties['focused'] = category.focused == true ? false : true;

    _db.update(document: getCategory);

    final Document updatedCategory = _db.getById(id: category.id);
    if (Category.fromMap(updatedCategory.map).focused) {
      _focusedCategory = Category.fromMap(updatedCategory.map);
    }
  }

  void createCategory({String name}) {
    if (name.isNotEmpty) {
      assert(state.user.id != null);
      assert(state.branch.id != null);
      final id = Uuid().v1().substring(0, 10);
      final Map<String, dynamic> category = {
        'active': true,
        'table': AppTables.category,
        'branchId': state.branch.id,
        'focused': false,
        'id': id,
        'channels': [state.user.id],
        'name': name
      };
      _db.insert(id: id, data: category);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [state];
}
