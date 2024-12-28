import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branches'),
)
class AppNotification extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? type;
  String? message;
  int? identifier;
  bool? completed;

  AppNotification({
    String? id,
    this.type,
    this.message,
    this.identifier,
    this.completed,
  }) : id = id ?? const Uuid().v4();
}
