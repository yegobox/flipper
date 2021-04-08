library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'customer.g.dart';

abstract class Customer implements Built<Customer, CustomerBuilder> {
  String get id;
  @nullable
  String get name;
  @nullable
  String get email;

  double get totalPoints;

  int get totalVisit;

  String get firstVisit;

  double get totalSpent;
  String get phoneNumber;
  @nullable
  String get address;
  @nullable
  String get city;
  @nullable
  String get region;
  @nullable
  String get postalCode;
  @nullable
  String get countryCode;
  @nullable
  String get customerCode;
  @nullable
  String get note;
  String get createdAt;
  @nullable
  String get updatedAt;
  BuiltList<String> get channels;
  // ignore: sort_constructors_first
  Customer._();
  factory Customer([void Function(CustomerBuilder) updates]) = _$Customer;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Customer.serializer, this);
  }

  Customer fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Customer fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Customer.serializer, jsonMap);
  }

  static Serializer<Customer> get serializer => _$customerSerializer;
}
