import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_ditto/ditto_sync_adapter.dart';
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
  syncDirection: SyncDirection.sendOnly,
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
  String? taxServerUrl;
  final String businessId;
  @Supabase(name: "branch_id")
  final String branchId;

  /// Whether the branch is registered with RRA for VAT. Picks the tax codes
  /// (A/B/C when true, D when not) and the VAT bookkeeping. It is not the EBM
  /// switch: see [isEbmOn].
  @Supabase(name: "vat_enabled")
  bool? vatEnabled;

  /// Supabase `ebm_enabled`: the branch fiscalises through RRA EBM. `null`
  /// means "follow [vatEnabled]", which is how every branch behaved before
  /// RRA taxpayers on EBM without VAT registration were supported.
  ///
  /// Mapped by hand in the EBM mixins (Ditto `ebmEnabled`). Brick ignores it,
  /// so the generated adapters and the SQLite schema are unchanged.
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  bool? ebmEnabled;

  /// Sales, refunds and stock movements go to RRA. True with [vatEnabled]
  /// false is an EBM taxpayer that is not VAT-registered: RRA accepts only
  /// tax code D from it.
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  bool get isEbmOn => ebmEnabled ?? (vatEnabled == true);

  /// Whether this branch is registered with RRA for tourism tax.
  ///
  /// RRA rejects `ttCatCd` on `items/saveItems` with 603 for taxpayers that are
  /// not TT-registered, even though `TT` is a valid code and the item is a
  /// service. Rooms on such a branch register as plain services; tourism tax is
  /// still declared per sale line in `trnsSales/saveSales`.
  @Supabase(name: "tourism_tax_enabled")
  bool? tourismTaxEnabled;
  @Supabase(name: "mrc")
  String mrc;
  @Supabase(name: "remote_server_url")
  final String? remoteServerUrl;
  @Supabase(name: "data_connector_url")
  String? dataConnectorUrl;

  Ebm({
    String? id,
    required this.bhfId,
    required this.tinNumber,
    required this.dvcSrlNo,
    this.userId,
    this.taxServerUrl,
    required this.businessId,
    required this.branchId,
    this.vatEnabled = false,
    this.tourismTaxEnabled = false,
    this.ebmEnabled,
    required this.mrc,
    this.remoteServerUrl,
    this.dataConnectorUrl,
  }) : id = id ?? const Uuid().v4();
}
