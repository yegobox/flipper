import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart' hide BusinessType;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/locator.dart' as services_locator;
import 'package:flipper_routing/app.locator.dart' as routing_locator;
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:test/test.dart';

class MockAppService extends Mock implements AppService {}

class MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

class MockFlipperHttpClient extends Mock implements FlipperHttpClient {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockRouterService extends Mock implements RouterService {}

class MockSyncStrategy extends Mock implements SyncStrategy {}

void main() {
  late MockAppService appService;
  late MockDatabaseSync databaseSync;
  late MockFlipperHttpClient httpClient;
  late MockLocalStorage box;
  late MockRouterService routerService;
  late MockSyncStrategy syncStrategy;

  setUp(() async {
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();

    appService = MockAppService();
    databaseSync = MockDatabaseSync();
    httpClient = MockFlipperHttpClient();
    box = MockLocalStorage();
    routerService = MockRouterService();
    syncStrategy = MockSyncStrategy();

    services_locator.getIt.registerSingleton<AppService>(appService);
    services_locator.getIt.registerSingleton<LocalStorage>(box);
    services_locator.getIt.registerSingleton<SyncStrategy>(
      syncStrategy,
      instanceName: 'strategy',
    );
    services_locator.getIt.registerSingleton<Crash>(
      CrashlitycsTalkerObserverUnsupported(),
    );
    services_locator.getIt.registerSingleton<HttpClientInterface>(httpClient);
    routing_locator.locator.registerSingleton<RouterService>(routerService);

    when(() => syncStrategy.current).thenReturn(databaseSync);
  });

  tearDown(() async {
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();
  });

  SignupViewModel buildSubject() => SignupViewModel();

  group('SignupViewModel', () {
    test('stores user-entered profile fields', () {
      final model = buildSubject();

      model.setName(name: 'Acme Shop');
      model.setFullName(name: 'Alice Owner');
      model.setCountry(country: 'RW');

      expect(model.kName, 'Acme Shop');
      expect(model.kFullName, 'Alice Owner');
      expect(model.kCountry, 'RW');
    });

    test('notifies listeners when tin and business type change', () {
      final model = buildSubject();
      var notifications = 0;
      model.addListener(() => notifications++);

      final businessType = BusinessType(id: '2', typeName: 'Individual');

      model.tin = '123456789';
      model.businessType = businessType;

      expect(model.tin, '123456789');
      expect(model.businessType, businessType);
      expect(notifications, 2);
    });

    test('toggles registerStart and notifies listeners', () {
      final model = buildSubject();
      var notifications = 0;
      model.addListener(() => notifications++);

      model.startRegistering();
      expect(model.registerStart, isTrue);

      model.stopRegistering();
      expect(model.registerStart, isFalse);
      expect(notifications, 2);
    });

    test('persists selected business type as the default app', () {
      final model = buildSubject()
        ..businessType = BusinessType(id: '5', typeName: 'Manufacturing');
      when(
        () => box.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      model.setDefaultApp();

      verify(() => box.writeString(key: defaultApp, value: '5')).called(1);
    });

    test('reads referral code from local storage', () {
      when(() => box.readString(key: 'referralCode')).thenReturn('REF-42');

      final referralCode = buildSubject().getReferralCode();

      expect(referralCode, 'REF-42');
    });

    test('saves registered business and branch ids', () async {
      final model = buildSubject();
      when(
        () => box.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await model.saveBusinessId(Business(id: 'business-1', serverId: 1));
      await model.saveBranchId([
        Branch(id: 'branch-1', businessId: 'business-1'),
      ]);

      verify(
        () => box.writeString(key: 'businessId', value: 'business-1'),
      ).called(1);
      verify(
        () => box.writeString(key: 'branchId', value: 'branch-1'),
      ).called(1);
    });

    test(
      'registerTenant sends the current signup payload to the sync strategy',
      () async {
        final model = buildSubject()
          ..setName(name: 'Acme Shop')
          ..setFullName(name: 'Alice Owner')
          ..setCountry(country: 'RW')
          ..tin = '123456789'
          ..latitude = '-1.9441'
          ..longitude = '30.0619';
        final registeredBusiness = Business(id: 'business-1', serverId: 1);

        when(() => box.getUserId()).thenReturn('user-1');
        when(() => box.getUserPhone()).thenReturn('+250788000000');
        when(
          () => databaseSync.signup(
            business: any(named: 'business'),
            flipperHttpClient: httpClient,
          ),
        ).thenAnswer((_) async => registeredBusiness);

        final result = await model.registerTenant('REF-42');

        final captured =
            verify(
                  () => databaseSync.signup(
                    business: captureAny(named: 'business'),
                    flipperHttpClient: httpClient,
                  ),
                ).captured.single
                as Map;
        expect(result, registeredBusiness);
        expect(captured, containsPair('name', 'Acme Shop'));
        expect(captured, containsPair('fullName', 'Alice Owner'));
        expect(captured, containsPair('country', 'RW'));
        expect(captured, containsPair('latitude', '-1.9441'));
        expect(captured, containsPair('longitude', '30.0619'));
        expect(captured, containsPair('phoneNumber', '+250788000000'));
        expect(captured, containsPair('currency', 'RWF'));
        expect(captured, containsPair('userId', 'user-1'));
        expect(captured, containsPair('tinNumber', 123456789));
        expect(captured, containsPair('businessTypeId', '1'));
        expect(captured, containsPair('type', 'Business'));
        expect(captured, containsPair('bhfid', '00'));
        expect(captured, containsPair('referredBy', 'REF-42'));
        expect(captured['createdAt'], isA<String>());
      },
    );

    test(
      'registerTenant defaults missing tin and referral to current behavior',
      () async {
        final model = buildSubject();

        when(() => box.getUserId()).thenReturn('user-1');
        when(() => box.getUserPhone()).thenReturn('+250788000000');
        when(
          () => databaseSync.signup(
            business: any(named: 'business'),
            flipperHttpClient: httpClient,
          ),
        ).thenAnswer((_) async => Business(id: 'business-1', serverId: 1));

        await model.registerTenant(null);

        final captured =
            verify(
                  () => databaseSync.signup(
                    business: captureAny(named: 'business'),
                    flipperHttpClient: httpClient,
                  ),
                ).captured.single
                as Map;
        expect(captured, containsPair('tinNumber', 1111));
        expect(captured, containsPair('referredBy', 'Organic'));
      },
    );
  });
}
