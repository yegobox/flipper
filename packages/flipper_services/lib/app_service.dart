import 'package:stacked/stacked.dart';

import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/color.dart';
import 'package:flipper_models/models/unit.dart';
import 'proxy.dart';

class AppService with ReactiveServiceMixin {
  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;

  final _units = ReactiveValue<List<Unit>>([]);
  List<Unit> get units => _units.value;

  final _colors = ReactiveValue<List<PColor>>([]);
  List<PColor> get colors => _colors.value;

  final _currentColor = ReactiveValue<String>('#ee5253');
  String get currentColor => _currentColor.value;

  setCurrentColor({required String color}) {
    _currentColor.value = color;
  }

  void loadCategories() async {
    String? branchId = ProxyService.box.read(key: 'branchId');

    final List<Category> result =
        await ProxyService.api.categories(branchId: branchId!);

    _categories.value = result;
  }

  Future<void> loadUnits() async {
    String? branchId = ProxyService.box.read(key: 'branchId');
    final List<Unit> result = await ProxyService.api.units(branchId: branchId!);

    _units.value = result;
  }

  Future<void> loadColors() async {
    String? branchId = ProxyService.box.read(key: 'branchId');

    _colors.value = await ProxyService.api.colors(branchId: branchId!);

    for (PColor color in _colors.value) {
      if (color.active) {
        setCurrentColor(color: color.name);
      }
    }
  }

  AppService() {
    listenToReactiveValues([_categories, _units, _colors, _currentColor]);
  }
}
