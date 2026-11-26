import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockAppService extends Mock implements AppService {}

class _MockBox extends Mock implements LocalStorage {}

class _MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

class _MockSyncStrategy extends Mock implements SyncStrategy {}

class _MockSettingsService extends Mock implements SettingsService {}

class _MockLanguage extends Mock implements Language {}

class _MockKeyPadService extends Mock implements KeyPadService {}

class _MockProductService extends Mock implements ProductService {}

const _branchId = 'branch-1';

/// Opening Settings runs `createPin()` → `defaultBranch()`. While Ditto is
/// still opening and Brick has no copy, `activeBranch()` throws on purpose;
/// that must not escape as an uncaught async error (PostHog inbox
/// 01a210d9-01b3-7f33-a6de-2d9dae539857).
// flutter test test/default_branch_not_ready_test.dart
void main() {
  late _MockAppService app;
  late _MockBox box;
  late _MockDatabaseSync db;

  setUpAll(() {
    registerFallbackValue(Branch(id: 'fallback', name: 'x', businessId: 'b'));
  });

  setUp(() async {
    await getIt.reset();
    app = _MockAppService();
    box = _MockBox();
    db = _MockDatabaseSync();
    final strategy = _MockSyncStrategy();
    when(() => strategy.current).thenReturn(db);
    when(() => box.getBranchId()).thenReturn(_branchId);

    getIt
      ..registerSingleton<AppService>(app)
      ..registerSingleton<LocalStorage>(box)
      ..registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy')
      ..registerSingleton<SettingsService>(_MockSettingsService())
      ..registerSingleton<Language>(_MockLanguage())
      ..registerSingleton<KeyPadService>(_MockKeyPadService())
      ..registerSingleton<ProductService>(_MockProductService());
  });

  tearDown(() => getIt.reset());

  test(
    'Ditto not ready: createPin completes and keeps the current branch',
    () async {
      when(
        () => db.activeBranch(branchId: _branchId),
      ).thenThrow(Exception('Ditto not initialized for active branch query'));

      // Awaited: a throw inside defaultBranch() would fail this call instead of
      // escaping to the zone, so completing normally is the regression check.
      await SettingViewModel().createPin();

      verify(() => db.activeBranch(branchId: _branchId)).called(1);
      verifyNever(() => app.setActiveBranch(branch: any(named: 'branch')));
    },
  );

  test('branch found: createPin waits for it and sets it on the app', () async {
    final branch = Branch(id: _branchId, name: 'Main', businessId: 'biz-1');
    when(() => db.activeBranch(branchId: _branchId))
        .thenAnswer((_) async => branch);

    await SettingViewModel().createPin();

    verify(() => app.setActiveBranch(branch: branch)).called(1);
  });

  test('no stored branch: nothing is looked up', () async {
    when(() => box.getBranchId()).thenReturn(null);

    await SettingViewModel().createPin();

    verifyNever(() => db.activeBranch(branchId: any(named: 'branchId')));
    verifyNever(() => app.setActiveBranch(branch: any(named: 'branch')));
  });
}
