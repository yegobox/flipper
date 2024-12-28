import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'configurations'),
)
class Configurations extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? taxType = "B";
  double? taxPercentage = 18.0;
  int? businessId;
  int? branchId;
  Configurations({
    String? id,
    this.taxType,
    this.taxPercentage,
    this.businessId,
    this.branchId,
  }) : id = id ?? const Uuid().v4();
}
