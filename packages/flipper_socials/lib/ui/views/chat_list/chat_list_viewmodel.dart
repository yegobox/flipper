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
  Future<void> sendMessage({required String message, String? messageId}) async {
    // Conversation(

    // );
  }
}
