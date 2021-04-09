library flipper_models;

import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:stacked/stacked.dart';

class HomeAppBarViewModel extends ReactiveViewModel {
  final keyPad = locator<KeyPadService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [keyPad];
}
