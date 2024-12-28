import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class TransactionPaymentRecord extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  int? transactionId;
  double? amount = 0.0;
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
