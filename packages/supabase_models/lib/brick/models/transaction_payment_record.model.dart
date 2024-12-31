import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig:
      SupabaseSerializable(tableName: 'transaction_payment_records'),
)
class TransactionPaymentRecord extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? transactionId;
  @Sqlite(defaultValue: "0.0")
  @Supabase(defaultValue: "0.0")
  double? amount;
  String? paymentMethod;
  DateTime? createdAt;
  TransactionPaymentRecord({
    String? id,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
