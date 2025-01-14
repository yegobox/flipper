import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'customer_payments'),
)
class CustomerPayments extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  String? customerId;
  final String phoneNumber;
  final String paymentStatus;
  final String transactionId;
   double amountPayable;
  CustomerPayments(
      {String? id,
      this.customerId,
      required this.phoneNumber,
      required this.paymentStatus,
      required this.amountPayable,
      required this.transactionId})
      : id = id ?? const Uuid().v4();
}
