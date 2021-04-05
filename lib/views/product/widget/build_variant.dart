import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';

Future<List<Variation>> buildVariantsList(
    BuildContext context, Product product) async {
  final DatabaseService _databaseService = ProxyService.database;

  final q = Query(_databaseService.db,
      'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

  q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': product.id};
  List<Variation> variants;

  final results = q.execute();

  for (Map map in results.allResults) {
    map.forEach((key, value) {
      variants.add(Variation.fromMap(value));
    });
  }
  return variants;
}
