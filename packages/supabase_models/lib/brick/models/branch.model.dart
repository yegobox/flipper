import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Branch extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  final String? name;
  final int? serverId;
  final String? location;
  final String? description;
  final bool? active;
  final int? businessId;
  final String? latitude;
  final String? longitude;
  bool? isDefault;
  bool? isOnline;

  Branch({
    required this.id,
    this.name,
    this.serverId,
    this.location,
    this.description,
    this.active,
    this.businessId,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.isOnline = false,
  });
}
