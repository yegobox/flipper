import 'package:flipper/home/open_close_drawerview.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'base_model.dart';

class OpenBusinessModel extends BaseModel {
  final DatabaseService _databaseService = ProxyService.database;
  final FlipperNavigationService _flipperNavigationService = ProxyService.nav;

  final Logger log = Logging.getLogger('Open Business model....');

  Future<void> openBusiness(
      {double float,
      String note,
      String documentId,
      BusinessState businessState,
      CommonViewModel vm}) async {
    setBusy(true);

    await _databaseService.saveDrawerHistory(
      float: float,
      businessId: vm.currentBusiness.id,
      businessState: businessState,
      userId: vm.user.id.toString(),
      note: note,
    );
    await _databaseService.openCloseBusiness(
      businessId: vm.currentBusiness.id,
      userId: vm.user.id.toString(),
      isSocial: false,
      name: vm.user.name,
      isClosed: false,
    );

    _flipperNavigationService.navigateTo(Routing.dashboard);

    setBusy(false);
  }
}
