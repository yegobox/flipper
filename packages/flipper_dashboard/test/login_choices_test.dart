import 'package:flipper_dashboard/login_choices.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';
import 'dart:async';

// Mock for PageRouteInfo
class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  group('LoginChoices', () {
    late MockRouterService mockRouterService;
    late MockStartupViewModel mockStartupViewModel;
    late TestEnvironment env;
    late MockDatabaseSync mockDbSync;
    late MockBox mockBox;

    late StreamController<List<Business>> businessesController;
    late StreamController<List<Branch>> branchesController;

    late Business business;
    late Branch branch1;
    late Branch branch2;

    setUpAll(() async {
      env = TestEnvironment();
      await env.init();
      mockRouterService = MockRouterService();
      mockStartupViewModel = MockStartupViewModel();

      // Register fallbacks
      registerFallbackValue(FakePageRouteInfo());

      // Unregister existing services if they were registered by initializeDependenciesForTest
      if (GetIt.I.isRegistered<RouterService>()) {
        GetIt.I.unregister<RouterService>();
      }
      if (GetIt.I.isRegistered<StartupViewModel>()) {
        GetIt.I.unregister<StartupViewModel>();
      }

      // Register your mock services
      GetIt.I.registerSingleton<RouterService>(mockRouterService);
      GetIt.I.registerSingleton<StartupViewModel>(mockStartupViewModel);
    });

    setUp(() {
      mockDbSync = MockDatabaseSync();
      mockBox = MockBox();

      businessesController = StreamController<List<Business>>();
      branchesController = StreamController<List<Branch>>();

      // Define test data
      business = Business(
        id: "1",
        name: 'Test Business',
        serverId: 1,
        longitude: '0',
        latitude: '0',
        userId: 1,
      );
      branch1 = Branch(id: "1", name: 'Branch 1', serverId: 1, businessId: 1);
      branch2 = Branch(id: "2", name: 'Branch 2', serverId: 2, businessId: 1);

      // Mock the methods on the static mocks that are called *before* the widget is built
      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.writeInt(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async => 1);
      when(() => mockBox.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.writeBool(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});

      // Configure mocks for business and branch data streams

      // Reset mocks for a clean state in each test
      reset(mockRouterService);
      reset(mockStartupViewModel);
      reset(mockDbSync);
      reset(mockBox);
    });

    tearDown(() {
      businessesController.close();
      branchesController.close();
      env.restore();
    });

    testWidgets('renders correctly and shows business choices',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
              (ref) => mockDbSync.businesses(userId: 1),
            ),
            branchesProvider(businessId: 1).overrideWith(
              (ref) => mockDbSync.branches(businessId: 1),
            ),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      businessesController
          .add([business]); // Emit business data after widget is pumped
      await tester.pumpAndSettle();

      expect(find.text('Choose a Business'), findsOneWidget);
      expect(find.text('Test Business'), findsOneWidget);
    });

    testWidgets(
        'navigates to branch selection when a business with multiple branches is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockDbSync.branches(
              businessId: any(named: 'businessId'),
              active: any(named: 'active')))
          .thenAnswer((_) async => [branch1, branch2]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
              (ref) => mockDbSync.businesses(userId: 1),
            ),
            branchesProvider(businessId: 1).overrideWith(
              (ref) => mockDbSync.branches(businessId: 1),
            ),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      businessesController.add([business]); // Emit business data
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Business'));
      await tester.pumpAndSettle();

      // After tapping business, branches should be loaded
      branchesController.add([branch1, branch2]);
      await tester.pumpAndSettle();

      expect(find.text('Choose a Branch'), findsOneWidget);
      expect(find.text('Branch 1'), findsOneWidget);
      expect(find.text('Branch 2'), findsOneWidget);
    });

    testWidgets(
        'completes login flow when a business with a single branch is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockDbSync.branches(
          businessId: any(named: 'businessId'),
          active: any(named: 'active'))).thenAnswer((_) async => [branch1]);

      when(() => mockStartupViewModel.hasActiveSubscription())
          .thenAnswer((_) async => true);
      when(() => mockRouterService.navigateTo(any()))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
              (ref) => mockDbSync.businesses(userId: 1),
            ),
            branchesProvider(businessId: 1).overrideWith(
              (ref) => mockDbSync.branches(businessId: 1),
            ),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      businessesController.add([business]); // Emit business data
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Business'));
      await tester.pumpAndSettle();

      // After tapping business, branches should be loaded
      branchesController.add([branch1]);
      await tester.pumpAndSettle();

      verify(() => mockRouterService.navigateTo(any())).called(1);
    });
  });
}
