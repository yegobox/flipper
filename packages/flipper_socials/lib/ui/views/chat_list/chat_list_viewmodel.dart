import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

class ChatListViewModel extends StartupViewModel {
  bool _focusedConversation = false;

  bool get focusedConversation => _focusedConversation;

  String? _conversationId;
  String? get conversationId => _conversationId;
  set conversationId(String? conversationId) {
    _conversationId = conversationId;
    notifyListeners();
  }

  set focusedConversation(bool v) {
    _focusedConversation = true;
    notifyListeners();
  }

  Future<void> sendMessage(
      {required String message,
      required Conversation latestConversation}) async {
    final reply = Conversation(
      avatar: "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png",
      body: message,
      channelType: "whatsapp",
      fromNumber: latestConversation.toNumber,
      toNumber: latestConversation.fromNumber,
      userName: "Yego",
      messageId: latestConversation.messageId,
      conversationId: latestConversation.conversationId,
      phoneNumberId: latestConversation.phoneNumberId,
      businessPhoneNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
      messageType: "text",
      businessId: ProxyService.box.getBusinessId()!.toString(),
    );
    await ProxyService.isarApi.sendMessage(conversation: reply);
  }
}
