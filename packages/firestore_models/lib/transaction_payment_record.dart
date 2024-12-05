import 'package:freezed_annotation/freezed_annotation.dart';
// Assuming you're using Realm's ObjectId
part 'transaction_payment_record.freezed.dart';
part 'transaction_payment_record.g.dart'; // Needed for JSON serialization

@freezed
class TransactionPaymentRecord with _$TransactionPaymentRecord {
  factory TransactionPaymentRecord({
    int? id,
    int? transactionId,
    @Default(0.0) double? amount,
    String? paymentMethod,
    DateTime? createdAt,
  }) = _TransactionPaymentRecord;

  // Optional: factory constructor for creating the object from JSON
  factory TransactionPaymentRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionPaymentRecordFromJson(json);
}
