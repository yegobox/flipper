library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  String get id;
  String get branchId;

  String get reference;

  bool get draft;

  bool get active;

  String get orderType;

  String get orderNUmber;

  double get subTotal;

  @nullable
  double get taxAmount;

  double get amount;

  double get quantity;
  @nullable
  double get saleTotal;

  @nullable
  String get orderNote;

  @nullable
  String get status;

  String get variantId;

  String get stockId;

  @nullable
  String get productName;

  String get variantName;

  BuiltList<String> get channels;

  double get customerChangeDue;
  // ignore: sort_constructors_first
  Order._();
  factory Order([void Function(OrderBuilder) updates]) = _$Order;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Order.serializer, this);
  }

  Order fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Order fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Order.serializer, jsonMap);
  }

  static Serializer<Order> get serializer => _$orderSerializer;
}
