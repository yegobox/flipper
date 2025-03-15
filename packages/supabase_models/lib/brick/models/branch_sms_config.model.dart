import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branch_sms_configs'),
)
class BranchSmsConfig extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final int branchId;
  String? smsPhoneNumber;
  bool enableOrderNotification;

  BranchSmsConfig({
    String? id,
    required this.branchId,
    this.smsPhoneNumber,
    this.enableOrderNotification = false,
  }) : id = id ?? const Uuid().v4();
}
