import 'package:stacked/stacked.dart';

import 'package:flipper_models/models/models.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'proxy.dart';

// Testing
// import 'package:flutter_gen/gen_l10n/flipper_localizations.dart';
class AppService with ReactiveServiceMixin {
  // required constants
  String? get userid => ProxyService.box.read(key: 'userId');
  int? get businessId => ProxyService.box.read(key: 'businessId');
  int? get branchId => ProxyService.box.read(key: 'branchId');

  final log = getLogger('AppService');

  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;

  final _businesses = ReactiveValue<List<BusinessSync>>([]);
  List<BusinessSync> get businesses => _businesses.value;

  final _units = ReactiveValue<List<Unit>>([]);
  List<Unit> get units => _units.value;

  final _colors = ReactiveValue<List<PColor>>([]);
  List<PColor> get colors => _colors.value;

  final _currentColor = ReactiveValue<String>('#ee5253');
  String get currentColor => _currentColor.value;

  setCurrentColor({required String color}) {
    _currentColor.value = color;
  }

  setBusiness({required List<BusinessSync> businesses}) {
    _businesses.value = businesses;
  }

  void loadCategories() async {
    int? branchId = ProxyService.box.read(key: 'branchId');

    final List<Category> result =
        await ProxyService.api.categories(branchId: branchId!);

    _categories.value = result;
    notifyListeners();
  }

  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.read(key: 'branchId');
    final List<Unit> result = await ProxyService.api.units(branchId: branchId!);

    _units.value = result;
  }

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.read(key: 'branchId');

    List<PColor> result = await ProxyService.api.colors(branchId: branchId!);
    _colors.value = result;

    for (PColor color in _colors.value) {
      if (color.active) {
        print(color.name);
        setCurrentColor(color: color.name!);
      }
    }
  }

  bool _loggedIn = false;
  bool get hasLoggedInUser => _loggedIn;

  bool isLoggedIn() {
    _loggedIn = ProxyService.box.read(key: 'userId') == null ? false : true;
    notifyListeners();
    return _loggedIn;
  }

  final _contacts = ReactiveValue<List<BusinessSync>>([]);
  List<BusinessSync> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    Stream<List<BusinessSync>> contacts =
        ProxyService.api.contacts().asBroadcastStream();
    contacts.listen((event) {
      _contacts.value = event;
    });
  }

  AppService() {
    listenToReactiveValues(
        [_categories, _units, _colors, _currentColor, _businesses, _contacts]);
  }
}
