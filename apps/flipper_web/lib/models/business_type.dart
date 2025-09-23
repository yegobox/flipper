import 'dart:convert';

class BusinessType {
  final String id;
  final String typeName;

  BusinessType({required this.id, required this.typeName});

  factory BusinessType.fromJson(Map<String, dynamic> json) => BusinessType(
    id: json['id'] as String,
    typeName: json['typeName'] as String,
  );

  static List<BusinessType> fromJsonList(String str) => List<BusinessType>.from(
    json.decode(str).map((x) => BusinessType.fromJson(x)),
  );

  Map<String, dynamic> toJson() => {'id': id, 'typeName': typeName};

  @override
  String toString() => 'BusinessType(id: $id, typeName: $typeName)';
}
