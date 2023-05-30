import 'package:stacked/stacked.dart';

class Service with ListenableServiceMixin {
  String ilog() {
    return "we got it";
  }
}
