import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'reports'),
)
class Report extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? branchId;
  int? businessId;
  String? filename;
  String? s3Url;
  bool? downloaded = false;

  Report({
    required this.id,
    this.branchId,
    this.businessId,
    this.filename,
    this.s3Url,
    this.downloaded,
  });
}
