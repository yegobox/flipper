import 'package:flipper/locator.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'base_model.dart';

class OpenBusinessModel extends BaseModel {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final FlipperNavigationService _flipperNavigationService =
      locator<FlipperNavigationService>();

  final Logger log = Logging.getLogger('Database service  Model ....');

  Future<void> openBusiness(
      {double float,
      String note,
      String documentId,
      String businessState,
      CommonViewModel vm}) async {
    setBusy(true);

    await _databaseService.saveDrawerHistory(
      float: float,
      businessId: vm.currentBusiness.id,
      businessState: businessState,
      userId: vm.userId.toString(),
      note: note,
    );
    await _databaseService.openCloseBusiness(
      businessId: vm.currentBusiness.id,
      userId: vm.userId.toString(),
      isSocial: false,
      name: vm.user.name,
      isClosed: false,
    );

    _flipperNavigationService.navigateTo(Routing.dashboard);

    setBusy(false);
  }
}
