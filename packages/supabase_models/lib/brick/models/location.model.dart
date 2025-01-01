import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'locations'),
)
class Location extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  int? serverId;

  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;
  String? location;

  bool isDefault = false;

  DateTime? lastTouched;

  DateTime? deletedAt;
  bool? isOnline = false;
  Location({
    String? id,
    this.serverId,
    this.active,
    this.description,
    this.name,
    this.businessId,
    this.longitude,
    this.latitude,
    this.location,
    this.isDefault = false,
    this.lastTouched,
    this.deletedAt,
    this.isOnline = false,
  }) : id = id ?? const Uuid().v4();
}
