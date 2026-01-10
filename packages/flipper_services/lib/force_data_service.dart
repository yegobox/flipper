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

    String? branchId = ProxyService.box.getBranchId();
    String? businessId = ProxyService.box.getBusinessId();

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

    List<PColor> kColors =
        await ProxyService.strategy.colors(branchId: branchId);
    if (kColors.isEmpty) {
      for (String colorName in colors) {
        await ProxyService.strategy
            .addColor(name: colorName, branchId: branchId);
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
      createCategory(name: name, branchId: branchId);
    }

    ProxyService.strategy.addUnits(units: mockUnits);

    /// bootstrap tax if not bootstraped
    for (String item in ["A", "B", "C", "D"]) {
      ProxyService.strategy.getByTaxType(taxtype: item);
    }
  }

  Future<void> addAccess(
      String feature, String userId, String businessId, String branchId) async {
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
      createdAt: DateTime.now().toUtc(),
    );
  }

  final talker = TalkerFlutter.init();

  createCategory({required String name, required String branchId}) async {
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
      lastTouched: DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
      deletedAt: null,
    );
  }
}
