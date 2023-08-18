import 'package:flipper_models/isar_models.dart';
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

  
  void navigateToAppCenter() {
    _dialogService.showCustomDialog(
      variant: DialogType.appCenter,
      title: 'Switch apps',
    );
  }
}
