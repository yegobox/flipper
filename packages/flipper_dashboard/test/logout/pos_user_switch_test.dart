import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/logout/pos_switch_user_dialog.dart';
import 'package:flipper_dashboard/logout/pos_user_switch_lock_provider.dart';
import 'package:flipper_dashboard/logout/pos_user_switch_lock_screen.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../test_helpers/mocks.dart';

// flutter test test/logout/pos_user_switch_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBox mockBox;

  setUp(() async {
    await getIt.reset();
    mockBox = MockBox();
    getIt.registerSingleton<LocalStorage>(mockBox);
    when(() => mockBox.getUserId()).thenReturn('user-a');
    when(() => mockBox.getUserName()).thenReturn('Alice Agent');
    when(() => mockBox.getUserPhone()).thenReturn(null);
    when(() => mockBox.getBranchId()).thenReturn('branch-1');
    when(() => mockBox.getBusinessId()).thenReturn('biz-1');
    when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('PosSwitchUserSelection', () {
    test('holds tenant and pin', () {
      final tenant = Tenant(
        id: 't1',
        name: 'Alice',
        userId: 'user-b',
      );
      const pin = '123456';
      final selection = PosSwitchUserSelection(tenant: tenant, pin: pin);
      expect(selection.tenant.id, 't1');
      expect(selection.pin, pin);
    });
  });

  group('PosUserSwitchGate', () {
    testWidgets('hides POS child while lock is active', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posUserSwitchLockProvider.overrideWith((ref) => true),
            barStaffProvider.overrideWith(
              (ref) async => [
                Tenant(id: 't-b', name: 'Cashier B', userId: 'user-b'),
              ],
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PosUserSwitchGate(
                child: Text('POS_VISIBLE'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('POS_VISIBLE'), findsNothing);
      expect(find.byType(PosUserSwitchLockScreen), findsOneWidget);
      expect(find.textContaining('Who\'s on the register'), findsWidgets);
      expect(find.text('Cashier B'), findsOneWidget);
    });

    testWidgets('shows POS child when lock is off', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posUserSwitchLockProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PosUserSwitchGate(
                child: Text('POS_VISIBLE'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('POS_VISIBLE'), findsOneWidget);
      expect(find.byType(PosUserSwitchLockScreen), findsNothing);
    });
  });

  group('PosSwitchUserDialog', () {
    testWidgets('lists staff excluding the current user', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final staff = [
        Tenant(id: 't-a', name: 'Demo Shop', userId: 'user-a'),
        Tenant(id: 't-b', name: 'Cashier B', userId: 'user-b'),
        Tenant(id: 't-c', name: 'Cashier C', userId: 'user-c'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            barStaffProvider.overrideWith((ref) async => staff),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PosSwitchUserDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Switch User'), findsOneWidget);
      expect(find.text('Cashier B'), findsOneWidget);
      expect(find.text('Cashier C'), findsOneWidget);
      expect(find.text('Demo Shop'), findsNothing);
    });

    testWidgets('shows empty message when no other staff', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            barStaffProvider.overrideWith(
              (ref) async => [
                Tenant(id: 't-a', name: 'Only Me', userId: 'user-a'),
              ],
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PosSwitchUserDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('No other staff members available to switch to.'),
        findsOneWidget,
      );
    });
  });

  group('UserInfoWidget menu', () {
    testWidgets('includes Switch User alongside Switch Branch and Log out',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final branch = Branch(
        id: 'branch-1',
        name: 'Demo Shop',
        businessId: 'biz-1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeBranchProvider.overrideWith((ref) => Stream.value(branch)),
            posUserSwitchLockProvider.overrideWith((ref) => false),
          ],
          child: MaterialApp(
            localizationsDelegates: [
              ...FlipperLocalizationDelegates.delegates,
            ],
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const Scaffold(
              body: Align(
                alignment: Alignment.topRight,
                child: UserInfoWidget(handoffTopBarStyle: true),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('ALICE AGENT'), findsOneWidget);
      expect(find.text('Demo Shop'), findsOneWidget);

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Switch Branch'), findsOneWidget);
      expect(find.text('Switch User'), findsOneWidget);
      expect(find.textContaining('Log'), findsWidgets);
    });
  });
}
