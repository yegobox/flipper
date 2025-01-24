import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'business_analytics'),
)
class BusinessAnalytic extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final DateTime date;
  final num value;
  final String type;
  int? branchId;
  int? businessId;

  BusinessAnalytic(
      {String? id,
      required this.date,
      required this.value,
      required this.businessId,
      this.branchId,
      required this.type})
      : id = id ?? const Uuid().v4();
}
