import 'package:flipper_models/db_model_export.dart';

abstract class Api<T> {
  Future<List<Business>> getOnlineBusiness({required String userId});
}
