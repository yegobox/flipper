import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'configurations'),
)
class Configurations extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? taxType = "B";
  double? taxPercentage = 18.0;
  int? businessId;
  int? branchId;
  Configurations({
    required this.id,
    this.taxType,
    this.taxPercentage,
    this.businessId,
    this.branchId,
  });
}
