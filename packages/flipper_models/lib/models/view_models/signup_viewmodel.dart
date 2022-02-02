library flipper_models;

import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/models/models.dart';

import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:go_router/go_router.dart';

final isWindows = UniversalPlatform.isWindows;

class SignupViewModel extends FormViewModel {
  String? businessType = 'social';
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

  String? _type;
  void setType({required String type}) {
    _type = type;
  }

  void registerLocation() async {
    final permission = await ProxyService.location.doWeHaveLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocation();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocation();
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
    //if name containts space replace them with _
    // final String? name = kName?.replaceAll(' ', '_');

    int okStatus = await ProxyService.api.signup(business: {
      'name': kName,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': ProxyService.box.read(key: 'userPhone'),
      'currency': 'RW',
      'createdAt': DateTime.now().toIso8601String(),
      'userId': ProxyService.box.read(key: 'userId'),
      'type': businessType,
      'referredBy': referralCode ?? 'Organic',
      'fullName': kFullName,
      'country': kCountry
    });
    if (okStatus == 200) {
      final String userId = ProxyService.box.getUserId()!;
      //get businesses's id then look for related branch [0] create the default category
      List<BusinessSync> businesses =
          await ProxyService.api.getOnlineBusiness(userId: userId);
      if (businesses.isEmpty) return;
      ProxyService.box.write(key: 'businessId', value: businesses[0].id);
      ProxyService.appService.setBusiness(businesses: businesses);
      // if (ProxyService.remoteConfig.isSubmitDeviceTokenEnabled()) {
      // String? token = await FirebaseMessaging.instance.getToken();
      // ProxyService.firestore
      //     .saveTokenToDatabase(token: token!, business: businesses[0].toJson());
      // // }
      List<BranchSync> branches =
          await ProxyService.api.branches(businessId: businesses[0].id);

      ProxyService.box.write(key: 'branchId', value: branches[0].id);

      final Category category = Category(
        active: true,
        table: AppTables.category,
        focused: true,
        name: 'NONE',
        channels: [userId],
        fbranchId: branches[0].id,
      );
      await ProxyService.api
          .create<Category>(data: category.toJson(), endPoint: 'category');
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
        id: DateTime.now().millisecondsSinceEpoch,
        colors: colors,
        table: AppTables.color,
        channels: [userId],
        active: false,
        fbranchId: branches[0].id,
        name: 'sample',
      );

      await ProxyService.api
          .create<PColor>(data: color.toJson(), endPoint: 'color');
      //now create default units for this branch
      final units = Unit(
        name: 'sample',
        value: 'kg',
        active: false,
        id: DateTime.now().millisecondsSinceEpoch,
        table: AppTables.unit,
        units: mockUnits,
        fbranchId: branches[0].id,
        channels: [userId],
      );
      await ProxyService.api.addUnits(data: units.toJson());

      //now create a default custom product
      await ProxyService.api.createProduct(product: customProductMock);

      // ProxyService.nav.navigateTo(Routes.home);
      GoRouter.of(context!).go(Routes.home);
    }
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
