import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branches'),
)
class Branch extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? name;
  int? serverId;
  String? location;
  String? description;
  bool? active;
  int? businessId;
  String? latitude;
  String? longitude;
  bool? isDefault;
  bool? isOnline;

  Branch({
    String? id,
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
  }) : id = id ?? const Uuid().v4();
  // copyWith method
  Branch copyWith({
    String? id,
    String? name,
    int? serverId,
    String? location,
    String? description,
    bool? active,
    int? businessId,
    String? latitude,
    String? longitude,
    bool? isDefault,
    bool? isOnline,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      location: location ?? this.location,
      description: description ?? this.description,
      active: active ?? this.active,
      businessId: businessId ?? this.businessId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toFlipperJson() {
    return {
      'id': id,
      'name': name,
      'serverId': serverId,
      'location': location,
      'description': description,
      'active': active,
      'businessId': businessId,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'isOnline': isOnline,
    };
  }
}
