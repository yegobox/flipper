import 'package:supabase_models/brick/models/ai_conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:flipper_models/helperModels/talker.dart';
import 'ai_strategy.dart';

class AiStrategyImpl implements AiStrategy {
  final brick.Repository repository = brick.Repository();

  @override
  Future<List<AiConversation>> getConversations({
    required int branchId,
    int? limit,
    int? offset,
  }) async {
    try {
      final conversations = await repository.get<AiConversation>(
        query: brick.Query(
          where: [brick.Where('branchId').isExactly(branchId)],
          limit: limit ?? 20,
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      // Sort by lastMessageAt descending (newest first)
      conversations.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      return conversations;
    } catch (e, s) {
      talker.error('Error getting conversations: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<AiConversation> createConversation({
    required String title,
    required int branchId,
  }) async {
    try {
      final conversation = AiConversation(
        title: title,
        branchId: branchId,
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
      );

      return await repository.upsert<AiConversation>(conversation);
    } catch (e, s) {
      talker.error('Error creating conversation: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      // First get and delete all messages in the conversation
      final messages = await repository.get<Message>(
        query: brick.Query(
          where: [brick.Where('conversationId').isExactly(conversationId)],
        ),
      );

      for (final message in messages) {
        await repository.delete<Message>(message);
      }

      // Then delete the conversation
      final conversation = (await repository.get<AiConversation>(
        query: brick.Query(
          where: [brick.Where('id').isExactly(conversationId)],
        ),
      ))
          .firstOrNull;

      if (conversation != null) {
        await repository.delete<AiConversation>(conversation);
      }
    } catch (e, s) {
      talker.error('Error deleting conversation: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<List<Message>> getMessagesForConversation({
    required String conversationId,
    int? limit,
    int? offset,
  }) async {
    try {
      final messages = await repository.get<Message>(
        query: brick.Query(
          where: [brick.Where('conversationId').isExactly(conversationId)],
          limit: limit ?? 50,
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      // Sort by timestamp ascending (oldest first)
      messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      return messages;
    } catch (e, s) {
      talker.error('Error getting messages: $e\n$s');
      rethrow;
    }
  }

  @override
  Stream<List<Message>> subscribeToMessages(String conversationId) {
    try {
      return repository
          .subscribe<Message>(
        query: brick.Query(
          where: [brick.Where('conversationId').isExactly(conversationId)],
        ),
      )
          .map((messages) {
        // Sort by timestamp ascending (oldest first)
        messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
        return messages;
      });
    } catch (e, s) {
      talker.error('Error subscribing to messages: $e\n$s');
      rethrow;
    }
  }

  @override
  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  }) async {
    try {
      // First update the conversation's lastMessageAt
      final conversation = (await repository.get<AiConversation>(
        query: brick.Query(
          where: [brick.Where('id').isExactly(conversationId)],
        ),
      ))
          .firstOrNull;

      if (conversation != null) {
        conversation.lastMessageAt = DateTime.now();
        await repository.upsert<AiConversation>(conversation);
      }

      // Create and save the new message
      final message = Message(
        text: text,
        phoneNumber: phoneNumber,
        branchId: branchId,
        delivered: false,
        role: role,
        conversationId: conversationId,
        aiResponse: aiResponse,
        aiContext: aiContext,
        timestamp: DateTime.now(),
      );

      return await repository.upsert<Message>(message);
    } catch (e, s) {
      talker.error('Error saving message: $e\n$s');
      rethrow;
    }
  }
}
