import 'package:flipper_models/RealmApi.dart';

class RealmApiMocked extends RealmAPI {
  @override
  Future<String> dbPath({required String path, int? folder}) async {
    return Future.value("null");
  }
}
