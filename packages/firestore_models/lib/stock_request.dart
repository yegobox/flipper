import 'package:freezed_annotation/freezed_annotation.dart';

// Import the TransactionItem class
import 'transaction_item.dart';

part 'stock_request.freezed.dart';
part 'stock_request.g.dart';

@freezed
class StockRequest with _$StockRequest {
  const factory StockRequest({
    int? id,
    int? mainBranchId,
    int? subBranchId,
    DateTime? createdAt,
    // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
    String? status,
    DateTime? deliveryDate,
    String? deliveryNote,
    String? orderNote,
    @Default(false) bool? customerReceivedOrder,
    @Default(false) bool? driverRequestDeliveryConfirmation,
    int? driverId,
    @Default([]) List<TransactionItem> items,
    DateTime? updatedAt,
  }) = _StockRequest;

  factory StockRequest.fromJson(Map<String, dynamic> json) =>
      _$StockRequestFromJson(json);
}
