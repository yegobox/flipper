import 'package:freezed_annotation/freezed_annotation.dart';

part 'sku.freezed.dart';
part 'sku.g.dart';

@freezed
class SKU with _$SKU {
  const factory SKU({
    int? id,
    int? sku,
    int? branchId,
    int? businessId,
    bool? consumed,
  }) = _SKU;

  factory SKU.fromJson(Map<String, dynamic> json) => _$SKUFromJson(json);
}
