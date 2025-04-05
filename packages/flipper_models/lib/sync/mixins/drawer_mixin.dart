import 'package:flipper_models/sync/interfaces/drawer_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/proxy.dart';

mixin DrawerMixin implements DrawerInterface {
  Repository get repository;

  @override
  Future<Drawers?> closeDrawer({
    required Drawers drawer,
    required double eod,
  }) async {
    drawer.open = false;
    drawer.cashierId = ProxyService.box.getUserId()!;
    drawer.closingBalance = eod;
    drawer.closingDateTime = DateTime.now();
    return await repository.upsert(drawer);
  }
}
