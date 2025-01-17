import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'countries'),
)
class Country extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  String name;
  int sortOrder;
  String description;
  String code;
  Country({
    String? id,
    required this.name,
    required this.sortOrder,
    required this.description,
    required this.code,
  }) : id = id ?? const Uuid().v4();
}
