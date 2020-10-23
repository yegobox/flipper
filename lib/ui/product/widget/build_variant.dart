import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flutter/material.dart';

Future<List<Variation>> buildVariantsList(
    BuildContext context, Product product) async {
  final DatabaseService _databaseService = ProxyService.database;

  final List<Map<String, dynamic>> variation = await _databaseService.filter(
    equator: AppTables.variation,
    property: 'table',
    and: true, //define that this query is and type.
    andEquator: product.id,
    andProperty: 'productId',
  );
  List<Variation> variants;
  variants
      .addAll(variation.map((Map<String, dynamic> v) => Variation.fromMap(v)));

  return variants;
}
