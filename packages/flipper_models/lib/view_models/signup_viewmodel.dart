import 'dart:ui';

import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/branch.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/color.dart';
// import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/product_mock.dart';
import 'package:flipper_models/models/unit.dart';
import 'package:flipper_models/models/unit_mock.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/constants.dart';

final isWindows = UniversalPlatform.isWindows;

class SignupViewModel extends FormViewModel {
  String? businessType = 'business';

  void setBuinessType({required String type}) {
    businessType = type;
    notifyListeners();
  }

  late String? longitude;
  late String? latitude;

  String? _name;
  void setName({required String name}) {
    _name = name;
  }

  String? _country;
  void setCountry({required String country}) {
    _country = country;
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

  void signup({Locale? locale}) async {
    int okStatus = await ProxyService.api.signup(business: {
      'name': _name,
      'latitude': latitude,
      'longitude': longitude,
      'currency': 'RW',
      'userId': ProxyService.box.read(key: 'userId'),
      'type': businessType,
      // ignore: todo
      //TODO: right now I am not sure locale!.countryCode can be reliable as sometime it need to test it on real-device
      'country': 'RW'
    });
    if (okStatus == 200) {
      //get businesses's id then look for related branch [0] create the default category
      List<Business> businesses = await ProxyService.api.businesses();
      ProxyService.box.write(key: 'businessId', value: businesses[0].id);
      ProxyService.appService.setBusiness(businesses: businesses);
      List<Branch> branches =
          await ProxyService.api.branches(businessId: businesses[0].id);
      final String? userId = ProxyService.box.read(key: 'userId');
      final categoryId = Uuid().v1();
      final Category category = new Category(
        id: categoryId,
        active: true,
        table: AppTables.category,
        focused: true,
        name: 'NONE',
        channels: [userId!],
        branchId: branches[0].id,
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

      ProxyService.box.write(key: 'branchId', value: branches[0].id);

      final colorId = Uuid().v1();
      final PColor color = new PColor(
        id: colorId,
        colors: colors,
        table: AppTables.color,
        channels: [userId],
        active: false,
        branchId: branches[0].id,
        name: 'sample',
      );
      await ProxyService.api
          .create<PColor>(data: color.toJson(), endPoint: 'color');
      //now create default units for this branch
      final unitId = Uuid().v1();
      final units = new Unit(
        name: 'sample',
        active: false,
        id: unitId,
        table: AppTables.unit,
        units: mockUnits,
        branchId: branches[0].id,
        channels: [userId],
      );
      await ProxyService.api.addUnits(data: units.toJson());

      //now create a default custom product
      await ProxyService.api.createProduct(product: customProductMock);

      ProxyService.nav.navigateTo(Routes.home);
    }
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
