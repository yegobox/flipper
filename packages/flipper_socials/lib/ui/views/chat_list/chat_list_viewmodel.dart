import 'package:stacked/stacked.dart';

class ChatListViewModel extends BaseViewModel {
  bool _focusedConversation = false;
  bool get focusedConversation => _focusedConversation;
  set focusedConversation(bool v) {
    _focusedConversation = true;
    notifyListeners();
  }
}
