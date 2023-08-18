import 'package:flipper_actionable/service.dart';
import 'package:injectable/injectable.dart';

import 'api.dart';
import 'storage.dart';

@module
abstract class Module {
  @LazySingleton()
  Storage box() {
    return StorageImpl();
  }

  @preResolve
  @LazySingleton()
  Future<AB> api() async {
    return Api();
  }

  Service get service;
}
