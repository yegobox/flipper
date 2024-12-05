import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'accesses'),
)
class Access extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? branchId;
  int? businessId;
  int? userId;
  String? featureName;
  String? userType;
  String? accessLevel;
  DateTime? createdAt;
  DateTime? expiresAt;
  String? status;
  Access({
    required this.id,
    this.branchId,
    this.businessId,
    this.userId,
    this.featureName,
    this.userType,
    this.accessLevel,
    this.createdAt,
    this.expiresAt,
    this.status,
  });
}
