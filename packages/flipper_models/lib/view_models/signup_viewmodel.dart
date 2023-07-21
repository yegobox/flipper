library flipper_models;

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/mocks.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gate.dart';

class SignupViewModel extends ReactiveViewModel {
  final appService = loc.locator<AppService>();
  final _routerService = locator<RouterService>();
  bool registerStart = false;

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

  String? _tin;
  String? get tin => _tin;
  set tin(String? value) {
    _tin = value;
    notifyListeners();
  }

  var _businessType = null;
  BusinessType get businessType => _businessType;
  set businessType(BusinessType value) {
    _businessType = value;
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
    try {
      registerStart = true;
      notifyListeners();
      //set the startup app.
      ProxyService.box.write(key: defaultApp, value: businessType.id);

      String? referralCode = ProxyService.box.read(key: 'referralCode');

      List<JTenant> jTenants = await ProxyService.isar.signup(business: {
        'name': kName,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': ProxyService.box.getUserPhone(),
        'currency': 'RW',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': ProxyService.box.getUserId(),
        "tinNumber": tin != null ? int.parse(tin!) : 1111,
        'businessTypeId': businessType.id,
        'type': 'Business',
        'referredBy': referralCode ?? 'Organic',
        'fullName': kFullName,
        'country': kCountry
      });
      if (jTenants.isNotEmpty) {
        /// we have socials as choosen app then register on social
        if (businessType.id == 2) {
          // it is customer support then register on socials as well
          await ProxyService.isar.registerOnSocial(
              password: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
              phoneNumberOrEmail:
                  ProxyService.box.getUserPhone()!.replaceAll("+", ""));
        }
        Business? business = await ProxyService.isar
            .getBusinessById(id: jTenants.first.businesses.first.id!);

        List<Branch> branches =
            await ProxyService.isar.branches(businessId: business!.id!);
        ProxyService.box.write(key: 'branchId', value: branches[0].id!);

        appService.appInit();
        final Category category = Category(
            active: true,
            focused: true,
            name: "NONE",
            branchId: branches[0].id!);
        await ProxyService.isar.create<Category>(data: category);
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

        final PColor color = PColor(
            id: syncIdInt(),
            colors: colors,
            active: false,
            branchId: branches[0].id,
            name: 'sample');

        await ProxyService.isar.create<PColor>(data: color);
        //now create default units for this branch
        final units = IUnit()
          ..name = 'Per Kilogram (kg)'
          ..value = 'kg'
          ..active = false
          ..id = DateTime.now().millisecondsSinceEpoch
          ..units = mockUnits
          ..branchId = branches[0].id!;
        await ProxyService.isar.addUnits(data: units);

        //now create a default custom product
        ProxyService.forceDateEntry.dataBootstrapper();
        // TODO: need to figureout the purchase of credit later.
        // ProxyService.whatsApp.optIn();

        LoginInfo().isLoggedIn = true;
        LoginInfo().redirecting = false;
        LoginInfo().needSignUp = false;
        _routerService.navigateTo(StartUpViewRoute(invokeLogin: true));
      }
    } catch (e) {
      registerStart = false;
      notifyListeners();
      rethrow;
    }
  }
}
