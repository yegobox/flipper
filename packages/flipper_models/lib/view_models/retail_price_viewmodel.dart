library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
// import 'package:flipper_services/locator.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'Queries.dart';
import 'base_model.dart';

class RetailPriceViewModel extends BaseModel {
  final Logger log = Logging.getLogger('retail price:)');
  final DatabaseService _databaseService = ProxyService.database;
  final _sharedStateService = locator<SharedStateService>();
  List<Variation> get variations => _sharedStateService.variations;

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getVariations({BuildContext context, String productId}) {
    final List<Variation> list = <Variation>[];
    final q = Query(_databaseService.db, Queries.Q_1);

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        if (!list.contains(Variation.fromMap(map))) {
          list.add(Variation.fromMap(map));
          _sharedStateService.setVariations(variations: list);
        }
      }
      notifyListeners();
    });
  }
}
