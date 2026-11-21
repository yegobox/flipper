import 'dart:async';

import 'package:flipper_ai_feature/src/providers/whatsapp_connection_provider.dart';
import 'package:flipper_ai_feature/src/services/whatsapp_connection_service.dart';
import 'package:flipper_ai_feature/src/theme/flo_theme.dart';
import 'package:flipper_ai_feature/src/widgets/whatsapp_connection_dialog.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'ink_free_button_finders.dart';

class _MockConnectionService extends Mock
    implements WhatsAppConnectionService {}

void main() {
  late _MockConnectionService service;

  setUp(() {
    service = _MockConnectionService();
  });

  Future<void> openDialog(
    WidgetTester tester, {
    VoidCallback? onConnectionChanged,
  }) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          whatsAppConnectionServiceProvider.overrideWithValue(service),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => WhatsAppConnectionDialog(
                    onConnectionChanged: onConnectionChanged,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets(
      'error view: Try Again paints a gradient and reloads the connection',
      (tester) async {
    var calls = 0;
    when(() => service.getConnectionState()).thenAnswer((_) async {
      calls++;
      if (calls == 1) throw Exception('business not found');
      return const WhatsAppConnectionState();
    });

    await openDialog(tester);

    expect(find.text('Connection Error'), findsOneWidget);
    expect(find.textContaining('business not found'), findsOneWidget);

    final tryAgain = find.text('Try Again');
    expectPaintedByContainer(tester, tryAgain);
    expect(backgroundOf(tester, tryAgain).gradient, FloTheme.gradBtn);

    await tester.tap(tryAgain);
    await tester.pump();
    await tester.pump();

    verify(() => service.getConnectionState()).called(2);
    expect(find.text('Connection Error'), findsNothing);
    expect(find.text('Connect WhatsApp'), findsOneWidget);
  });

  testWidgets(
      'connect button: gradient when idle, grey with a spinner while '
      'connecting, closes the dialog once connected', (tester) async {
    when(() => service.getConnectionState())
        .thenAnswer((_) async => const WhatsAppConnectionState());
    final connecting = Completer<WhatsAppConnectionState>();
    when(() => service.connect(any())).thenAnswer((_) => connecting.future);
    var changed = 0;

    await openDialog(tester, onConnectionChanged: () => changed++);

    final connect = find.text('Connect WhatsApp');
    expectPaintedByContainer(tester, connect);
    final idle = backgroundOf(tester, connect);
    expect(idle.gradient, FloTheme.gradBtn);
    expect(idle.color, isNull);
    expect(idle.boxShadow, const [FloTheme.shBlue]);

    await tester.enterText(find.byType(TextField), '123456789');
    await tester.tap(connect);
    await tester.pump();

    verify(() => service.connect('123456789')).called(1);
    // While connecting the label gives way to a spinner on a grey button.
    expect(find.text('Connect WhatsApp'), findsNothing);
    final spinner = find.descendant(
      of: find.byType(WhatsAppConnectionDialog),
      matching: find.byType(CircularProgressIndicator),
    );
    expect(spinner, findsOneWidget);
    expectPaintedByContainer(tester, spinner);
    final busy = backgroundOf(tester, spinner);
    expect(busy.gradient, isNull);
    expect(busy.color, FloTheme.lineStrong);
    expect(busy.boxShadow, isNull);
    expect(tester.widget<InkWell>(buttonInkWell(spinner)).onTap, isNull);

    connecting.complete(
      const WhatsAppConnectionState(
        isConnected: true,
        phoneNumberId: '123456789',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(changed, 1);
    expect(find.byType(WhatsAppConnectionDialog), findsNothing);

    // Let the success snackbar run out.
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 1));
  });
}
