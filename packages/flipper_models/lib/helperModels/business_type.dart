import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'business_type.g.dart';

@JsonSerializable()
class BusinessType with EquatableMixin {
  final String id;
  final String typeName;

  BusinessType({required this.id, required this.typeName});
  factory BusinessType.fromJson(Map<String, dynamic> json) =>
      _$BusinessTypeFromJson(json);
  static List<BusinessType> fromJsonList(String str) => List<BusinessType>.from(
    json.decode(str).map((x) => BusinessType.fromJson(x)),
  );

  Map<String, dynamic> toJson() => _$BusinessTypeToJson(this);

  @override
  List<Object?> get props => [id, typeName];

  @override
  bool? get stringify => true;
}

/// Enum for business types
enum BusinessTypeEnum {
  BUSINESS('1', 'Flipper Retailer'),
  INDIVIDUAL('2', 'Individual'),
  ENTERPRISE('3', 'Enterprise'),
  SALON('4', 'Salon'),
  MANUFACTURING('5', 'Manufacturing'),
  TRANSPORT('6', 'Transport'),
  RESTAURANT('7', 'Restaurant'),
  HOTEL('8', 'Hotel'),
  SCHOOL('9', 'School'),
  SERVICE('10', 'Service'),
  OTHER('11', 'Other');

  const BusinessTypeEnum(this.id, this.typeName);
  final String id;
  final String typeName;

  static BusinessTypeEnum fromId(String id) {
    return BusinessTypeEnum.values.firstWhere(
      (type) => type.id == id,
      orElse: () => BusinessTypeEnum.BUSINESS,
    );
  }
}
