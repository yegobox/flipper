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
  ).thenAnswer((_) async => (latitude: -1.9441, longitude: 30.0619));
  return s;
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
    expect(until.difference(DateTime.now()).inDays, 6);
  });

  testWidgets('does not save when the position is unavailable', (tester) async {
    final s = _services();
    when(
      () => s.mockLocation.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer((_) async => null);
    final (:run) = await _start(tester, s);

    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();
    await run;

    _expectNoUpdate(s);
    expect(find.textContaining("Couldn't get your location"), findsOneWidget);
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
