import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_models/db_model_export.dart';

import 'package:talker_flutter/talker_flutter.dart';

/// there is a case we need to force some data to be added for a given user
/// this is the class to help with that.

class ForceDataEntryService {
  final appService = getIt<AppService>();

  Future<void> dataBootstrapper() async {
    /// because here we are bootstraping data, to avoid re-adding them in db yet they exist
    /// for the case where user switch the laptop and the database would be empty yet on our cloud we do have some data
    /// hence we sync first.

    int? branchId = ProxyService.box.getBranchId();
    int? businessId = ProxyService.box.getBusinessId();

    if (branchId == null || businessId == null) {
      return;
    }

    final List<String> colors = [
      '#d63031',
      '#0984e3',
      '#e84393',
      '#2d3436',
      '#6c5ce7',
      '#74b9ff',
      '#ff7675',
      '#a29bfe'
    ];

    int branchid = ProxyService.box.getBranchId()!;
    List<PColor> kColors =
        await ProxyService.strategy.colors(branchId: branchid);
    if (kColors.isEmpty) {
      for (String colorName in colors) {
        await ProxyService.strategy
            .addColor(name: colorName, branchId: branchId);
      }
    }

    /// bootstrap app permission for admin
    List<Access> permissions = await ProxyService.strategy
        .access(userId: ProxyService.box.getUserId() ?? 0);
    if (permissions.isEmpty) {
      int? branchId = ProxyService.box.getBranchId();
      int? businessId = ProxyService.box.getBusinessId();
      int userId = ProxyService.box.getUserId() ?? 0;

      /// it is empty but we might have them on cloud so check on cloud
      final doesBusinessHavePermission = await ProxyService.realmHttp
          .hasAcessSaved(
              flipperHttpClient: ProxyService.http, businessId: businessId!);
      String? ybPermission = ProxyService.box.yegoboxLoggedInUserPermission();
      if (!doesBusinessHavePermission && ybPermission == 'admin') {
        for (var feature in features) {
          /// because having ticket is considered to be elevated permission you can't have both tickets and sales
          /// so ticket endup having elevated permission which means it show only on the screen
          addAccess(feature, userId, businessId, branchId!);
        }
      }
    }

    /// Add default categories to be used, these category can't be deleted as they are helper to identify
    /// type of transaction and categorization of transaction
    /// e.g salaries, airtime and we shall add more as we learn what users needs
    /// airtime,salary,transport,
    for (String name in [
      TransactionType.airtime,
      TransactionType.transport,
      TransactionType.salary
    ]) {
      createCategory(name: name, branchId: branchid);
    }

    ProxyService.strategy.addUnits(units: mockUnits);

    /// bootstrap tax if not bootstraped
    for (String item in ["A", "B", "C", "D"]) {
      ProxyService.strategy.getByTaxType(taxtype: item);
    }
  }

  Future<void> addAccess(
      String feature, int userId, int businessId, int branchId) async {
    final accessConfig = {
      AppFeature.Tickets: (AccessLevel.WRITE, 'inactive'),
      AppFeature.Settings: (AccessLevel.ADMIN, 'active'),
    };

    final (accessLevel, status) =
        accessConfig[feature] ?? (AccessLevel.WRITE, 'active');

    await ProxyService.strategy.addAccess(
      branchId: branchId,
      businessId: businessId,
      userId: userId,
      featureName: feature,
      accessLevel: accessLevel,
      status: status,
      userType: AccessLevel.ADMIN,
      createdAt: DateTime.now(),
    );
  }

  final talker = TalkerFlutter.init();

  createCategory({required String name, required int branchId}) async {
    List<Category> category =
        await ProxyService.strategy.categories(branchId: branchId);
    if (category.map((e) => e.name).contains(name)) {
      return;
    }
    ProxyService.strategy.addCategory(
      name: name,
      branchId: branchId,
      active: false,
      focused: false,
      lastTouched: DateTime.now(),
      createdAt: DateTime.now(),
      deletedAt: null,
    );
  }
}
