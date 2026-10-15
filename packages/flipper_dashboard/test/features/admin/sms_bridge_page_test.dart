import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Pairs on demand; a phone "claims" the code once [claim] is called.
class _FakeBridge extends SmsBridgeClient {
  _FakeBridge({this.validFor = const Duration(minutes: 10)})
    : super(baseUrl: () async => 'https://unused.test/');

  final Duration validFor;

  /// The page's clock; tests move it to expire a code.
  DateTime now = DateTime(2026, 10, 14, 9);
  int pairings = 0;
  bool _claimed = false;

  void claim() => _claimed = true;

  @override
  Future<SmsBridgePairing> createPairing({String? label}) async {
    pairings++;
    return SmsBridgePairing(
      code: '7K3QMZ9TXA',
      displayCode: '7K3QM-Z9TXA',
      expiresAt: now.add(validFor),
      qrPayload: smsBridgeQrPayload(
        baseUrl: 'https://unused.test/',
        code: '7K3QMZ9TXA',
      ),
    );
  }

  @override
  Future<List<SmsBridgeDevice>> listDevices() async => [
    const SmsBridgeDevice(deviceId: 'old', label: 'Tecno Spark'),
    if (_claimed) const SmsBridgeDevice(deviceId: 'new', label: 'Infinix Hot'),
  ];

  @override
  Future<void> revoke(String deviceId) async {}
}

Future<void> _pump(
  WidgetTester tester,
  _FakeBridge fake, {
  bool canOpenHere = false,
}) async {
  // Tall enough that the whole page fits: the test font wraps much wider
  // than a real one.
  tester.view.physicalSize = const Size(1080, 6000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [smsBridgeClientProvider.overrideWithValue(fake)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: SmsBridgePage(
          canOpenOnThisPhone: canOpenHere,
          now: () => fake.now,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late List<String> copied;

  setUp(() {
    copied = [];
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        });
  });

  testWidgets('step 1 offers the download as a QR code and a link', (
    tester,
  ) async {
    await _pump(tester, _FakeBridge());
    expect(find.byKey(const Key('sms_bridge_download_qr')), findsOneWidget);
    await tester.tap(find.byKey(const Key('sms_bridge_copy_link')));
    await tester.pumpAndSettle();
    expect(copied, [kSmsBridgeDownloadUrl]);
    expect(find.text('Copied'), findsOneWidget);
  });

  testWidgets('a code counts down and can be copied', (tester) async {
    final fake = _FakeBridge();
    await _pump(tester, fake);
    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();

    expect(fake.pairings, 1);
    expect(find.byKey(const Key('sms_bridge_qr')), findsOneWidget);
    expect(find.text('7K3QM-Z9TXA'), findsOneWidget);
    expect(find.textContaining('Expires in 10:00'), findsOneWidget);
    fake.now = fake.now.add(const Duration(seconds: 75));
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('Expires in 8:45'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_bridge_copy_code')));
    await tester.pumpAndSettle();
    expect(copied, ['7K3QM-Z9TXA']);
  });

  testWidgets('the page notices the phone pairing by itself', (tester) async {
    final fake = _FakeBridge();
    await _pump(tester, fake);
    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();

    // A poll before the phone claims the code changes nothing.
    await tester.pump(kSmsBridgePairPoll);
    expect(find.byKey(const Key('sms_bridge_paired')), findsNothing);

    fake.claim();
    await tester.pump(kSmsBridgePairPoll);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_bridge_paired')), findsOneWidget);
    expect(find.text('Infinix Hot is paired'), findsOneWidget);
    expect(find.byKey(const Key('sms_bridge_qr')), findsNothing);
    // The phone already paired before is not mistaken for the new one.
    expect(find.text('Tecno Spark is paired'), findsNothing);
  });

  testWidgets('an expired code asks for a new one', (tester) async {
    final fake = _FakeBridge(validFor: const Duration(seconds: 2));
    await _pump(tester, fake);
    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();
    expect(find.text('This code has expired.'), findsNothing);

    fake.now = fake.now.add(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('This code has expired.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_bridge_new_code')));
    await tester.pumpAndSettle();
    expect(fake.pairings, 2);
  });

  testWidgets('"Open on this phone" only where the bridge can run', (
    tester,
  ) async {
    await _pump(tester, _FakeBridge(), canOpenHere: true);
    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_bridge_open_here')), findsOneWidget);
  });

  testWidgets('no "Open on this phone" on a computer', (tester) async {
    await _pump(tester, _FakeBridge());
    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_bridge_open_here')), findsNothing);
  });
}
