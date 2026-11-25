import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_location_picker.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/place_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocation extends Mock implements FlipperLocation {}

class _FakePlaces implements PlaceSearch {
  final searched = <String>[];

  @override
  Future<List<PlaceResult>> search(String query) async {
    searched.add(query);
    return const [
      PlaceResult(
        label: 'Kimironko Market, KG 11 Ave, Kimironko',
        latitude: -1.9500,
        longitude: 30.1260,
      ),
    ];
  }

  @override
  Future<String?> addressAt(double latitude, double longitude) async =>
      'KG 11 Ave, Kimironko, Gasabo';
}

const _fix = LocationOutcome.fix(
  latitude: -1.9441,
  longitude: 30.0619,
  accuracy: 12,
);

_MockLocation _location({bool allowed = false}) {
  final location = _MockLocation();
  when(() => location.hasLocationPermission()).thenAnswer((_) async => allowed);
  when(
    () => location.currentPosition(timeout: any(named: 'timeout')),
  ).thenAnswer((_) async => _fix);
  when(() => location.openSettingsFor(any())).thenAnswer((_) async => true);
  return location;
}

/// Opens the picker in an app of [size]; `result()` reads what it returned.
Future<BranchLocationPick? Function()> _open(
  WidgetTester tester, {
  required FlipperLocation location,
  PlaceSearch? places,
  Size size = const Size(1400, 1000),
  num? latitude,
  num? longitude,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  BranchLocationPick? picked;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              picked = await showBranchLocationPicker(
                context,
                location: location,
                places: places ?? _FakePlaces(),
                latitude: latitude,
                longitude: longitude,
                loadTiles: false,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return () => picked;
}

/// Lets the debounced address lookup run.
Future<void> _settleLookup(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

FilledButton _saveButton(WidgetTester tester) => tester.widget<FilledButton>(
  find.ancestor(
    of: find.text('Save location'),
    matching: find.byWidgetPredicate((w) => w is FilledButton),
  ),
);

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

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(LocationFailure.unavailable);
  });

  testWidgets('cannot save the default view before a spot is chosen', (
    tester,
  ) async {
    await _open(tester, location: _location());

    expect(
      find.text('Drag the map so the pin sits on the branch.'),
      findsOneWidget,
    );
    expect(_saveButton(tester).onPressed, isNull);
  });

  testWidgets('"my location" pins the GPS fix with its accuracy and address', (
    tester,
  ) async {
    final result = await _open(tester, location: _location());

    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pump();
    await _settleLookup(tester);

    expect(find.text('KG 11 Ave, Kimironko, Gasabo'), findsOneWidget);
    expect(find.textContaining('Accurate to about 12 m'), findsOneWidget);

    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();
    expect(result()!.latitude, closeTo(-1.9441, 1e-6));
    expect(result()!.longitude, closeTo(30.0619, 1e-6));
    expect(result()!.address, 'KG 11 Ave, Kimironko, Gasabo');
  });

  testWidgets('jumps to the device on open when permission is already given', (
    tester,
  ) async {
    final location = _location(allowed: true);
    await _open(tester, location: location);
    await _settleLookup(tester);

    verify(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).called(1);
    expect(_saveButton(tester).onPressed, isNotNull);
  });

  testWidgets('search moves the pin to the chosen place', (tester) async {
    final places = _FakePlaces();
    final result = await _open(tester, location: _location(), places: places);

    await tester.enterText(find.byType(TextField), 'kimironko market');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(places.searched, ['kimironko market']);

    await tester.tap(find.text('Kimironko Market, KG 11 Ave, Kimironko'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();

    expect(result()!.latitude, closeTo(-1.95, 1e-6));
    expect(result()!.longitude, closeTo(30.126, 1e-6));
    expect(result()!.address, 'Kimironko Market, KG 11 Ave, Kimironko');
  });

  testWidgets('opens on an existing location, ready to save', (tester) async {
    final result = await _open(
      tester,
      location: _location(),
      latitude: -1.95,
      longitude: 30.12,
    );
    await _settleLookup(tester);

    expect(find.text('KG 11 Ave, Kimironko, Gasabo'), findsOneWidget);
    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();
    expect(result()!.latitude, closeTo(-1.95, 1e-6));
    expect(result()!.longitude, closeTo(30.12, 1e-6));
  });

  testWidgets('a blocked permission explains itself and links to settings', (
    tester,
  ) async {
    final location = _location();
    when(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer(
      (_) async => const LocationOutcome.failed(LocationFailure.deniedForever),
    );
    await _open(tester, location: location);

    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pumpAndSettle();

    expect(find.textContaining('blocked for Flipper'), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    verify(
      () => location.openSettingsFor(LocationFailure.deniedForever),
    ).called(1);
  });

  testWidgets('no fix links to settings and locates again on return', (
    tester,
  ) async {
    final location = _location();
    var calls = 0;
    when(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer(
      (_) async => calls++ == 0
          ? const LocationOutcome.failed(LocationFailure.unavailable)
          : _fix,
    );
    await _open(tester, location: location);

    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't get your location"), findsOneWidget);

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    verify(
      () => location.openSettingsFor(LocationFailure.unavailable),
    ).called(1);

    // Back from the settings app: the position is read again.
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

    expect(calls, 2);
    expect(find.textContaining("Couldn't get your location"), findsNothing);
    expect(find.textContaining('Accurate to about 12 m'), findsOneWidget);
  });

  testWidgets('a pin placed while the fix is on the way is kept', (
    tester,
  ) async {
    final location = _location();
    final pending = Completer<LocationOutcome>();
    when(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer((_) => pending.future);
    final result = await _open(tester, location: location);

    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pump();

    // The user searches and picks a place before GPS answers. The locating
    // spinner never settles while the read is pending, so pump fixed steps.
    await tester.enterText(find.byType(TextField), 'kimironko market');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Kimironko Market, KG 11 Ave, Kimironko'));
    await tester.pump(const Duration(seconds: 2));

    pending.complete(_fix);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save location'));
    await tester.pumpAndSettle();
    expect(result()!.latitude, closeTo(-1.95, 1e-6));
    expect(result()!.longitude, closeTo(30.126, 1e-6));
  });

  testWidgets('an automatic GPS pin still allows a retry after settings', (
    tester,
  ) async {
    final location = _location(allowed: true);
    var calls = 0;
    when(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer(
      (_) async => switch (calls++) {
        1 => const LocationOutcome.failed(LocationFailure.unavailable),
        _ => _fix,
      },
    );
    // Opens on the GPS fix (permission already given): a pin, not by hand.
    await _open(tester, location: location);
    expect(calls, 1);

    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't get your location"), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    await _backFromSettings(tester);
    expect(calls, 3);
    expect(find.textContaining("Couldn't get your location"), findsNothing);
  });

  testWidgets('no retry after settings if the user placed the pin meanwhile', (
    tester,
  ) async {
    final location = _location();
    var calls = 0;
    when(
      () => location.currentPosition(timeout: any(named: 'timeout')),
    ).thenAnswer((_) async {
      calls++;
      return const LocationOutcome.failed(LocationFailure.unavailable);
    });
    await _open(tester, location: location);
    await tester.tap(find.byKey(const Key('branchLocationLocate')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'kimironko market');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kimironko Market, KG 11 Ave, Kimironko'));
    await tester.pumpAndSettle();

    await _backFromSettings(tester);
    expect(calls, 1);
  });

  group('onNextAppResume', () {
    Future<void> resume(WidgetTester tester) async {
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
      await tester.pump();
    }

    testWidgets('runs once on the next return', (tester) async {
      var returns = 0;
      onNextAppResume(() => returns++);
      await resume(tester);
      await resume(tester);
      expect(returns, 1);
    });

    testWidgets('ignores a return after it gave up', (tester) async {
      var now = DateTime(2026, 11, 25, 9);
      var returns = 0;
      onNextAppResume(
        () => returns++,
        giveUpAfter: const Duration(minutes: 10),
        now: () => now,
      );
      now = now.add(const Duration(minutes: 11));
      await resume(tester);
      expect(returns, 0);

      // And it is gone: a later return does nothing either.
      await resume(tester);
      expect(returns, 0);
    });

    testWidgets('cancel stops it', (tester) async {
      var returns = 0;
      onNextAppResume(() => returns++)();
      await resume(tester);
      expect(returns, 0);
    });
  });

  testWidgets('takes the whole screen on a phone', (tester) async {
    await _open(
      tester,
      location: _location(),
      size: const Size(390, 844),
      latitude: -1.95,
      longitude: 30.12,
    );
    await _settleLookup(tester);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);
    // Full-width save button under the address.
    final button = find.ancestor(
      of: find.text('Save location'),
      matching: find.byWidgetPredicate((w) => w is FilledButton),
    );
    expect(tester.getSize(button).width, greaterThan(300));
  });
}
