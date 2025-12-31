import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

part 'message.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'messages'),
)
@DittoAdapter(
  'messages',
  syncDirection: SyncDirection.bidirectional,
)
class Message extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String text;
  final String phoneNumber;
  final bool delivered;
  final String branchId;

  @Sqlite(nullable: true)
  final String? role; // 'user' or 'assistant'

  @Sqlite(nullable: true)
  final DateTime? timestamp;

  @Sqlite(nullable: true, index: true)
  final String? conversationId; // References Conversation.id

  @Sqlite(nullable: true)
  final String? aiResponse;

  @Sqlite(nullable: true)
  final String? aiContext;

  @Sqlite(nullable: true)
  final String? messageType; // Type of message (text, image, audio, etc.)

  @Sqlite(nullable: true)
  final String? messageSource; // Source of message ('ai', 'whatsapp')

  @Sqlite(nullable: true)
  final String? whatsappMessageId; // WhatsApp message ID

  @Sqlite(nullable: true)
  final String? whatsappPhoneNumberId; // WhatsApp phone number ID

  @Sqlite(nullable: true)
  final String? contactName; // Contact name for WhatsApp messages

  @Sqlite(nullable: true)
  final String? waId; // WhatsApp ID of the sender

  @Sqlite(nullable: true)
  final String? replyToMessageId; // ID of message being replied to

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
    this.messageType,
    this.messageSource = 'ai',
    this.whatsappMessageId,
    this.whatsappPhoneNumberId,
    this.contactName,
    this.waId,
    this.replyToMessageId,
  }) : id = id ?? const Uuid().v4();

  // Helper method to get the first line or truncated text for conversation title
  String getPreview() {
    final firstLine = text.split('\n').first;
    return firstLine.length > 50
        ? '${firstLine.substring(0, 47)}...'
        : firstLine;
  }
}
