import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart' as routing_locator;
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as services_locator;
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';

class _MockAppService extends Mock implements AppService {}

class _MockProductService extends Mock implements ProductService {}

class _MockKeyPadService extends Mock implements KeyPadService {}

class _MockSettingsService extends Mock implements SettingsService {}

class _MockLanguage extends Mock implements Language {}

class _MockRouterService extends Mock implements RouterService {}

/// A service (`itemTyCd == "3"`) carries no stock: the product editor must not
/// let a quantity in, whichever way it is typed.
void main() {
  late ScannViewModel model;
  late Variant variant;

  setUp(() async {
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();
    services_locator.getIt
      ..registerSingleton<AppService>(_MockAppService())
      ..registerSingleton<ProductService>(_MockProductService())
      ..registerSingleton<KeyPadService>(_MockKeyPadService())
      ..registerSingleton<SettingsService>(_MockSettingsService())
      ..registerSingleton<Language>(_MockLanguage());
    routing_locator.locator.registerSingleton<RouterService>(
      _MockRouterService(),
    );
    model = ScannViewModel();
    variant = Variant(name: 'Haircut', branchId: 'b1', itemTyCd: '2', qty: 5);
    variant.stock = Stock(
      branchId: 'b1',
      currentStock: 5,
      rsdQty: 5,
      value: 50,
    );
    variant.stockId = variant.stock!.id;
    model.scannedVariants = [variant];
  });

  tearDown(() async {
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();
  });

  test('switching to Service clears stock already typed in', () {
    model.setProductType('3');

    expect(variant.itemTyCd, '3');
    expect(variant.qty, 0);
    expect(variant.rsdQty, 0);
    expect(variant.stock!.currentStock, 0);
    expect(variant.stock!.rsdQty, 0);
    expect(variant.stock!.value, 0);
  });

  test('a service ignores quantity edits', () async {
    model.setProductType('3');

    await model.updateVariantQuantity(variant.id, 7, persistToBackend: false);

    expect(variant.qty, 0);
    expect(variant.stock!.currentStock, 0);
  });

  test('goods keep taking stock', () async {
    model.setProductType('2');

    await model.updateVariantQuantity(variant.id, 7, persistToBackend: false);

    expect(variant.itemTyCd, '2');
    expect(variant.qty, 7);
    expect(variant.stock!.currentStock, 7);
  });
}
