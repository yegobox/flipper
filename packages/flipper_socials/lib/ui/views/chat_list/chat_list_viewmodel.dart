import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatListViewModel extends StartupViewModel {
  bool _focusedConversation = false;
  final _dialogService = locator<DialogService>();
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
      delivered: false,
      createdAt: DateTime.now().toString(),
      // now add 5 seconds to the current time
      scheduledAt: DateTime.now().add(const Duration(seconds: 5)),
      businessPhoneNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
      messageType: "text",
      businessId: ProxyService.box.getBusinessId()!.toString(),
    );
    ProxyService.isarApi.create(data: reply);
  }

  void navigateToAppCenter() {
    _dialogService.showCustomDialog(
      variant: DialogType.appCenter,
      title: 'Switch apps',
    );
  }
}
