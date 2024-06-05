import 'package:json_annotation/json_annotation.dart';

part 'UniversalProduct.g.dart';

@JsonSerializable()
class UniversalProduct {
  String? itemClsCd;
  String? itemClsNm;
  int? itemClsLvl;
  String? taxTyCd;
  String? mjrTgYn;
  String? useYn;

  int? businessId;
  int? branchId;
  UniversalProduct({
    required this.itemClsCd,
    required this.itemClsNm,
    required this.itemClsLvl,
    required this.mjrTgYn,
    required this.useYn,
  });

  factory UniversalProduct.fromJson(Map<String, dynamic> json) =>
      _$UniversalProductFromJson(json);
  Map<String, dynamic> toJson() => _$UniversalProductToJson(this);
}
