import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'reports'),
)
class Report extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  int? branchId;
  int? businessId;
  String? filename;
  String? s3Url;
  bool? downloaded = false;

  Report({
    String? id,
    this.branchId,
    this.businessId,
    this.filename,
    this.s3Url,
    this.downloaded,
  }) : id = id ?? const Uuid().v4();
}
