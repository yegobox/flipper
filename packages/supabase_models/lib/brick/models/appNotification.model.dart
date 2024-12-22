import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branches'),
)
class AppNotification extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? type;
  String? message;
  int? identifier;
  bool? completed;

  AppNotification({
    required this.id,
    this.type,
    this.message,
    this.identifier,
    this.completed,
  });
}
