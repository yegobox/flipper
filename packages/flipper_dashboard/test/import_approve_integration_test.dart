import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_models/db_model_export.dart' as model;
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'test_helpers/setup.dart';

// flutter test test/import_approve_integration_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  final env = TestEnvironment();

  setUpAll(() async {
    await env.init();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
  });

  tearDown(() {
    env.restore();
  });

  test(
      'approving multiple imports mapped to one existing variant aggregates stocks',
      () async {
    final core = CoreViewModel();

    // Prepare variants
    final existing = model.Variant(
      id: 'existing',
      name: 'Existing',
      stock: model.Stock(branchId: 1, currentStock: 10.0),
      ebmSynced: true,
    );

    final imp1 = model.Variant(
      id: 'imp1',
      name: 'Imp1',
      stock: model.Stock(branchId: 1, currentStock: 5.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    final imp2 = model.Variant(
      id: 'imp2',
      name: 'Imp2',
      stock: model.Stock(branchId: 1, currentStock: 3.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    // Stub strategy.getVariant to return existing
    when(() => env.mockDbSync.getVariant(id: 'existing'))
        .thenAnswer((_) async => existing);

    // Stub updateVariant to capture updates
    when(() => env.mockDbSync.updateVariant(
        updatables: any(named: 'updatables'),
        approvedQty: any(named: 'approvedQty'),
        )).thenAnswer((inv) async {
      // emulate persisting by doing nothing
      return Future.value();
    });

    when(() => env.mockTaxApi.updateImportItems(
            item: any(named: 'item'), URI: any(named: 'URI')))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: "000", resultMsg: "Success"));

    // Build map and call method
    final variantMap = {
      'existing': [imp1, imp2]
    };

    await core.approveAllImportItems([imp1, imp2], variantMap: variantMap);

    // Verify imports updated locally
    expect(imp1.imptItemSttsCd, '3');
    expect(imp2.imptItemSttsCd, '3');
    expect(imp1.assigned, true);
    expect(imp2.assigned, true);

    // existing stock should be increased by 8.0
    // Because updateVariant is stubbed, we check the computed value as set on existing object
    expect(existing.stock?.currentStock, closeTo(18.0, 0.0001));

    // Verify updateVariant calls
    verify(() => env.mockDbSync
        .updateVariant(updatables: [imp1])).called(1);
    verify(() => env.mockDbSync
        .updateVariant(updatables: [imp2])).called(1);
    verify(() => env.mockDbSync.updateVariant(
        updatables: [existing], approvedQty: 8.0)).called(1);
  });

  test('approving unmapped imports creates new variants', () async {
    final core = CoreViewModel();

    // Prepare variants
    final existing = model.Variant(
      id: 'existing',
      name: 'Existing',
      stock: model.Stock(branchId: 1, currentStock: 10.0),
      ebmSynced: true,
    );

    final imp1 = model.Variant(
      id: 'imp1',
      name: 'Imp1',
      stock: model.Stock(branchId: 1, currentStock: 5.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    final unmapped = model.Variant(
      id: 'unmapped',
      name: 'Unmapped',
      stock: model.Stock(branchId: 1, currentStock: 7.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    // Stub strategy.getVariant to return existing
    when(() => env.mockDbSync.getVariant(id: 'existing'))
        .thenAnswer((_) async => existing);

    // Stub updateVariant to capture updates
    when(() => env.mockDbSync.updateVariant(
        updatables: any(named: 'updatables'),
        approvedQty: any(named: 'approvedQty'),
       
        updateIo: any(named: 'updateIo'))).thenAnswer((inv) async {
      // emulate persisting by doing nothing
      return Future.value();
    });

    when(() => env.mockTaxApi.updateImportItems(
            item: any(named: 'item'), URI: any(named: 'URI')))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: "000", resultMsg: "Success"));

    // Build map and call method - only imp1 is mapped, unmapped is not
    final variantMap = {
      'existing': [imp1]
    };

    await core.approveAllImportItems([imp1, unmapped], variantMap: variantMap);

    // Verify mapped import updated
    expect(imp1.imptItemSttsCd, '3');
    expect(imp1.assigned, true);

    // Verify unmapped import updated as new variant
    expect(unmapped.imptItemSttsCd, '3');
    expect(unmapped.assigned, false);
    expect(unmapped.itemCd, 'ITEM123'); // from stubbed itemCode

    // existing stock should be increased by 5.0 (only imp1)
    expect(existing.stock?.currentStock, closeTo(15.0, 0.0001));

    // Verify updateVariant was called with updateIo: true for unmapped variant
    verify(() => env.mockDbSync.updateVariant(
        updatables: [unmapped], approvedQty: 7.0, updateIo: true)).called(1);
  });

  test('approving multiple unmapped imports creates new variants', () async {
    final core = CoreViewModel();

    final unmapped1 = model.Variant(
      id: 'unmapped1',
      name: 'Unmapped1',
      stock: model.Stock(branchId: 1, currentStock: 4.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    final unmapped2 = model.Variant(
      id: 'unmapped2',
      name: 'Unmapped2',
      stock: model.Stock(branchId: 1, currentStock: 6.0),
      imptItemSttsCd: '2',
      assigned: false,
    );

    // Stub updateVariant to capture updates
    when(() => env.mockDbSync.updateVariant(
        updatables: any(named: 'updatables'),
        approvedQty: any(named: 'approvedQty'),
        updateIo: any(named: 'updateIo'))).thenAnswer((inv) async {
      // emulate persisting by doing nothing
      return Future.value();
    });

    when(() => env.mockTaxApi.updateImportItems(
            item: any(named: 'item'), URI: any(named: 'URI')))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: "000", resultMsg: "Success"));

    // Build map and call method - no mappings, all unmapped
    final variantMap = <String, List<model.Variant>>{};

    await core
        .approveAllImportItems([unmapped1, unmapped2], variantMap: variantMap);

    // Verify both unmapped imports updated as new variants
    expect(unmapped1.imptItemSttsCd, '3');
    expect(unmapped1.assigned, false);
    expect(unmapped1.itemCd, 'ITEM123');

    expect(unmapped2.imptItemSttsCd, '3');
    expect(unmapped2.assigned, false);
    expect(unmapped2.itemCd, 'ITEM123');

    // Verify updateVariant was called with updateIo: true for both
    verify(() => env.mockDbSync.updateVariant(
        updatables: [unmapped1], approvedQty: 4.0, updateIo: true)).called(1);
    verify(() => env.mockDbSync.updateVariant(
        updatables: [unmapped2], approvedQty: 6.0, updateIo: true)).called(1);
  });
}
