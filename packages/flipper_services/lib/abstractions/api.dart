import 'package:flipper_models/isar_models.dart';

abstract class Api<T> {
  Future<List<Business>> getOnlineBusiness({required String userId});
}
