import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'ebms'),
)
class Ebm extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  int? id;
  @Supabase(name: "bhf_id")
  final String bhfId;
  @Supabase(name: "tin_number")
  final int tinNumber;
  @Supabase(name: "dvc_srl_no")
  final String dvcSrlNo;
  @Supabase(name: "user_id")
  final int userId;
  @Supabase(name: "tax_server_url")
  String taxServerUrl;
  final int businessId;
  @Supabase(name: "branch_id")
  final int branchId;
  @Supabase(name: "last_touched")
  DateTime? lastTouched;

  Ebm({
    required this.id,
    required this.bhfId,
    required this.tinNumber,
    required this.dvcSrlNo,
    required this.userId,
    required this.taxServerUrl,
    required this.businessId,
    required this.branchId,
    this.lastTouched,
  });
}
