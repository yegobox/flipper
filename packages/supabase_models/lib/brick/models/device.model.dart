import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'devices'),
)
class Device extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? linkingCode;
  String? deviceName;
  String? deviceVersion;
  bool? pubNubPublished;
  String? phone;
  int? branchId;
  int? businessId;
  int? userId;
  String? defaultApp;

  /// for sync

  DateTime? lastTouched;
  DateTime? deletedAt;

  Device({
    String? id,
    this.linkingCode,
    this.deviceName,
    this.deviceVersion,
    this.pubNubPublished,
    this.phone,
    this.branchId,
    this.businessId,
    this.userId,
    this.defaultApp,
    this.lastTouched,
    this.deletedAt,
 }) : id = id ?? const Uuid().v4();
}
