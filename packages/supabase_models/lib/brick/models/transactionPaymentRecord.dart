import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class TransactionPaymentRecord extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? transactionId;
  double? amount = 0.0;
  String? paymentMethod;
  DateTime? createdAt;
  TransactionPaymentRecord({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
  });
}
