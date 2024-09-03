import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_models/realm_model_export.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// there is a case we need to force some data to be added for a given user
/// this is the class to help with that.

class ForceDataEntryService {
  final appService = getIt<AppService>();

  Future<void> dataBootstrapper() async {
    /// because here we are bootstraping data, to avoid re-adding them in db yet they exist
    /// for the case where user switch the laptop and the database would be empty yet on our cloud we do have some data
    /// hence we sync first.
    try {
      await ProxyService.realm.realm!.subscriptions.waitForSynchronization();
    } catch (e) {}
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
    List<PColor> kColors = await ProxyService.realm.colors(branchId: branchid);
    if (kColors.isEmpty) {
      final PColor color = PColor(ObjectId(),
          id: randomNumber(),
          colors: colors,
          branchId: branchId,
          lastTouched: DateTime.now(),
          action: AppActions.created,
          name: "#d63031",
          active: false);
      await ProxyService.realm.create<PColor>(data: color);
    }

    /// bootstrap app permission for admin
    List<Access> permissions =
        ProxyService.realm.access(userId: ProxyService.box.getUserId()!);
    if (permissions.isEmpty) {
      int? branchId = ProxyService.box.getBranchId();
      int? businessId = ProxyService.box.getBusinessId();
      int userId = ProxyService.box.getUserId()!;

      ProxyService.realm.realm!.write(() {
        for (var feature in features) {
          /// because having ticket is considered to be elevated permission you can't have both tickets and sales
          /// so ticket endup having elevated permission which means it show only on the screen
          addAccess(feature, userId, businessId!, branchId!);
        }
      });
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

    List<IUnit> kUnits = await ProxyService.realm.units(branchId: branchid);

    if (kUnits.isEmpty) {
      try {
        await ProxyService.realm.addUnits(units: mockUnits);
      } catch (e) {
        talker.critical(e);
      }
    }

    /// bootstrap tax if not bootstraped
    for (String item in ["A", "B", "C", "D"]) {
      ProxyService.realm.getByTaxType(taxtype: item);
    }
  }

  void addAccess(String feature, int userId, int businessId, int branchId) {
    final accessConfig = {
      AppFeature.Tickets: (AccessLevel.WRITE, 'inactive'),
      AppFeature.Settings: (AccessLevel.ADMIN, 'active'),
    };

    final (accessLevel, status) =
        accessConfig[feature] ?? (AccessLevel.WRITE, 'active');

    ProxyService.realm.realm!.add<Access>(
      Access(
        ObjectId(),
        id: randomNumber(),
        featureName: feature,
        userId: userId,
        businessId: businessId,
        branchId: branchId,
        accessLevel: accessLevel,
        status: status,
        userType: AccessLevel.ADMIN,
        createdAt: DateTime.now(),
      ),
    );
  }

  final talker = TalkerFlutter.init();

  createCategory({required String name, required int branchId}) {
    talker.info('App is started');
    Category? category;
    category = ProxyService.realm.realm!
        .query<Category>(r'name ==$0', [name]).firstOrNull;
    if (category == null) {
      try {
        ProxyService.realm.realm!.put<Category>(Category(
          ObjectId(),
          id: randomNumber(),
          focused: false,
          name: name,
          active: false,
          branchId: branchId,
          lastTouched: DateTime.now(),
          action: AppActions.created,
        ));
      } catch (e) {
        talker.critical(e);
      }
    }
  }
}
