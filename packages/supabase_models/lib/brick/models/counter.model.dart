import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Counter extends OfflineFirstWithSupabaseModel {
  /// Read more about `@Sqlite`: https://github.com/GetDutchie/brick/tree/main/packages/brick_sqlite#fields
  @Supabase(unique: true, name: "id")
  @Sqlite(unique: true)
  final int id;

  // @Supabase(foreignKey: 'branch_id')
  // final Branch branch;

  final int? businessId;
  final int? branchId;
  final String? receiptType;
  final int? totRcptNo;
  final int? curRcptNo;
  final int? invcNo;
  final DateTime? lastTouched;
  final DateTime? createdAt;

  // If the association will be created by the app, specify
  // a field that maps directly to the foreign key column
  // so that Brick can notify Supabase of the association.
  // @Sqlite(ignore: true)
  // int get branchId => branch.id;

  Counter(
      {required this.id,
      // required this.branch,
      required this.branchId,
      required this.curRcptNo,
      required this.totRcptNo,
      required this.invcNo,
      required this.businessId,
      required this.createdAt,
      required this.lastTouched,
      required this.receiptType});
}
