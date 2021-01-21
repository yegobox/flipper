import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/viewmodels/base_model.dart';

import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';

class SupplierViewmodel extends BaseModel {
  final Logger log = Logging.getLogger('supplier viewmodel:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> _variation;
  List<Variation> get data => _variation;

  void getVariants({BuildContext context, @required String productId}) {
    setBusy(true);

    log.i('loading variation of ProductId:' + productId);

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.variation};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          _variation.add(Variation.fromMap(value));
        });
        setBusy(false);
        notifyListeners();
      }
    });
  }
}
