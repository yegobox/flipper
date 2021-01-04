import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'stock.g.dart';

abstract class Stock implements Built<Stock, StockBuilder> {
  double get value;
  String get id;
  String get branchId;

  String get variantId;

  @nullable
  bool get isActive;

  String get productId;

  double get lowStock;

  double get currentStock;

  double get supplyPrice;

  double get retailPrice;
  bool get canTrackingStock;

  @nullable
  bool get showLowStockAlert;

  BuiltList<String> get channels;

  String get table;

  Stock._();

  // ignore: sort_unnamed_constructors_first
  factory Stock([void Function(StockBuilder) updates]) = _$Stock;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Stock.serializer, this);
  }

  Stock fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static Stock fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Stock.serializer, jsonMap);
  }

  static Serializer<Stock> get serializer => _$stockSerializer;
}
