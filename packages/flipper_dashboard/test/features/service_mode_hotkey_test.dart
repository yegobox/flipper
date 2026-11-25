import 'dart:async';

import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../test_helpers/mocks.dart';

/// A desk whose person at the till is [admin] (null: nobody signed in).
Widget _desk(bool? admin, {Widget child = const SizedBox()}) =>
    ServiceModeDesk(deskAdmin: () => admin, child: child);

/// The hotkey's switching scrim (a route's own barrier has no colour).
final _scrim = find.byWidgetPredicate(
  (widget) => widget is ModalBarrier && widget.color != null,
);

/// Runs the hotkey to the end, pumping the frames it waits on.
Future<void> _finish(WidgetTester tester, Future<void> switching) async {
  var done = false;
  unawaited(switching.whenComplete(() => done = true));
  for (var i = 0; i < 10 && !done; i++) {
    await tester.pump();
  }
  expect(done, isTrue, reason: 'the switch never finished');
  await switching;
}

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

    testWidgets('a Books-style desk judges by its own pick', (tester) async {
      ServiceMode? pick;
      await _pump(
        tester,
        ServiceModeDesk(target: () => pick, child: const SizedBox()),
      );
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.noAllowedMode,
      );
      pick = ServiceMode.pos;
      expect(await serviceModeHotkeyRefusal(), isNull);
    });

    testWidgets('a Books-style desk with a held mode the branch does not run', (
      tester,
    ) async {
      ServiceMode? off = ServiceMode.hotel;
      await _pump(
        tester,
        ServiceModeDesk(
          target: () => null,
          grantedModeOff: () => off,
          child: const SizedBox(),
        ),
      );
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.modeOffHere,
      );
      off = null;
      expect(
        await serviceModeHotkeyRefusal(),
        ServiceModeHotkeyRefusal.noAllowedMode,
      );
    });

    testWidgets('a Books-style desk gone while it picked: nobody to judge', (
      tester,
    ) async {
      final lookup = Completer<ServiceMode?>();
      await _pump(
        tester,
        ServiceModeDesk(target: () => lookup.future, child: const Text('')),
      );
      final refusal = serviceModeHotkeyRefusal();
      await _pump(tester, const Text('LOCK'));
      lookup.complete(ServiceMode.bar);
      expect(await refusal, ServiceModeHotkeyRefusal.noDesk);
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
      await _finish(tester, cycleServiceMode());
      await tester.pump();
      expect(_scrim, findsNothing);
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

    testWidgets('from Books with no mode allowed: says so', (tester) async {
      await press(
        tester,
        ServiceModeDesk(target: () => null, child: const SizedBox()),
      );
      expect(
        find.textContaining("You don't have access to POS, Bar or Hotel."),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('from Books with a held mode off here: asks to turn it on', (
      tester,
    ) async {
      await press(
        tester,
        ServiceModeDesk(
          target: () => null,
          grantedModeOff: () => ServiceMode.hotel,
          child: const SizedBox(),
        ),
      );
      expect(
        find.textContaining("Hotel Mode isn't turned on at this branch yet."),
        findsOneWidget,
      );
      expect(find.textContaining("You don't have access"), findsNothing);
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

    testWidgets('holds a scrim while the desk is judged, then refuses', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final lookup = Completer<bool?>();
      var taps = 0;
      await _pump(
        tester,
        ServiceModeDesk(
          deskAdmin: () => lookup.future,
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('SELL'),
          ),
        ),
      );
      final switching = cycleServiceMode();
      await tester.pump(const Duration(milliseconds: 200));
      expect(_scrim, findsOneWidget);
      expect(find.text('Switching mode…'), findsOneWidget);
      // The scrim takes the taps meant for the desk under it.
      await tester.tap(find.text('SELL'), warnIfMissed: false);
      expect(taps, 0);

      lookup.complete(false);
      await _finish(tester, switching);
      await tester.pump();
      expect(_scrim, findsNothing);
      expect(
        find.text("Only an admin can switch this device's service mode."),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('keys and scans do not reach the desk while it switches', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final lookup = Completer<bool?>();
      final field = FocusNode();
      addTearDown(field.dispose);
      final reached = <LogicalKeyboardKey>[];
      await _pump(
        tester,
        ServiceModeDesk(
          deskAdmin: () => lookup.future,
          // The POS search box a scanner types into.
          child: Focus(
            onKeyEvent: (_, event) {
              if (event is KeyDownEvent) reached.add(event.logicalKey);
              return KeyEventResult.ignored;
            },
            child: TextField(focusNode: field),
          ),
        ),
      );
      field.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      expect(reached, [LogicalKeyboardKey.keyA]);
      reached.clear();

      final switching = cycleServiceMode();
      await tester.pump(const Duration(milliseconds: 200));
      expect(_scrim, findsOneWidget);
      // The field gives up focus, and a scan (keys, then Enter) is eaten.
      expect(field.hasFocus, isFalse);
      for (final key in [
        LogicalKeyboardKey.digit6,
        LogicalKeyboardKey.digit0,
        LogicalKeyboardKey.enter,
      ]) {
        expect(await tester.sendKeyEvent(key), isTrue);
      }
      expect(reached, isEmpty);

      // Refused: the scrim goes, the field gets its focus and keys back.
      lookup.complete(false);
      await _finish(tester, switching);
      await tester.pump();
      expect(_scrim, findsNothing);
      expect(field.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      expect(reached, [LogicalKeyboardKey.keyB]);
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

      Widget books(ServiceMode target) => ServiceModeDesk(
        target: () => target,
        onLeave: () => did.add('leave'),
        child: const SizedBox(),
      );

      testWidgets('from Books: saves, leaves Books, then lands', (
        tester,
      ) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return true;
        };
        await press(tester, books(ServiceMode.hotel));
        expect(did, ['apply hotel', 'leave', 'open hotel']);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('from Books back to the mode it runs: no switch to save', (
        tester,
      ) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return true;
        };
        // Nothing picked and no service offered: this device runs POS.
        await press(tester, books(ServiceMode.pos));
        expect(did, ['leave', 'open pos']);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('from Books, a switch that rolled back stays in Books', (
        tester,
      ) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return false;
        };
        await press(tester, books(ServiceMode.bar));
        expect(did, ['apply bar']);
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

      Future<Completer<bool>> pending(WidgetTester tester) async {
        tester.view.physicalSize = const Size(1600, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final apply = Completer<bool>();
        serviceModeHotkeyApply = (mode) {
          did.add('apply ${mode.name}');
          return apply.future;
        };
        await _pump(tester, _desk(true));
        return apply;
      }

      testWidgets('says where it is going until the new mode is up', (
        tester,
      ) async {
        final apply = await pending(tester);
        final switching = cycleServiceMode();
        await tester.pump(const Duration(milliseconds: 200));
        expect(_scrim, findsOneWidget);
        expect(find.text('Switching to Bar Mode…'), findsOneWidget);

        // Pressed again while it switches: swallowed, still one scrim.
        await cycleServiceMode();
        await tester.pump();
        expect(_scrim, findsOneWidget);
        expect(did, ['apply bar']);

        apply.complete(true);
        await _finish(tester, switching);
        await tester.pump();
        expect(_scrim, findsNothing);
        expect(did, ['apply bar', 'open bar']);
        expect(find.textContaining('This device switched to'), findsOneWidget);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('a switch that fails takes the scrim down and says so', (
        tester,
      ) async {
        final apply = await pending(tester);
        final switching = cycleServiceMode();
        await tester.pump(const Duration(milliseconds: 200));
        expect(_scrim, findsOneWidget);

        apply.completeError(StateError('offline'));
        await _finish(tester, switching);
        await tester.pump();
        expect(_scrim, findsNothing);
        expect(find.text('Could not switch service mode.'), findsOneWidget);
        expect(did, ['apply bar']);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('the scrim never outlasts its cap', (tester) async {
        final apply = await pending(tester);
        final switching = cycleServiceMode();
        await tester.pump(const Duration(milliseconds: 200));
        expect(_scrim, findsOneWidget);

        await tester.pump(serviceModeSwitchingOverlayCap);
        expect(_scrim, findsNothing);

        apply.complete(true);
        await _finish(tester, switching);
        await tester.pump();
        expect(_scrim, findsNothing);
        expect(did, ['apply bar', 'open bar']);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('the cap firing before the pick resolves: no relabel', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1600, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return true;
        };
        final lookup = Completer<bool?>();
        await _pump(
          tester,
          ServiceModeDesk(
            deskAdmin: () => lookup.future,
            child: const Text(''),
          ),
        );
        final switching = cycleServiceMode();
        await tester.pump(serviceModeSwitchingOverlayCap);
        expect(_scrim, findsNothing);

        lookup.complete(true);
        await _finish(tester, switching);
        expect(_scrim, findsNothing);
        expect(did, ['apply bar', 'open bar']);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      });

      testWidgets('with no root navigator: switches without a scrim', (
        tester,
      ) async {
        serviceModeHotkeyApply = (mode) async {
          did.add('apply ${mode.name}');
          return true;
        };
        await tester.pumpWidget(MaterialApp(home: _desk(true)));
        await _finish(tester, cycleServiceMode());
        expect(_scrim, findsNothing);
        expect(did, ['apply bar', 'open bar']);
      });
    });
  });

  group('pickPermittedServiceMode', () {
    Future<ServiceMode?> pick({
      ServiceMode current = ServiceMode.pos,
      Set<ServiceMode> mayRun = const {...ServiceMode.values},
      Set<ServiceMode> offered = const {...ServiceMode.values},
      bool? admin = false,
      List<String>? asked,
    }) => pickPermittedServiceMode(
      current: current,
      mayRun: mayRun.contains,
      offered: (mode) => mode == ServiceMode.pos || offered.contains(mode),
      isAdmin: () {
        asked?.add('admin');
        return admin;
      },
    );

    test('goes to the next mode in the hotkey order', () async {
      expect(await pick(), ServiceMode.bar);
      expect(await pick(current: ServiceMode.bar), ServiceMode.hotel);
      expect(await pick(current: ServiceMode.hotel), ServiceMode.pos);
    });

    test('skips a mode the user holds no grant for', () async {
      expect(
        await pick(mayRun: {ServiceMode.pos, ServiceMode.hotel}),
        ServiceMode.hotel,
      );
    });

    test('a mode the branch does not offer: admins only', () async {
      final asked = <String>[];
      expect(
        await pick(offered: {ServiceMode.hotel}, asked: asked),
        ServiceMode.hotel,
      );
      // Asked once, for the Bar, and not again for later modes.
      expect(asked, ['admin']);
      expect(await pick(offered: const {}, admin: true), ServiceMode.bar);
      // Nobody signed in counts as not an admin.
      expect(await pick(offered: const {}, admin: null), ServiceMode.pos);
    });

    test('with nothing else allowed, back to the mode it runs', () async {
      expect(
        await pick(current: ServiceMode.bar, mayRun: {ServiceMode.bar}),
        ServiceMode.bar,
      );
    });

    test('none allowed: null', () async {
      expect(await pick(mayRun: const {}), isNull);
    });
  });

  group('grantedServiceModeOff', () {
    ServiceMode? off({
      Set<ServiceMode> mayRun = const {...ServiceMode.values},
      Set<ServiceMode> offered = const {},
    }) => grantedServiceModeOff(
      mayRun: mayRun.contains,
      offered: (mode) => mode == ServiceMode.pos || offered.contains(mode),
    );

    test('the first held service the branch does not run', () {
      expect(off(), ServiceMode.bar);
      expect(off(offered: {ServiceMode.bar}), ServiceMode.hotel);
      expect(off(mayRun: {ServiceMode.hotel}), ServiceMode.hotel);
    });

    test('none when every held service runs, or none is held', () {
      expect(off(offered: {ServiceMode.bar, ServiceMode.hotel}), isNull);
      expect(off(mayRun: {ServiceMode.pos}), isNull);
      expect(off(mayRun: const {}), isNull);
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
