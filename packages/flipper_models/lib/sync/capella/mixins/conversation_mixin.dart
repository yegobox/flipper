import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaConversationMixin implements ConversationInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    throw UnimplementedError(
        'getConversationHistory needs to be implemented for Capella');
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
    throw UnimplementedError('saveMessage needs to be implemented for Capella');
  }

  @override
  Stream<List<Message>> conversationStream({required String conversationId}) {
    throw UnimplementedError(
        'conversationStream needs to be implemented for Capella');
  }
}
