import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';

class MessageViewModel extends BusinessHomeViewModel {
  final log = getLogger('MessageViewModel');
  void messages() {
    ProxyService.api.messages();
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
}
