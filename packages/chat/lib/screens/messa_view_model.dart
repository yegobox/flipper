import 'package:flipper/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class MessageViewModel extends ReactiveViewModel {
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
}
