import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'logs'),
)
class Log extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? message;
  String? type;
  int? businessId;
  DateTime? createdAt;
  Log({
    String? id,
    this.message,
    this.type,
    this.businessId,
    this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
