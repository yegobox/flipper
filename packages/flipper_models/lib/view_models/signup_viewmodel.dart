library flipper_models;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/mocks.dart';
import 'package:flipper_routing/routes.locator.dart';
// import 'package:flipper_models/models/mocks.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';

import 'gate.dart';

final isWindows = UniversalPlatform.isWindows;

class SignupViewModel extends FormViewModel {
  final appService = locator<AppService>();
  String? businessType = 'Business';
  final log = getLogger('SignupViewModel');

  bool registerStart = false;

  void setBuinessType({required String type}) {
    businessType = type;
    notifyListeners();
  }

  String? longitude = '1';
  String? latitude = '1';

  String? kName;
  void setName({String? name}) {
    kName = name;
  }

  String? kFullName;
  void setFullName({String? name}) {
    kFullName = name;
  }

  String? kCountry;
  void setCountry({String? country}) {
    kCountry = country;
  }

  var _tin = "";
  String get tin => _tin;
  set tin(String value) {
    _tin = value;
    notifyListeners();
  }

  void registerLocation() async {
    final permission = await ProxyService.location.doWeHaveLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];
      notifyListeners();
    }
  }

  BuildContext? context;
  Future<void> signup() async {
    registerStart = true;
    notifyListeners();
    //set the startup app.
    if (ProxyService.remoteConfig.isChatAvailable()) {
      ProxyService.box.write(key: pageKey, value: businessType);
    }
    String? referralCode = ProxyService.box.read(key: 'referralCode');
    log.i(tin);

    List<JTenant> jTenants = await ProxyService.isarApi.signup(business: {
      'name': kName,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': ProxyService.box.getUserPhone(),
      'currency': 'RW',
      'createdAt': DateTime.now().toIso8601String(),
      'userId': ProxyService.box.getUserId(),
      "tinNumber": int.parse(tin),
      // 'type': businessType,
      'type': 'Business',
      'referredBy': referralCode ?? 'Organic',
      'fullName': kFullName,
      'country': kCountry
    });
    if (jTenants.isNotEmpty) {
      /// create tenants.
      final String userId = ProxyService.box.getUserId()!;
      Business? business = await ProxyService.isarApi
          .getBusinessById(id: jTenants.first.businesses.first.id!);

      List<Branch> branches =
          await ProxyService.isarApi.branches(businessId: business!.id!);
      ProxyService.box.write(key: 'branchId', value: branches[0].id!);

      appService.appInit();
      final Category category = Category()
        ..active = true
        ..focused = true
        ..name = 'NONE'
        ..branchId = branches[0].id!;
      await ProxyService.isarApi
          .create<Category>(data: category, endPoint: 'category');
      //get default colors for this branch
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

      final PColor color = PColor()
        ..id = DateTime.now().millisecondsSinceEpoch
        ..colors = colors
        ..table = AppTables.color
        ..channels = [userId]
        ..active = false
        ..branchId = branches[0].id
        ..name = 'sample';

      await ProxyService.isarApi.create<PColor>(data: color, endPoint: 'color');
      //now create default units for this branch
      final units = IUnit()
        ..name = 'Per Kilogram (kg)'
        ..value = 'kg'
        ..active = false
        ..id = DateTime.now().millisecondsSinceEpoch
        ..units = mockUnits
        ..branchId = branches[0].id!;
      await ProxyService.isarApi.addUnits(data: units);

      //now create a default custom product
      ProxyService.forceDateEntry.caller();
      ProxyService.whatsApp.optIn();

      loginInfo.isLoggedIn = true;
      loginInfo.redirecting = false;
      loginInfo.needSignUp = false;
    }
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
