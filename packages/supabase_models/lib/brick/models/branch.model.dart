import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
part 'branch.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branches'),
)
@DittoAdapter(
  'branches',
  syncDirection: SyncDirection.bidirectional,
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
  String? businessId;
  String? latitude;
  String? longitude;
  bool? isDefault;
  bool? isOnline;
  String? tinNumber;
  DateTime? deletedAt;
  DateTime? updatedAt;

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
    this.tinNumber,
    this.isDefault = false,
    this.isOnline = false,
    this.deletedAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();
  // copyWith method
  Branch copyWith({
    String? id,
    String? name,
    int? serverId,
    String? location,
    String? description,
    bool? active,
    String? businessId,
    String? latitude,
    String? longitude,
    bool? isDefault,
    bool? isOnline,
    String? tinNumber,
    DateTime? deletedAt,
    DateTime? updatedAt,
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
        tinNumber: tinNumber ?? this.tinNumber,
        deletedAt: deletedAt ?? this.deletedAt,
        updatedAt: updatedAt ?? this.updatedAt);
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
      'tinNumber': tinNumber,
      'deletedAt': deletedAt,
      'updatedAt': updatedAt
    };
  }
}
