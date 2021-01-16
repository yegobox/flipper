library flipper_services;

import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

/// A Calculator.
class KeyPadService with ReactiveServiceMixin {
  KeyPadService() {
    listenToReactiveValues([]);
  }
  final RxValue<double> _sum = RxValue<double>(initial: 0.0);
  double get product => _sum.value;
  void setSum({double product}) {
    _sum.value = product;
  }
}
