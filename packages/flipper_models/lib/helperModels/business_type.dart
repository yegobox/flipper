import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'business_type.g.dart';

@JsonSerializable()
class BusinessType with EquatableMixin {
  final String id;
  final String typeName;

  BusinessType({
    required this.id,
    required this.typeName,
  });
  factory BusinessType.fromJson(Map<String, dynamic> json) =>
      _$BusinessTypeFromJson(json);
  static List<BusinessType> fromJsonList(String str) => List<BusinessType>.from(
      json.decode(str).map((x) => BusinessType.fromJson(x)));

  Map<String, dynamic> toJson() => _$BusinessTypeToJson(this);

  @override
  List<Object?> get props => [id, typeName];

  @override
  bool? get stringify => true;
}
