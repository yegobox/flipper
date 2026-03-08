import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/brick/repository.dart';

part 'integration_config.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'integration_configs'),
)
@DittoAdapter(
  'integration_configs',
  syncDirection: SyncDirection.bidirectional,
)
class IntegrationConfig extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  @Sqlite(index: true)
  final String businessId;

  @Sqlite(index: true)
  final String provider; // e.g., 'umusada'

  final String? token;
  final String? refreshToken;
  final DateTime? expiresAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Stores additional configuration as JSON string
  @Supabase(
    fromGenerator: '''
      data['config'] == null
        ? null
        : data['config'] is String
            ? data['config'] as String
            : jsonEncode(data['config'])
    ''',
  )
  final String? config;

  IntegrationConfig({
    String? id,
    required this.businessId,
    required this.provider,
    this.token,
    this.refreshToken,
    this.expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.config,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  IntegrationConfig copyWith({
    String? id,
    String? businessId,
    String? provider,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? config,
  }) {
    return IntegrationConfig(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      provider: provider ?? this.provider,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      config: config ?? this.config,
    );
  }
}
