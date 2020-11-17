import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flipper/utils/constant.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RetailPriceViewModel extends BaseModel {
  final Logger log = Logging.getLogger('retail price:)');
  final DatabaseService _databaseService = ProxyService.database;
  final _sharedStateService = locator<SharedStateService>();
  List<Variation> get variations => _sharedStateService.variations;

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getVariations({BuildContext context, String productId}) {
    setBusy(true);

    final List<Variation> list = <Variation>[];
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          list.add(Variation.fromMap(value));
        });
        _sharedStateService.setVariations(variations: list);

        notifyListeners();
      }
    });
  }
}
