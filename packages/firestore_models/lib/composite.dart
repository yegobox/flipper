import 'package:freezed_annotation/freezed_annotation.dart';

part 'composite.freezed.dart';
part 'composite.g.dart';

@freezed
class Composite with _$Composite {
  const factory Composite({
    int? id,
    int? productId,
    int? variantId,
    double? qty,
    int? branchId,
    int? businessId,
    double? actualPrice,
  }) = _Composite;

  factory Composite.fromJson(Map<String, dynamic> json) =>
      _$CompositeFromJson(json);
}
