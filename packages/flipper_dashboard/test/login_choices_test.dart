import 'package:flipper_dashboard/login_choices.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart'; // Corrected IDatabase import
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked/stacked.dart';
// import 'package:stacked/stacked.dart'; // Not directly used in test, but keep if part of TestApp/CoreViewModel
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_routing/app.router.dart';
import 'package:supabase_models/brick/models/shift.model.dart';
import 'package:supabase_models/brick/repository/storage.dart'; // For LocalStorage

import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';
import 'dart:async';

// Mock for PageRouteInfo
class FakePageRouteInfo extends Fake implements PageRouteInfo {}

// Mock DialogService (already in your original code, keep it)
class MockDialogService extends Mock implements DialogService {}

void main() {
  group('LoginChoices', () {
    late MockRouterService mockRouterService;
    late MockStartupViewModel mockStartupViewModel;
    late TestEnvironment env;
    late MockDatabaseSync mockDbSync;
    late MockBox
        mockBox; // Renamed from MockLocalStorage, but implements LocalStorage
    late MockDialogService mockDialogService;

    late Business businessWithMultipleBranches;
    late Business businessWithSingleBranch;
    late Branch branch1;
    late Branch branch2;

    setUpAll(() async {
      env = TestEnvironment();
      await env.init(); // This now stores original ProxyService links
    });

    tearDownAll(() {
      env.restore(); // This now restores original ProxyService links
    });

    setUp(() {
      // Reset GetIt for each test to ensure fresh mocks.
      // This is important because `GetIt.I.reset()` in tearDownAll might not be enough
      // if `setUp` registers new mocks after a previous test failed.
      if (GetIt.I.isRegistered<RouterService>())
        GetIt.I.unregister<RouterService>();
      if (GetIt.I.isRegistered<StartupViewModel>())
        GetIt.I.unregister<StartupViewModel>();
      if (GetIt.I.isRegistered<DatabaseSyncInterface>())
        GetIt.I.unregister<DatabaseSyncInterface>();
      if (GetIt.I.isRegistered<LocalStorage>())
        GetIt.I.unregister<LocalStorage>();
      if (GetIt.I.isRegistered<DialogService>())
        GetIt.I.unregister<DialogService>();

      mockRouterService = MockRouterService();
      mockStartupViewModel = MockStartupViewModel();
      mockDbSync = MockDatabaseSync();
      mockBox = MockBox(); // This mock implements LocalStorage
      mockDialogService = MockDialogService();

      // Register fallbacks for any() and other matchers
      registerFallbackValue(FakePageRouteInfo());
      registerFallbackValue(StackTrace.current);
      registerFallbackValue(DialogRequest());
      registerFallbackValue(DialogResponse()); // Added this fallback

      // Register your mock services with GetIt.
      GetIt.I.registerSingleton<RouterService>(mockRouterService);
      GetIt.I.registerSingleton<StartupViewModel>(mockStartupViewModel);
      GetIt.I.registerSingleton<DatabaseSyncInterface>(mockDbSync);
      GetIt.I.registerSingleton<LocalStorage>(
          mockBox); // Register mockBox as LocalStorage
      GetIt.I.registerSingleton<DialogService>(mockDialogService);

      // Explicitly set ProxyService's static members to use the mocks.
      // THIS IS CRUCIAL FOR PROXYSERVICE TO USE YOUR MOCKS.
      // ProxyService.strategy = mockDbSync;
      ProxyService.box = mockBox;

      // Define test data (remains the same)
      businessWithMultipleBranches = Business(
        id: "1",
        name: 'Business with Multiple Branches',
        serverId: 1,
        longitude: '0',
        latitude: '0',
        userId: 1,
        tinNumber: 12345, // Ensure these are non-null for the widget's logic
        encryptionKey: 'test-key', // Ensure these are non-null
      );
      businessWithSingleBranch = Business(
        id: "2",
        name: 'Business with Single Branch',
        serverId: 2,
        longitude: '0',
        latitude: '0',
        userId: 1,
        tinNumber: 54321,
        encryptionKey: 'another-key',
      );
      branch1 = Branch(id: "1", name: 'Branch 1', serverId: 10, businessId: 1);
      branch2 = Branch(id: "2", name: 'Branch 2', serverId: 20, businessId: 1);

      // --- Common Mocking for Box (LocalStorage) and Database ---
      // These mocks are needed for almost any interaction with ProxyService.box
      when(() => mockBox.getBusinessId())
          .thenReturn(1); // Default, can be overridden per test
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.writeInt(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => 0); // Mock writeInt to return a Future<int>
      when(() => mockBox.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.writeBool(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.readInt(key: 'tin'))
          .thenReturn(null); // Default, can be changed
      when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
      when(() => mockBox.getDefaultApp()).thenReturn(null);
      when(() => mockBox.readString(key: any(named: 'key')))
          .thenReturn(null); // Explicitly added mock for readString

      // Reset mocks for a clean state in each test
      reset(mockRouterService);
      reset(mockStartupViewModel);
      reset(mockDbSync);
      reset(mockBox);
      reset(mockDialogService);
    });

    testWidgets('renders correctly and shows business choices',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithSingleBranch]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithSingleBranch])),
            // FIX: Use a concrete businessId for the initial branchesProvider override
            branchesProvider(
                    businessId:
                        1) // Assumes initial businessId from mockBox.getBusinessId() is 1
                .overrideWith((ref) => Future.value([])),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      // Initial pump to load the FutureProviders
      await tester.pumpAndSettle();

      expect(find.text('Choose a Business'), findsOneWidget);
      expect(find.text('Business with Single Branch'), findsOneWidget);
    });

    testWidgets(
        'navigates to branch selection when a business with multiple branches is tapped',
        (WidgetTester tester) async {
      // Arrange
      // 1. Mock initial businesses fetch
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithMultipleBranches]);

      // 2. Mock branches fetch after business selection (for multiple branches case)
      when(() => mockDbSync.branches(
          businessId: businessWithMultipleBranches.serverId,
          active: false)).thenAnswer((_) async => [branch1, branch2]);
      when(() => mockDbSync.branches(
          // This is called by _updateAllBranchesInactive
          businessId: businessWithMultipleBranches.serverId,
          active: true)).thenAnswer((_) async => []);

      // 3. Mock internal business update calls by _setDefaultBusiness
      // _updateAllBusinessesInactive - mocks update for ALL businesses, not just the one tapped
      when(() => mockDbSync.updateBusiness(
            businessId: any(named: 'businessId'), // Match any business ID
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      // _updateBusinessActive - mocks update for the SPECIFIC business tapped
      when(() => mockDbSync.updateBusiness(
            businessId: businessWithMultipleBranches.serverId,
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

      // 4. Mock ProxyService.box calls in _updateBusinessPreferences
      when(() => mockBox.writeInt(
            key: 'businessId',
            value: businessWithMultipleBranches.serverId,
          )).thenAnswer((_) async => 0);
      when(() => mockBox.writeInt(
            key: 'tin',
            value: businessWithMultipleBranches
                .tinNumber!, // tinNumber is non-null
          )).thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
            key: 'encryptionKey',
            value: businessWithMultipleBranches
                .encryptionKey!, // encryptionKey is non-null
          )).thenAnswer((_) async {});

      // Set current businessId in box for branchesProvider in the widget to correctly use it
      // This mimics the state *after* a business is selected and businessId is written
      when(() => mockBox.getBusinessId())
          .thenReturn(businessWithMultipleBranches.serverId);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithMultipleBranches])),
            // FIX: Use a concrete businessId for the initial branchesProvider override
            branchesProvider(
                    businessId:
                        1) // Assumes initial businessId from mockBox.getBusinessId() is 1
                .overrideWith((ref) => Future.value([])),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      // Initial pump to load the businesses.
      await tester
          .pumpAndSettle(); // Waits for initial FutureProviders to resolve

      // Verify the business is displayed
      expect(find.text('Business with Multiple Branches'), findsOneWidget);

      // Act: Tap the business
      await tester.tap(find.text('Business with Multiple Branches'));

      // Assert: Now, pumpAndSettle should wait for all the asynchronous operations
      await tester.pumpAndSettle();

      // Verify navigation to branch selection and display of branches
      expect(find.text('Choose a Branch'), findsOneWidget);
      expect(find.text('Branch 1'), findsOneWidget);
      expect(find.text('Branch 2'), findsOneWidget);
    });

    testWidgets(
        'completes login flow when a business with a single branch is tapped',
        (WidgetTester tester) async {
      // Arrange
      // 1. Mock initial businesses fetch
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithSingleBranch]);

      // 2. Mock branches fetch after business selection (for single branch case)
      when(() => mockDbSync.branches(
          businessId: businessWithSingleBranch.serverId,
          active: false)).thenAnswer((_) async => [branch1]);
      when(() => mockDbSync.branches(
          // This is called by _updateAllBranchesInactive
          businessId: businessWithSingleBranch.serverId,
          active: true)).thenAnswer((_) async => []);

      // 3. Mock internal business update calls by _setDefaultBusiness
      when(() => mockDbSync.updateBusiness(
            businessId: any(named: 'businessId'), // Match any business ID
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      when(() => mockDbSync.updateBusiness(
            businessId: businessWithSingleBranch.serverId,
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

      // 4. Mock internal branch update calls by _setDefaultBranch
      when(() => mockDbSync.updateBranch(
            branchId: any(named: 'branchId'), // Match any branch ID
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      when(() => mockDbSync.updateBranch(
            branchId: branch1.serverId!, // BranchId is non-null
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

      // 5. Mock ProxyService.box calls for business and branch setup
      when(() =>
              mockBox.writeInt(key: 'businessId', value: any(named: 'value')))
          .thenAnswer((_) async => 0);
      when(() => mockBox.writeInt(key: 'tin', value: any(named: 'value')))
          .thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
          key: 'encryptionKey',
          value: any(named: 'value'))).thenAnswer((_) async {});

      when(() => mockBox.writeInt(key: 'branchId', value: any(named: 'value')))
          .thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
          key: 'branchIdString',
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.writeBool(key: 'branch_switched', value: true))
          .thenAnswer((_) async {});
      when(() => mockBox.writeInt(
          key: 'last_branch_switch_timestamp',
          value: any(named: 'value'))).thenAnswer((_) async => 0);
      when(() => mockBox.writeInt(
          key: 'active_branch_id',
          value: any(named: 'value'))).thenAnswer((_) async => 0);
      when(() => mockBox.writeBool(
          key: 'branch_navigation_in_progress',
          value: any(named: 'value'))).thenAnswer((_) async {});

      // Set current businessId in box for branchesProvider in the widget to correctly use it
      when(() => mockBox.getBusinessId())
          .thenReturn(businessWithSingleBranch.serverId);
      when(() => mockBox.getUserId()).thenReturn(1);

      // Mock startupViewModel calls for subscription check
      when(() => mockStartupViewModel.hasActiveSubscription())
          .thenAnswer((_) async => true);

      // Mock router service navigation
      when(() => mockRouterService.navigateTo(any()))
          .thenAnswer((invocation) async {
        final route = invocation.positionalArguments[0] as PageRouteInfo;
        expect(route, isA<FlipperAppRoute>());
        return null;
      });

      // Mock Platform.isAndroid, Platform.isIOS, etc. for desktop vs mobile flow
      when(() => mockBox.getDefaultApp())
          .thenReturn('POS'); // Assume user has chosen POS as default

      // Mock shift logic
      when(() => mockDbSync.getCurrentShift(userId: 1))
          .thenAnswer((_) async => null); // No current shift
      when(() => mockDialogService.showCustomDialog(
            variant: DialogType.startShift,
            title: 'Start New Shift',
            description: any(named: 'description'),
            mainButtonTitle: any(named: 'mainButtonTitle'),
            secondaryButtonTitle: any(named: 'secondaryButtonTitle'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => DialogResponse(
            confirmed: true,
            data: {'openingBalance': 100.0, 'notes': 'Test shift'},
          ));
      when(() => mockDbSync.startShift(
            userId: 1,
            openingBalance: 100.0,
            note: 'Test shift',
          )).thenAnswer((_) async => Shift(
            id: 'shift1',
            userId: 1,
            openingBalance: 100.0,
            businessId: businessWithSingleBranch
                .serverId, // Ensure businessId is non-null
            startAt: DateTime.now(),
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithSingleBranch])),
            // FIX: Use a concrete businessId for the initial branchesProvider override
            branchesProvider(
                    businessId:
                        1) // Assumes initial businessId from mockBox.getBusinessId() is 1
                .overrideWith((ref) => Future.value([branch1])),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Business with Single Branch'), findsOneWidget);

      await tester.tap(find.text('Business with Single Branch'));

      await tester.pumpAndSettle();

      verify(() =>
              mockRouterService.navigateTo(any(that: isA<FlipperAppRoute>())))
          .called(1);
      expect(find.text('Choose a Branch'), findsNothing);
    });
  });
}
