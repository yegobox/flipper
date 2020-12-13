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
  final List<Category> _category = [];
  final sharedStateService = locator<SharedStateService>();
  List<Category> get categories => _category;

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getCategory({BuildContext context}) {
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND branchId=\$BRANCHID');
    assert(sharedStateService.branch.id !=null);
    q.parameters = {'VALUE': AppTables.category,'BRANCHID':sharedStateService.branch.id};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          if (!_category.contains(Category.fromMap(value))) {
            _category.add(Category.fromMap(value));
            notifyListeners();
          }
        });
      }
    });
  }

  void createCategory({String name}) {
    assert(sharedStateService.user.id != null);
    assert(sharedStateService.branch.id != null);
    final id = Uuid().v1();
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

  // selection
  Future<void> updateCategory(
      {@required String categoryId}) async {
    //NOTE updating a value  based on select// this may load to more information  // Need  update other category different to id parsedto fix it
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND branchId=\$BRANCHID');

    q.parameters = {'VALUE': AppTables.category,'BRANCHID':sharedStateService.branch.id};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {

          if (!_category.contains(Category.fromMap(value))) {
            _category.add(Category.fromMap(value));
          }
          for (int i = 0; i < _category.length; i++) {

            if (_category[i].id == categoryId) {
              final Document categories =
                  _databaseService.getById(id: _category[i].id);

              assert(categories != null);
              categories.properties['name'] = _category[i].name;
              categories.properties['focused'] = !_category[i].focused;

              _databaseService.update(document: categories);
              notifyListeners();
            } else {
              final Document categories =
                  _databaseService.getById(id: _category[i].id);
              assert(categories != null);
              categories.properties['name'] = _category[i].name;
              categories.properties['focused'] = false;

              _databaseService.update(document: categories);
              notifyListeners();
            }
          }
        });
      }
    });

    notifyListeners();
  }

  void highlight(Object value) {
    log.d(value);
  }
}
