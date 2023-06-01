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

      /// always from number is the user phone number i.e the business phone number
      /// this number need to be enabled on whatsapp business to use whatsapp api
      fromNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),

      /// the phone number of a user who sent the message to the business, this is the number
      /// and this does not have to be registered on flipper but check to see if this from is not us
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
    ProxyService.isar.create(data: reply);
  }

  void navigateToAppCenter() {
    _dialogService.showCustomDialog(
      variant: DialogType.appCenter,
      title: 'Switch apps',
    );
  }
}
