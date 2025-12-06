import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:flipper_services/proxy.dart';

final conversationProvider = StreamProvider.autoDispose<List<Conversation>>((
  ref,
) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    return Stream.value([]);
  }
  return ProxyService.strategy.conversationsStream(branchId: branchId);
});
