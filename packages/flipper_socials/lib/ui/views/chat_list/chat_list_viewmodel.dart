import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ChatListViewModel extends BaseViewModel {
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

  /// sending new message if conversationId is not given
  /// but if source is whatsapp
  Future<void> sendMessage(
      {required String message,
      required Conversation latestConversation}) async {
    final reply = Conversation(
      avatar: "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png",
      body: message,
      channelType: "whatsapp",
      fromNumber: latestConversation.fromNumber,
      toNumber: latestConversation.fromNumber,
      userName: "Yego",
      messageId: latestConversation.messageId,
      phoneNumberId: latestConversation.phoneNumberId,
      businessPhoneNumber: latestConversation.toNumber,
      messageType: "text",
      businessId: ProxyService.box.getBusinessId()!.toString(),
    );
    await ProxyService.isarApi.sendMessage(conversation: reply);
  }
}
