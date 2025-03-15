import 'package:supabase_models/brick/models/ai_conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';

abstract class AiStrategy {
  // Conversation methods
  Future<List<AiConversation>> getConversations({
    required int branchId,
    int? limit,
    int? offset,
  });

  Future<AiConversation> createConversation({
    required String title,
    required int branchId,
  });

  Future<void> deleteConversation(String conversationId);

  // Message methods
  Future<List<Message>> getMessagesForConversation({
    required String conversationId,
    int? limit,
    int? offset,
  });

  Stream<List<Message>> subscribeToMessages(String conversationId);

  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  });
}
