import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'counters'),
)
class Counter extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  // @Supabase(foreignKey: 'branch_id')
  // final Branch branch;

  final int? businessId;
  final int? branchId;
  final String? receiptType;
  final int? totRcptNo;
  final int? curRcptNo;
  int? invcNo;
  final DateTime? lastTouched;
  final DateTime? createdAt;

  // If the association will be created by the app, specify
  // a field that maps directly to the foreign key column
  // so that Brick can notify Supabase of the association.
  // @Sqlite(ignore: true)
  // int get branchId => branch.id;

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
  }) : id = id ?? const Uuid().v4();
}
