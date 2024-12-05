import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'locations'),
)
class Location extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

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
    required this.id,
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
  });
}
