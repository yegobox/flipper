import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'conversations'),
)
class Conversation extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String title;
  final int branchId;

  @Sqlite(nullable: true)
  final DateTime? createdAt;

  @Supabase(ignore: true)
  @OfflineFirst(where: {'conversationId': 'id'})
  List<Message>? messages;

  DateTime lastMessageAt;

  Conversation({
    String? id,
    required this.title,
    required this.branchId,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    this.messages,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc(),
        lastMessageAt = lastMessageAt ?? DateTime.now();
}
