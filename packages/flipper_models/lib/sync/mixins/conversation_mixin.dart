import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:supabase_models/brick/repository.dart';

mixin ConversationMixin implements ConversationInterface {
  Repository get repository;

  @override
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    final query = brick.Query(where: [
      brick.Where('conversationId').isExactly(conversationId),
      if (startDate != null)
        brick.Where('createdAt').isGreaterThanOrEqualTo(startDate),
      if (endDate != null)
        brick.Where('createdAt').isLessThanOrEqualTo(endDate),
    ]);

    return await repository.get<Message>(query: query);
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
    final message = Message(
        text: text,
        phoneNumber: phoneNumber,
        branchId: branchId,
        role: role,
        conversationId: conversationId,
        aiResponse: aiResponse,
        aiContext: aiContext,
        delivered: false);

    return await repository.upsert<Message>(message);
  }

  @override
  Stream<List<Message>> conversationStream({required String conversationId}) {
    return repository.subscribe<Message>(
      query: brick.Query(
        where: [brick.Where('conversationId').isExactly(conversationId)],
      ),
    );
  }
}
