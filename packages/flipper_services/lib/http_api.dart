import 'package:injectable/injectable.dart';

import 'abstractions/api.dart';

@lazySingleton
class HttpApi implements Api {
  @override
  void cleanKeyPad() {
    // TODO: implement cleanKeyPad
  }

  @override
  void listenCategory() {
    // TODO: implement listenCategory
  }

  @override
  void listenColor() {
    // TODO: implement listenColor
  }

  @override
  void listenOrder() {
    // TODO: implement listenOrder
  }

  @override
  Future payroll() {
    // TODO: implement payroll
    throw UnimplementedError();
  }
}
