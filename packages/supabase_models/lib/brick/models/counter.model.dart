import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';

// part 'counter.model.g.dart';
part 'counter.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'counters'),
)
@DittoAdapter('counters')
class Counter extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;
  int? businessId;
  int? branchId;
  String? receiptType;
  int? totRcptNo;
  int? curRcptNo;
  int? invcNo;
  DateTime? lastTouched;
  DateTime? createdAt;
  String bhfId;
  Counter({
    String? id,
    required this.branchId,
    required this.curRcptNo,
    required this.totRcptNo,
    required this.invcNo,
    required this.businessId,
    required this.createdAt,
    required this.lastTouched,
    required this.receiptType,
    required this.bhfId,
  }) : id = id ?? const Uuid().v4();
}
