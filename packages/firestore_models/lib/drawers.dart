import 'package:freezed_annotation/freezed_annotation.dart';

part 'drawers.freezed.dart';
part 'drawers.g.dart';

@freezed
class Drawers with _$Drawers {
  const factory Drawers({
    int? id,
    double? openingBalance,
    double? closingBalance,
    String? openingDateTime,
    String? closingDateTime,
    int? csSaleCount,
    String? tradeName,
    double? totalNsSaleIncome,
    double? totalCsSaleIncome,
    int? nrSaleCount,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? incompleteSale,
    int? otherTransactions,
    String? paymentMode,
    int? cashierId,
    bool? open,
    DateTime? deletedAt,
    int? businessId,
    int? branchId,
  }) = _Drawers;

  factory Drawers.fromJson(Map<String, dynamic> json) =>
      _$DrawersFromJson(json);
}
