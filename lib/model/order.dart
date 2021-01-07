import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  String get id;

  @nullable
  String get userId;

  String get branchId;
  @nullable
  String get deviceId;
  @nullable
  String get currency;
  @nullable
  String get reference;
  @nullable
  String get orderDate;
  @nullable
  bool get isDraft;
  @nullable
  String get orderType;

  @nullable
  String get orderNUmber;

  @nullable
  String get supplierId;

  @nullable
  String get subTotal;

  @nullable
  String variantName;
  @nullable
  String get supplierInvoiceNumber;

  @nullable
  String get deliverDate;

  @nullable
  String get taxRate;

  @nullable
  double get quantity;

  @nullable
  String get taxAmount;

  @nullable
  String get discountRate;

  @nullable
  String get discountAmount;

  @nullable
  String get cashReceived;

  @nullable
  String get saleTotal;

  @nullable
  String get customerSaving;

  @nullable
  String get paymentId;

  @nullable
  String get orderNote;

  @nullable
  String get status;
  @nullable
  String get variationId;
  @nullable
  String get productName;

  BuiltList<String> get channels;

  @nullable
  String get customerChangeDue;
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
