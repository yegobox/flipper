import 'dart:convert';

import 'package:flipper_dashboard/features/branch_location/branch_location_backfill.dart';
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockBox extends Mock implements LocalStorage {}

class _MockStrategy extends Mock implements DatabaseSyncInterface {}

class _MockLocation extends Mock implements FlipperLocation {}

class _MockHttp extends Mock implements HttpClientInterface {}

class _FakeServices extends BranchServices {
  _FakeServices({required this.remote, this.android = true});

  final Branch? remote;
  final bool android;
  final _MockBox mockBox = _MockBox();
  final _MockStrategy mockStrategy = _MockStrategy();
  final _MockLocation mockLocation = _MockLocation();
  final _MockHttp mockHttp = _MockHttp();

  @override
  LocalStorage get box => mockBox;
  @override
  DatabaseSyncInterface get strategy => mockStrategy;
  @override
  FlipperLocation get location => mockLocation;
  @override
  HttpClientInterface get http => mockHttp;
  @override
  bool get isAndroid => android;
  @override
  Future<Branch?> remoteBranch(String branchId) async => remote;
}

_FakeServices _services({
  Branch? remote,
  bool android = true,
  bool admin = true,
  String? snoozes,
}) {
  final s = _FakeServices(
    remote:
        remote ??
        Branch(id: 'b1', name: 'Kimironko', latitude: 1, longitude: 1),
    android: android,
  );
  when(() => s.mockBox.getBranchId()).thenReturn('b1');
  when(() => s.mockBox.getUserId()).thenReturn('u1');
  when(() => s.mockBox.readString(key: any(named: 'key'))).thenReturn(snoozes);
  when(
    () => s.mockBox.writeString(
      key: any(named: 'key'),
      value: any(named: 'value'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => s.mockStrategy.isAdmin(
      userId: any(named: 'userId'),
      appFeature: any(named: 'appFeature'),
    ),
  ).thenAnswer((_) async => admin);
  when(
    () => s.mockStrategy.updateBranchCoordinates(
      branchId: any(named: 'branchId'),
      latitude: any(named: 'latitude'),
      longitude: any(named: 'longitude'),
      flipperHttpClient: any(named: 'flipperHttpClient'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => s.mockLocation.currentPosition(timeout: any(named: 'timeout')),
  ).thenAnswer(
    (_) async =>
        const LocationOutcome.fix(latitude: -1.9441, longitude: 30.0619),
  );
  when(
    () => s.mockLocation.openSettingsFor(any()),
  ).thenAnswer((_) async => true);
  return s;
}

/// Days until the snooze written for branch b1 expires (rounded down).
int _snoozedDays(_FakeServices s) {
  final written =
      verify(
            () => s.mockBox.writeString(
              key: 'branchLocationPromptSnooze',
              value: captureAny(named: 'value'),
            ),
          ).captured.single
          as String;
  final until = DateTime.parse(
    (jsonDecode(written) as Map<String, dynamic>)['b1'] as String,
  );
  return until.difference(DateTime.now()).inDays;
}

/// Answers the prompt with "Save location" while GPS fails with [failure];
/// leaves the failure dialog open and returns the still-pending run.
Future<(_FakeServices, Future<void>)> _saveWithFailure(
  WidgetTester tester,
  LocationFailure failure,
) async {
  final s = _services();
  _gpsAnswers(s, [LocationOutcome.failed(failure)]);
  final (:run) = await _start(tester, s);
  await tester.tap(find.text('Save location'));
  await tester.pumpAndSettle();
  _expectNoUpdate(s);
  return (s, run);
}

/// GPS answers in turn; the last one repeats.
void _gpsAnswers(_FakeServices s, List<LocationOutcome> answers) {
  var calls = 0;
  when(
    () => s.mockLocation.currentPosition(timeout: any(named: 'timeout')),
  ).thenAnswer((_) async => answers[(calls++).clamp(0, answers.length - 1)]);
}

const _fix = LocationOutcome.fix(latitude: -1.9441, longitude: 30.0619);

/// The user leaves for the settings app and comes back.
Future<void> _backFromSettings(WidgetTester tester) async {
  for (final state in const [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(state);
  }
  await tester.pumpAndSettle();
}

void _expectNoSnooze(_FakeServices s) {
  verifyNever(
    () => s.mockBox.writeString(
      key: any(named: 'key'),
      value: any(named: 'value'),
    ),
  );
}

void _expectSaved(_FakeServices s) {
  verify(
    () => s.mockStrategy.updateBranchCoordinates(
      branchId: 'b1',
      latitude: -1.9441,
      longitude: 30.0619,
      flipperHttpClient: s.mockHttp,
    ),
  ).called(1);
}

/// Pumps an app and starts the prompt from inside it; returns the pending run
/// (wrapped, since an async function would flatten a bare Future).
Future<({Future<void> run})> _start(
  WidgetTester tester,
  BranchServices services,
) async {
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  final run = maybePromptBranchLocationBackfill(ctx, services);
  await tester.pumpAndSettle();
  return (run: run);
}

void _expectNoUpdate(_FakeServices s) {
  verifyNever(
    () => s.mockStrategy.updateBranchCoordinates(
      branchId: any(named: 'branchId'),
      latitude: any(named: 'latitude'),
      longitude: any(named: 'longitude'),
      flipperHttpClient: any(named: 'flipperHttpClient'),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(0.0);
    registerFallbackValue(_MockHttp());
    registerFallbackValue(LocationFailure.unavailable);
  });

  testWidgets('saves the GPS position when the admin confirms', (tester) async {
    final s = _services();
    final (:run) = await _start(tester, s);

    expect(find.text('Where is Kimironko?'), findsOneWidget);
    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();
    await run;

    verify(
      () => s.mockStrategy.updateBranchCoordinates(
        branchId: 'b1',
        latitude: -1.9441,
        longitude: 30.0619,
        flipperHttpClient: s.mockHttp,
      ),
    ).called(1);
    expect(find.text('Branch location saved'), findsOneWidget);
  });

  testWidgets('"Not now" snoozes the branch for a week', (tester) async {
    final s = _services();
    final (:run) = await _start(tester, s);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    await run;

    _expectNoUpdate(s);
    expect(_snoozedDays(s), 6);
  });

  group('when GPS fails', () {
    testWidgets('no fix: keeps a dialog with settings until the user picks', (
      tester,
    ) async {
      final (s, run) = await _saveWithFailure(
        tester,
        LocationFailure.unavailable,
      );
      expect(find.textContaining("Couldn't get your location"), findsOneWidget);
      expect(find.text('Open settings'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      _expectNoSnooze(s);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      await run;
      expect(_snoozedDays(s), 0);
    });

    testWidgets('no fix: "Open settings" opens location settings', (
      tester,
    ) async {
      final (s, run) = await _saveWithFailure(
        tester,
        LocationFailure.unavailable,
      );
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      await run;
      verify(
        () => s.mockLocation.openSettingsFor(LocationFailure.unavailable),
      ).called(1);

      _gpsAnswers(s, [_fix]);
      await _backFromSettings(tester);
      _expectSaved(s);
    });

    testWidgets('"Try again" saves once a fix arrives', (tester) async {
      final s = _services();
      _gpsAnswers(s, [
        const LocationOutcome.failed(LocationFailure.unavailable),
        _fix,
      ]);
      final (:run) = await _start(tester, s);
      await tester.tap(find.text('Save location'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      await run;

      _expectSaved(s);
      expect(find.text('Branch location saved'), findsOneWidget);
      _expectNoSnooze(s);
    });

    testWidgets('saves on its own when the user is back from settings', (
      tester,
    ) async {
      final (s, run) = await _saveWithFailure(
        tester,
        LocationFailure.deniedForever,
      );
      expect(find.textContaining('blocked for Flipper'), findsOneWidget);
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      await run;
      verify(
        () => s.mockLocation.openSettingsFor(LocationFailure.deniedForever),
      ).called(1);
      _expectNoUpdate(s);
      // Nothing snoozed while away: if Android kills Flipper meanwhile, the
      // prompt comes back at the next start.
      _expectNoSnooze(s);

      // Location allowed in settings; Flipper comes back to the front.
      _gpsAnswers(s, [_fix]);
      await _backFromSettings(tester);

      _expectSaved(s);
      expect(find.text('Branch location saved'), findsOneWidget);
    });

    testWidgets('asks again if it still has no fix after settings', (
      tester,
    ) async {
      final (s, run) = await _saveWithFailure(
        tester,
        LocationFailure.serviceDisabled,
      );
      expect(find.textContaining('Location is turned off'), findsOneWidget);
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      await run;
      verify(
        () => s.mockLocation.openSettingsFor(LocationFailure.serviceDisabled),
      ).called(1);

      await _backFromSettings(tester);
      expect(find.textContaining('Location is turned off'), findsOneWidget);
      _expectNoUpdate(s);

      // A later resume does nothing more: the wait fired once.
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      await _backFromSettings(tester);
      expect(find.byType(AlertDialog), findsNothing);
      expect(_snoozedDays(s), 0);
    });

    testWidgets('snoozes a day when no settings screen opens', (tester) async {
      final (s, run) = await _saveWithFailure(
        tester,
        LocationFailure.unavailable,
      );
      when(
        () => s.mockLocation.openSettingsFor(any()),
      ).thenAnswer((_) async => false);
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      await run;
      expect(_snoozedDays(s), 0);

      await _backFromSettings(tester);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('treats a refused permission dialog like "Not now"', (
      tester,
    ) async {
      final (s, run) = await _saveWithFailure(tester, LocationFailure.denied);
      expect(
        find.textContaining("wasn't allowed to use your location"),
        findsOneWidget,
      );
      // Asking again still shows the system dialog, so no settings button.
      expect(find.text('Open settings'), findsNothing);
      expect(find.text('Try again'), findsOneWidget);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      await run;
      expect(_snoozedDays(s), 6);
    });
  });

  group('stays quiet', () {
    Future<void> expectNoPrompt(WidgetTester tester, _FakeServices s) async {
      final (:run) = await _start(tester, s);
      await run;
      expect(find.byType(AlertDialog), findsNothing);
      _expectNoUpdate(s);
    }

    testWidgets('off Android', (tester) async {
      await expectNoPrompt(tester, _services(android: false));
    });

    testWidgets('for a non-admin', (tester) async {
      await expectNoPrompt(tester, _services(admin: false));
    });

    testWidgets('when the branch already has a real location', (tester) async {
      await expectNoPrompt(
        tester,
        _services(
          remote: Branch(
            id: 'b1',
            name: 'Kimironko',
            latitude: -1.95,
            longitude: 30.12,
          ),
        ),
      );
    });

    testWidgets('while snoozed', (tester) async {
      final until = DateTime.now().add(const Duration(days: 2));
      await expectNoPrompt(
        tester,
        _services(snoozes: jsonEncode({'b1': until.toIso8601String()})),
      );
    });
  });
}
