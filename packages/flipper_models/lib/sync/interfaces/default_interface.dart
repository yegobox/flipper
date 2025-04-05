import 'package:flipper_models/db_model_export.dart';

abstract class DefaultInterface {
  Future<Branch?> defaultBranch();
  Future<Business?> defaultBusiness();
}
