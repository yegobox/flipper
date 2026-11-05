import 'dart:async';

import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../test_helpers/mocks.dart';

/// A desk whose person at the till is [admin] (null: nobody signed in).
Widget _desk(bool? admin, {Widget child = const SizedBox()}) =>
    ServiceModeDesk(deskAdmin: () => admin, child: child);

Future<void> _pump(WidgetTester tester, Widget body) async {
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: StackedService.navigatorKey,
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(body: body),
    ),
  );
}

void main() {
  group('serviceModeHotkeyRefusal', () {
    testWidgets('off POS, Bar and Hotel there is nobody to judge', (
      tester,
    ) async {
      await _pump(tester, const Text('REPORTS'));
      expect(await serviceModeHotkeyRefusal(), ServiceModeHotkeyRefusal.noDesk);
    });

    testWidgets('judges the person at the desk', (tester) async {
      await _pump(tester, _desk(null));
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.signInFirst,
      );

      await _pump(tester, _desk(false));
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.notAdmin,
      );

      await _pump(
        tester,
        ServiceModeDesk(deskAdmin: () async => true, child: const SizedBox()),
      );
      expect(await serviceModeHotkeyRefusal(), isNull);
    });

    testWidgets('the desk mounted last wins until it goes', (tester) async {
      await _pump(tester, _desk(true, child: _desk(false)));
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.notAdmin,
      );

      await _pump(tester, _desk(true, child: const SizedBox()));
      expect(await serviceModeHotkeyRefusal(), isNull);
    });

    testWidgets('a desk gone while its admin lookup ran: nobody to judge', (
      tester,
    ) async {
      final lookup = Completer<bool?>();
      await _pump(
        tester,
        ServiceModeDesk(deskAdmin: () => lookup.future, child: const Text('')),
      );
      final refusal = serviceModeHotkeyRefusal();
      // A POS user switch swaps the shell, disposing the desk.
      await _pump(tester, const Text('LOCK'));
      lookup.complete(true);
      expect(await refusal, ServiceModeHotkeyRefusal.noDesk);
    });

    testWidgets('a manager PIN prompt open on the desk: no switch', (
      tester,
    ) async {
      var prompting = true;
      await _pump(
        tester,
        ServiceModeDesk(
          deskAdmin: () => true,
          promptOpen: () => prompting,
          child: const SizedBox(),
        ),
      );
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.promptOpen,
      );
      prompting = false;
      expect(await serviceModeHotkeyRefusal(), isNull);
    });

    testWidgets('a page or dialog over the desk turns it off', (tester) async {
      await _pump(tester, _desk(true));
      final navigator = StackedService.navigatorKey!.currentState!;
      navigator.push(
        MaterialPageRoute<void>(builder: (_) => const Text('ADMIN')),
      );
      await tester.pumpAndSettle();
      expect(await serviceModeHotkeyRefusal(), ServiceModeHotkeyRefusal.noDesk);

      navigator.pop();
      await tester.pumpAndSettle();
      expect(await serviceModeHotkeyRefusal(), isNull);
    });
  });

  group('cycleServiceMode', () {
    Future<void> press(WidgetTester tester, Widget body) async {
      // The snack bar is laid out for a desk terminal.
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _pump(tester, body);
      await cycleServiceMode();
      await tester.pump();
    }

    testWidgets('off the desks: says where to go', (tester) async {
      await press(tester, const Text('REPORTS'));
      expect(
        find.text(
          "Open POS, Bar or Hotel to switch this device's service mode.",
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('on a lock: asks for a sign-in first', (tester) async {
      await press(tester, _desk(null));
      expect(
        find.text('Sign in at the desk first, then switch the service mode.'),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('a non-admin at the desk: admins only', (tester) async {
      await press(tester, _desk(false));
      expect(
        find.text("Only an admin can switch this device's service mode."),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('a manager PIN prompt open: finish it first', (tester) async {
      await press(
        tester,
        ServiceModeDesk(
          deskAdmin: () => true,
          promptOpen: () => true,
          child: const SizedBox(),
        ),
      );
      expect(
        find.text(
          'Finish or cancel the manager PIN first, then switch the service '
          'mode.',
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    group('an admin at the desk', () {
      late MockBox box;
      late List<String> did;

      setUp(() async {
        await getIt.reset();
        box = MockBox();
        when(() => box.readBool(key: any(named: 'key'))).thenReturn(null);
        when(() => box.readString(key: any(named: 'key'))).thenReturn(null);
        getIt.registerSingleton<LocalStorage>(box);
        did = [];
        serviceModeHotkeyOpen = (mode) => did.add('open ${mode.name}');
      });

      tearDown(() async {
        serviceModeHotkeyApply = applyServiceMode;
        serviceModeHotkeyOpen = openServiceModeShell;
        await getIt.reset();
      });

      testWidgets('switches to the next mode and lands on it', (tester) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return true;
        };
        // A POS device with nothing picked goes to the Bar next.
        expect(nextServiceMode(activeServiceMode), ServiceMode.bar);
        await press(tester, _desk(true));
        expect(did, ['apply bar', 'open bar']);
        expect(find.textContaining('This device switched to'), findsOneWidget);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('a switch that rolled back stays put and says so', (
        tester,
      ) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return false;
        };
        await press(tester, _desk(true));
        expect(did, ['apply bar']);
        expect(
          find.textContaining('the branch settings did not save'),
          findsOneWidget,
        );
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });
    });
  });

  group('posDeskAdmin', () {
    late MockBox box;
    late MockDatabaseSync db;

    setUp(() async {
      await getIt.reset();
      box = MockBox();
      db = MockDatabaseSync();
      final strategy = MockSyncStrategy();
      when(() => strategy.current).thenReturn(db);
      getIt.registerSingleton<LocalStorage>(box);
      getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
    });

    tearDown(() => getIt.reset());

    test('nobody signed in to the app: nobody at the POS', () async {
      when(() => box.getUserId()).thenReturn(null);
      expect(await posDeskAdmin(), isNull);
    });

    test('the signed-in account, on the Settings admin right', () async {
      when(() => box.getUserId()).thenReturn('u-1');
      when(
        () => db.isAdmin(userId: 'u-1', appFeature: AppFeature.Settings),
      ).thenAnswer((_) async => false);
      expect(await posDeskAdmin(), isFalse);
    });

    test('a Settings admin at the desk: admin', () async {
      when(() => box.getUserId()).thenReturn('u-1');
      when(
        () => db.isAdmin(userId: 'u-1', appFeature: AppFeature.Settings),
      ).thenAnswer((_) async => true);
      expect(await posDeskAdmin(), isTrue);
    });
  });
}
