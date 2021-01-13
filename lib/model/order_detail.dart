import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'order_detail.g.dart';

abstract class OrderDetail implements Built<OrderDetail, OrderDetailBuilder> {
  String get id;
  @nullable
  String get price;
  @nullable
  String get variantName;
  String get productName;
  @nullable
  String get canTrackStock;
  String get stockId;
  @nullable
  String get unit;
  @nullable
  String get sku;
  String get quantity;
  String get variantId;
  @nullable
  int get taxRate;
  @nullable
  double get taxAmount;
  @nullable
  double get discountRate;
  @nullable
  String get note;
  double get discountAmount;
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
