library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'stock_history.g.dart';

abstract class StockHistory
    implements Built<StockHistory, StockHistoryBuilder> {
  String get id;
  String get orderId;
  String get variantId;
  String get variantName;
  @nullable
  String get note;
  String get updatedAt;
  String get createdAt;
  String get stockId;
  String get reason;
  double get quantity;

  BuiltList<String> get channels;

  String get table;

  StockHistory._();

  // ignore: sort_unnamed_constructors_first
  factory StockHistory([void Function(StockHistoryBuilder) updates]) =
      _$StockHistory;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(StockHistory.serializer, this);
  }

  StockHistory fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static StockHistory fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(
        StockHistory.serializer, jsonMap);
  }

  static Serializer<StockHistory> get serializer => _$stockHistorySerializer;
}
