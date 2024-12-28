import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'colors'),
)
class PColor extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  late String? name;
  @Sqlite(ignore: true)
  List<String>? colors;
  int? branchId;
  bool active = false;

  DateTime? lastTouched;

  DateTime? deletedAt;
  PColor({
    String? id,
    this.name,
    this.colors,
    this.branchId,
    required this.active,
    this.lastTouched,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();
}
