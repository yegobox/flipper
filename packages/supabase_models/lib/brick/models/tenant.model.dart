import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'tenants'),
)
class Tenant extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? name;
  String? phoneNumber;
  String? email;
  bool nfcEnabled = false;
  int? businessId;
  int? userId;
  String? imageUrl;

  DateTime? lastTouched;
  DateTime? deletedAt;

  int? pin;

  /// [sessionActive] is not comming from server, this is to check which
  /// tenant is currently have active session but the main session will be still active
  bool? sessionActive;

  bool? isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality

  bool isLongPressed = false;
  String type = "Agent";
  Tenant({
    String? id,
    this.name,
    this.phoneNumber,
    this.email,
    this.nfcEnabled = false,
    this.businessId,
    this.userId,
    this.imageUrl,
    this.lastTouched,
    this.deletedAt,
    this.pin,
    this.sessionActive,
    this.isDefault,
    this.isLongPressed = false,
    this.type = "Agent",
  }) : id = id ?? const Uuid().v4();
}
