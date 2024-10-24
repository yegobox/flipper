import 'package:freezed_annotation/freezed_annotation.dart';

part 'flipper_sale_compaign.freezed.dart';
part 'flipper_sale_compaign.g.dart'; // Needed for JSON serialization

@freezed
class FlipperSaleCompaign with _$FlipperSaleCompaign {
  factory FlipperSaleCompaign({
    int? id,
    int? compaignId,
    int? discountRate,
    DateTime? createdAt,
    String? couponCode,
  }) = _FlipperSaleCompaign;

  // Optional: factory constructor for creating the object from JSON
  factory FlipperSaleCompaign.fromJson(Map<String, dynamic> json) =>
      _$FlipperSaleCompaignFromJson(json);
}
