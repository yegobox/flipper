import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flutter/material.dart';

Future<List<Variation>> buildVariantsList(
    BuildContext context, Product product) async {
  final DatabaseService _databaseService = ProxyService.database;

  final q = Query(_databaseService.db,
      'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

  q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': product.id};
  List<Variation> variants;

  final variationsResults = q.execute();

  for (Map map in variationsResults) {
    map.forEach((key, value) {
      variants.add(Variation.fromMap(value));
    });
  }
  return variants;
}
