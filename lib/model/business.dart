import "package:built_value/built_value.dart";

part 'business.g.dart';

abstract class Business implements Built<Business, BusinessBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;

  @nullable
  bool get active;

  @nullable
  double get latitude;
  @nullable
  double get longitude;
  @nullable
  String get userId;
  @nullable
  int get businessTypeId;
  @nullable
  int get taxRate;
  @nullable
  String get timeZone;
  @nullable
  String get createdAt;
  @nullable
  String get updatedAt;
  @nullable
  String get country;
  @nullable
  String get businessUrl;

  @nullable
  String get hexColor;

  @nullable
  String get image;
  @nullable
  BusinessType get type;

  Business._();

  factory Business([void Function(BusinessBuilder) updates]) = _$Business;
}

enum BusinessType { PHARMACY, NORMAL }
