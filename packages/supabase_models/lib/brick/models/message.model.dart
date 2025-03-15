import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'messages'),
)
class Message extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String text;
  final String phoneNumber;
  final bool delivered;
  final int branchId;

  @Sqlite(nullable: true)
  final String? role; // 'user' or 'assistant'

  @Sqlite(nullable: true)
  final DateTime? timestamp;

  @Sqlite(nullable: true, index: true)
  final String? conversationId; // References AiConversation.id

  @Sqlite(nullable: true)
  final String? aiResponse;

  @Sqlite(nullable: true)
  final String? aiContext;

  Message({
    String? id,
    required this.text,
    required this.phoneNumber,
    required this.delivered,
    required this.branchId,
    this.role,
    this.timestamp,
    this.conversationId,
    this.aiResponse,
    this.aiContext,
  }) : id = id ?? const Uuid().v4();

  // Helper method to get the first line or truncated text for conversation title
  String getPreview() {
    final firstLine = text.split('\n').first;
    return firstLine.length > 50
        ? '${firstLine.substring(0, 47)}...'
        : firstLine;
  }
}
