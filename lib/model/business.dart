import "package:built_value/built_value.dart";

part 'business.g.dart';

abstract class Business implements Built<Business, BusinessBuilder> {
  String get id;

  String get name;

  bool get active;

  String get currency;

  String get categoryId;

  @nullable
  double get latitude;
  @nullable
  double get longitude;
  @nullable
  String get userId;

  String get typeId;

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
