import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';

class ContactViewModel extends ReactiveViewModel {
  final contacts = ProxyService.contacts;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [contacts];
}
