import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'import_purchase_dates'),
)
class ImportPurchaseDates extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String? lastRequestDate;
  final String? branchId;
  final String? requestType;

  ImportPurchaseDates(
      {String? id,
      required this.lastRequestDate,
      required this.branchId,
      required this.requestType})
      : id = id ?? const Uuid().v4();
}
