import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class MessageViewModel extends ReactiveViewModel {
  void messages() {
    ProxyService.api.messages();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
