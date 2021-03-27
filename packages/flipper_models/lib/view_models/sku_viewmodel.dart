library flipper_models;
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper/viewmodels/base_model.dart';

import 'package:flipper/utils/constant.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';

class SkuViewModel extends BaseModel {
  final Logger log = Logging.getLogger('sku:variation observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> _variation;
  List<Variation> get data => _variation;
  TextEditingController _skuController;
  TextEditingController get skuController {
    return _skuController;
  }

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getVariations({BuildContext context, String productId}) {
    setBusy(true);

    final List<Unit> list = <Unit>[];

    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          list.add(Unit.fromMap(value));
        });
        notifyListeners();
      }
    });
  }
}
