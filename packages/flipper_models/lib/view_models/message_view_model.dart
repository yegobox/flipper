import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_chat/json/chat_json.dart';
class MessageViewModel extends BusinessHomeViewModel {
  //save chat_data in a list
  List<String> chat_data = [];

  final log = getLogger('MessageViewModel');
  void messages() {
    ProxyService.api.messages();
  }

  void onNewOrder() {
    // chat_data.add(chat_data);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];

  void delete(int id) {
    log.i(id);
    ProxyService.api.delete(id: id, endPoint: 'message');
  }

  void sendMessage({required int receiverId, required String message}) {
    ProxyService.api.sendMessage(receiverId: receiverId, message: message);
  }

  void receiveOrder({required int chatId}) {}
}
