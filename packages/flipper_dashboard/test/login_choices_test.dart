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
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_routing/app.router.dart';
import 'package:supabase_models/brick/models/shift.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';
import 'dart:async';

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

class MockDialogService extends Mock implements DialogService {}

void main() {
  group('LoginChoices', () {
    late MockRouterService mockRouterService;
    late MockStartupViewModel mockStartupViewModel;
    late TestEnvironment env;
    late MockDatabaseSync mockDbSync;
    late MockBox mockBox;
    late MockDialogService mockDialogService;

    late Business businessWithMultipleBranches;
    late Business businessWithSingleBranch;
    late Branch branch1;
    late Branch branch2;

    setUpAll(() async {
      env = TestEnvironment();
      await env.init();
    });

    tearDownAll(() {
      env.restore();
    });

    setUp(() {
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
      mockBox = MockBox();
      mockDialogService = MockDialogService();

      registerFallbackValue(FakePageRouteInfo());
      registerFallbackValue(StackTrace.current);
      registerFallbackValue(DialogRequest());
      registerFallbackValue(DialogResponse()); // Added this fallback

      GetIt.I.registerSingleton<RouterService>(mockRouterService);
      GetIt.I.registerSingleton<StartupViewModel>(mockStartupViewModel);
      GetIt.I.registerSingleton<DatabaseSyncInterface>(mockDbSync);
      GetIt.I.registerSingleton<LocalStorage>(mockBox);
      GetIt.I.registerSingleton<DialogService>(mockDialogService);

      ProxyService.box = mockBox;

      businessWithMultipleBranches = Business(
        id: "1",
        name: 'Business with Multiple Branches',
        serverId: 1,
        longitude: '0',
        latitude: '0',
        userId: 1,
        tinNumber: 12345,
        encryptionKey: 'test-key',
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

      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.writeInt(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.writeBool(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.readInt(key: 'tin')).thenReturn(null);
      when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
      when(() => mockBox.getDefaultApp()).thenReturn(null);
      // Added mock for readString
      when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);

      reset(mockRouterService);
      reset(mockStartupViewModel);
      reset(mockDbSync);
      reset(mockBox);
      reset(mockDialogService);
    });

    testWidgets('renders correctly and shows business choices',
        (WidgetTester tester) async {
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithSingleBranch]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithSingleBranch])),
            // FIX HERE: Use a concrete businessId for the initial override
            branchesProvider(
                    businessId:
                        1) // Using 1, as mockBox.getBusinessId() defaults to 1
                .overrideWith((ref) => Future.value([])),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Choose a Business'), findsOneWidget);
      expect(find.text('Business with Single Branch'), findsOneWidget);
    });

    testWidgets(
        'navigates to branch selection when a business with multiple branches is tapped',
        (WidgetTester tester) async {
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithMultipleBranches]);

      when(() => mockDbSync.branches(
          businessId: businessWithMultipleBranches.serverId,
          active: false)).thenAnswer((_) async => [branch1, branch2]);
      when(() => mockDbSync.branches(
          businessId: businessWithMultipleBranches.serverId,
          active: true)).thenAnswer((_) async => []);

      when(() => mockDbSync.updateBusiness(
            businessId: any(named: 'businessId'),
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      when(() => mockDbSync.updateBusiness(
            businessId: businessWithMultipleBranches.serverId,
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

      when(() => mockBox.writeInt(
            key: 'businessId',
            value: businessWithMultipleBranches.serverId,
          )).thenAnswer((_) async => 0);
      when(() => mockBox.writeInt(
            key: 'tin',
            value: businessWithMultipleBranches.tinNumber!,
          )).thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
            key: 'encryptionKey',
            value: businessWithMultipleBranches.encryptionKey!,
          )).thenAnswer((_) async {});

      when(() => mockBox.getBusinessId())
          .thenReturn(businessWithMultipleBranches.serverId);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithMultipleBranches])),
            // FIX HERE: Use a concrete businessId for the initial override
            branchesProvider(businessId: 1)
                .overrideWith((ref) => Future.value([])),
          ],
          child: const TestApp(
            child: Scaffold(
              body: LoginChoices(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Business with Multiple Branches'), findsOneWidget);

      await tester.tap(find.text('Business with Multiple Branches'));

      await tester.pumpAndSettle();

      expect(find.text('Choose a Branch'), findsOneWidget);
      expect(find.text('Branch 1'), findsOneWidget);
      expect(find.text('Branch 2'), findsOneWidget);
    });

    testWidgets(
        'completes login flow when a business with a single branch is tapped',
        (WidgetTester tester) async {
      when(() => mockDbSync.businesses(userId: 1))
          .thenAnswer((_) async => [businessWithSingleBranch]);

      when(() => mockDbSync.branches(
          businessId: businessWithSingleBranch.serverId,
          active: false)).thenAnswer((_) async => [branch1]);
      when(() => mockDbSync.branches(
          businessId: businessWithSingleBranch.serverId,
          active: true)).thenAnswer((_) async => []);

      when(() => mockDbSync.updateBusiness(
            businessId: any(named: 'businessId'),
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      when(() => mockDbSync.updateBusiness(
            businessId: businessWithSingleBranch.serverId,
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

      when(() => mockDbSync.updateBranch(
            branchId: any(named: 'branchId'),
            active: false,
            isDefault: false,
          )).thenAnswer((_) async {});
      when(() => mockDbSync.updateBranch(
            branchId: branch1.serverId ?? 1,
            active: true,
            isDefault: true,
          )).thenAnswer((_) async {});

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

      when(() => mockBox.getBusinessId())
          .thenReturn(businessWithSingleBranch.serverId);
      when(() => mockBox.getUserId()).thenReturn(1);

      when(() => mockStartupViewModel.hasActiveSubscription())
          .thenAnswer((_) async => true);

      when(() => mockRouterService.navigateTo(any()))
          .thenAnswer((invocation) async {
        final route = invocation.positionalArguments[0] as PageRouteInfo;
        expect(route, isA<FlipperAppRoute>());
        return null;
      });

      when(() => mockBox.getDefaultApp()).thenReturn('POS');

      when(() => mockDbSync.getCurrentShift(userId: 1))
          .thenAnswer((_) async => null);
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
            businessId: businessWithSingleBranch.serverId,
            startAt: DateTime.now(),
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            businessesProvider.overrideWith(
                (ref) => Future.value([businessWithSingleBranch])),
            // FIX HERE: Use a concrete businessId for the initial override
            branchesProvider(businessId: 1)
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
