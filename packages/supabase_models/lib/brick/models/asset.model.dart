import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
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

part 'asset.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'assets'),
)
@DittoAdapter(
  'assets',
  syncDirection: SyncDirection.sendOnly,
)
class Assets extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? branchId;
  String? businessId;
  String? assetName;
  String? productId;

  /// When set, this asset belongs to a specific variant (e.g. variant thumbnail).
  @Supabase(name: 'variant_id')
  @Sqlite(name: 'variant_id')
  String? variantId;

  /// Tracks whether the asset has been uploaded to the cloud storage
  /// If false, the asset exists only locally and needs to be synced when online
  bool isUploaded;

  /// Local file path for offline storage
  String? localPath;

  /// Sub-path for storage organization (e.g., 'branch', 'reports')
  String? subPath;

  Assets({
    String? id,
    this.branchId,
    this.businessId,
    this.assetName,
    this.productId,
    this.variantId,
    this.isUploaded = false,
    this.localPath,
    this.subPath,
  }) : id = id ?? const Uuid().v4();
}
