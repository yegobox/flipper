library flipper_services;

import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

class KeyPadService with ReactiveServiceMixin {
  KeyPadService() {
    listenToReactiveValues([]);
  }

  final RxValue<double> customAmount = RxValue<double>(initial: 0.0);
  double get getSum => customAmount.value;
  void setSum({double sumation}) {
    customAmount.value = 0.0;
    customAmount.value = sumation;
  }
}
