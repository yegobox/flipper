import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'accesses'),
)
class Access extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? branchId;
  String? businessId;
  String? userId;
  String? tenantId;
  String? featureName;
  String? userType;
  String? accessLevel;
  DateTime? createdAt;
  DateTime? expiresAt;
  String? status;
  Access({
    String? id,
    this.branchId,
    this.businessId,
    this.userId,
    this.tenantId,
    this.featureName,
    this.userType,
    this.accessLevel,
    this.createdAt,
    this.expiresAt,
    this.status,
  }) : id = id ?? const Uuid().v4();
}
