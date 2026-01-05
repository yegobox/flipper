import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

part 'ebm.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'ebms'),
)
@DittoAdapter(
  'ebms',
  syncDirection: SyncDirection.bidirectional,
)
class Ebm extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  @Supabase(name: "bhf_id")
  final String bhfId;
  @Supabase(name: "tin_number")
  final int tinNumber;
  @Supabase(name: "dvc_srl_no")
  final String dvcSrlNo;
  @Supabase(name: "user_id")
  final String? userId;
  @Supabase(name: "tax_server_url")
  String taxServerUrl;
  final String businessId;
  @Supabase(name: "branch_id")
  final String branchId;
  @Supabase(name: "vat_enabled")
  bool? vatEnabled;
  @Supabase(name: "mrc")
  String mrc;

  Ebm({
    String? id,
    required this.bhfId,
    required this.tinNumber,
    required this.dvcSrlNo,
    this.userId,
    required this.taxServerUrl,
    required this.businessId,
    required this.branchId,
    this.vatEnabled = false,
    required this.mrc,
  }) : id = id ?? const Uuid().v4();
}
