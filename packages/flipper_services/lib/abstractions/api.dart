import 'package:flipper_models/isar_models.dart';

abstract class Api<T> {
  Future<List<IBusiness>> getOnlineBusiness({required String userId});
}
