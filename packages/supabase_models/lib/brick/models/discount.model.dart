import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Discount extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  final String? name;
  double? amount;
  int? branchId;

  Discount({
    required this.id,
    this.name,
    this.amount,
    this.branchId,
  });
}
