import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaConversationMixin implements ConversationInterface {
  Repository get repository;
  Talker get talker;

  // TODO(ditto-migration): port `getConversationHistory` to Ditto.
  @override
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    return ProxyService.legacyStrategy.getConversationHistory(conversationId: conversationId, startDate: startDate, endDate: endDate, limit: limit, offset: offset);
  }

  // TODO(ditto-migration): port `saveMessage` to Ditto.
  @override
  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required String branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
    required String messageSource,
  }) async {
    return ProxyService.legacyStrategy.saveMessage(text: text, phoneNumber: phoneNumber, branchId: branchId, role: role, conversationId: conversationId, aiResponse: aiResponse, aiContext: aiContext, messageSource: messageSource);
  }

  // TODO(ditto-migration): port `conversationStream` to Ditto.
  @override
  Stream<List<Message>> conversationStream({required String conversationId}) {
    return ProxyService.legacyStrategy.conversationStream(conversationId: conversationId);
  }
}
