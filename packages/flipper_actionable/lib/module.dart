import 'package:flipper_actionable/service.dart';
import 'package:injectable/injectable.dart';

import 'api.dart';

@module
abstract class Module {
  @LazySingleton()
  @preResolve
  @LazySingleton()
  Future<AB> api() async {
    return Api();
  }

  Service get service;
}
