import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig:
      SupabaseSerializable(tableName: 'branch_payment_integrations'),
)
class BranchPaymentIntegration extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final String branchId;
  bool isEnabled;
  BranchPaymentIntegration(
      {String? id, required this.branchId, required this.isEnabled})
      : id = id ?? const Uuid().v4();
}
