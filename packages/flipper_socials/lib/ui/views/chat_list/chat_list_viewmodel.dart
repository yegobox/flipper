import 'package:stacked/stacked.dart';

class ChatListViewModel extends BaseViewModel {
  bool _focusedConversation = false;
  bool get focusedConversation => _focusedConversation;

  int? _conversationId;
  int? get conversationId => _conversationId;
  set conversationId(int? conversationId) {
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
      {required String message, int? conversationId}) async {
    // Conversation(

    // );
  }
}
