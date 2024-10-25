import 'package:freezed_annotation/freezed_annotation.dart';

part 'universal_product.freezed.dart';
part 'universal_product.g.dart';

@freezed
class UniversalProduct with _$UniversalProduct {
  const factory UniversalProduct({
    int? id,
    String? itemClsCd,
    String? itemClsNm,
    int? itemClsLvl,
    String? taxTyCd,
    String? mjrTgYn,
    String? useYn,
    int? businessId,
    int? branchId,
  }) = _UniversalProduct;

  factory UniversalProduct.fromJson(Map<String, dynamic> json) =>
      _$UniversalProductFromJson(json);
}
