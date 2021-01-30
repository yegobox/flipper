import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

import 'package:flipper_models/fcontact.dart';

class ContactService with ReactiveServiceMixin {
  final RxValue<List<FContact>> _contacts =
      RxValue<List<FContact>>(initial: []);
  List<FContact> get contacts => _contacts.value;

  void setContacts({List<FContact> contacts}) {
    _contacts.value = contacts;
  }
}
