import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/mobile_upload.dart';

import 'abstractions/api.dart';

late Isar isar;

class ObjectBoxApi extends MobileUpload implements Api {
  @override
  Future<List<Business>> getOnlineBusiness({required String userId}) {
    // TODO: implement getOnlineBusiness
    throw UnimplementedError();
  }
}
