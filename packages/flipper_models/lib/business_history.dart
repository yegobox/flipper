// ignore: library_names
library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

// import 'serializers.dart';

part 'business_history.g.dart';

abstract class BusinessHistory
    implements Built<BusinessHistory, BusinessHistoryBuilder> {
  BusinessHistory._();

  // ignore: sort_unnamed_constructors_first
  factory BusinessHistory([updates(BusinessHistoryBuilder b)]) =
      _$BusinessHistory;

  String get id;

  @nullable
  String get cashierName;
  @nullable
  bool get openingHour;

  @nullable
  bool get isSocial;
  @nullable
  String get table;

  @nullable
  double get openingFloat;

  @nullable
  double get closingFloat;

  @nullable
  String get displayText;

  @nullable
  String get businessId;
  @nullable
  String get userId;

  @nullable
  String get createdAt;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(BusinessHistory.serializer, this);
  }

  BusinessHistory fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static BusinessHistory fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(
        BusinessHistory.serializer, jsonMap);
  }

  static Serializer<BusinessHistory> get serializer =>
      _$businessHistorySerializer;
}
