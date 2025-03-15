import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'ai_conversations'),
)
class AiConversation extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String title; // First message or summary of conversation
  final int branchId;
  final DateTime createdAt;
  DateTime lastMessageAt;

  AiConversation({
    String? id,
    required this.title,
    required this.branchId,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        lastMessageAt = lastMessageAt ?? DateTime.now();
}
