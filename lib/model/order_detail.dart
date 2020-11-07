import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'order_detail.g.dart';

abstract class OrderDetail implements Built<OrderDetail, OrderDetailBuilder> {
  String get id;
  String get price;

  String get variantName;
  String get productName;
  String get canTrackStock;
  String get stockId;
  String get unit;
  String get sku;
  String get quantity;
  String get variantId;
  int get taxRate;
  double get taxAmount;
  String get orderId;
  double get subTotal;
  String get table;
  String get createdAt;
  String get updatedAt;

  BuiltList<String> get channels;

  OrderDetail._();
  factory OrderDetail([void Function(OrderDetailBuilder) updates]) =
      _$OrderDetail;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(OrderDetail.serializer, this);
  }

  OrderDetail fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static OrderDetail fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(OrderDetail.serializer, jsonMap);
  }

  static Serializer<OrderDetail> get serializer => _$orderDetailSerializer;
}
