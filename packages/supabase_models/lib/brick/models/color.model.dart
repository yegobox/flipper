import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'Colors'),
)
class PColor extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  late String? name;
  @Sqlite(ignore: true)
  List<String>? colors;
  int? branchId;
  bool active = false;

  DateTime? lastTouched;

  DateTime? deletedAt;
  PColor({
    required this.id,
    this.name,
    this.colors,
    this.branchId,
    required this.active,
    this.lastTouched,
    this.deletedAt,
  });
}
