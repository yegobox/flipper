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
  syncDirection: SyncDirection.sendOnly,
)
class Branch extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? name;
  int? serverId;
  String? location;
  String? description;
  String? businessId;
  num? latitude;
  num? longitude;
  bool? isDefault;
  bool? isOnline;
  bool? active;
  DateTime? deletedAt;
  DateTime? updatedAt;

  Branch({
    String? id,
    this.name,
    this.serverId,
    this.location,
    this.description,
    this.businessId,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.isOnline = false,
    this.active = false,
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
    num? latitude,
    num? longitude,
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
        businessId: businessId ?? this.businessId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isDefault: isDefault ?? this.isDefault,
        isOnline: isOnline ?? this.isOnline,
        active: active ?? this.active,
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
      'businessId': businessId,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'isOnline': isOnline,
      'active': active,
      'deletedAt': deletedAt,
      'updatedAt': updatedAt
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    // Ditto documents are loosely typed: coordinates and ids can arrive as
    // strings, so every scalar is coerced instead of downcast.
    String? parseString(dynamic v) {
      if (v == null) return null;
      final s = v.toString();
      return s.isEmpty ? null : s;
    }

    num? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      return num.tryParse(v.toString());
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? num.tryParse(v.toString())?.toInt();
    }

    bool parseBool(dynamic v, {bool orElse = false}) {
      if (v == null) return orElse;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final s = v.toString().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
      return orElse;
    }

    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return Branch(
      // Leave a missing id null so the constructor mints a fresh UUID; ''
      // would be a shared, non-unique id across every id-less map.
      id: (map['id'] ?? map['_id'])?.toString(),
      name: parseString(map['name']),
      serverId: parseInt(map['serverId'] ?? map['server_id']),
      location: parseString(map['location']),
      description: parseString(map['description']),
      businessId: parseString(map['businessId'] ?? map['business_id']),
      latitude: parseNum(map['latitude']),
      longitude: parseNum(map['longitude']),
      isDefault: parseBool(map['isDefault'] ?? map['is_default']),
      isOnline: parseBool(map['isOnline'] ?? map['is_online']),
      active: parseBool(map['active']),
      deletedAt: parseDt(map['deletedAt'] ?? map['deleted_at']),
      updatedAt: parseDt(map['updatedAt'] ?? map['updated_at']),
    );
  }
}
