import 'package:flipper_models/db_model_export.dart';

abstract class DrawerInterface {
  Future<Drawers?> closeDrawer({required Drawers drawer, required double eod});
}
