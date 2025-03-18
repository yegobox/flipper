import 'package:flipper_models/realm_model_export.dart';

abstract class ConversationInterface {
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  });

  Stream<List<Message>> conversationStream({required String conversationId});
}
