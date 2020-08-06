import 'package:flipper/data/main_database.dart';
import 'package:flutter/cupertino.dart';

class ItemVariation {
  final VariationTableData variations;
  final ProductTableData items;

  ItemVariation({
    @required this.variations,
    @required this.items,
  });
}
