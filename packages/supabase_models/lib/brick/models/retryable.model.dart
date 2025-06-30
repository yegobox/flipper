// import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'retryables'),
)
class Retryable extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  String entityId;
  String entityTable;
  String lastFailureReason;
  int retryCount;
  DateTime createdAt;

  Retryable({
    String? id,
    required this.entityId,
    required this.entityTable,
    required this.lastFailureReason,
    required this.retryCount,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
