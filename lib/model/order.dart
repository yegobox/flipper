import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  String get id;
  int get userId;
  String get branchId;
  @nullable
  String get deviceId;
  @nullable
  String get currency;
  @nullable
  String get reference;
  @nullable
  String get idLocal;
  @nullable
  String get orderDate;
  @nullable
  bool get isDraft;
  @nullable
  String get orderType;

  int get orderNUmber;
  int get supplierId;
  int get subTotal;
  int get supplierInvoiceNumber;
  DateTime get deliverDate;
  int get taxRate;
  int get taxAmount;
  int get discountRate;
  int get discountAmount;
  int get cashReceived;
  int get saleTotal;
  int get customerSaving;
  int get paymentId;
  String get orderNote;
  String get status;
  int get customerChangeDue;
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
