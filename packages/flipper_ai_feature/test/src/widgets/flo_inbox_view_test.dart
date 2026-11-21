import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flipper_ai_feature/src/providers/whatsapp_message_provider.dart';
import 'package:flipper_ai_feature/src/services/flo_chat_service.dart';
import 'package:flipper_ai_feature/src/theme/flo_theme.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_inbox_view.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/whatsapp_ditto_inbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ink_free_button_finders.dart';

/// Records the save request and answers it when the test says so.
class _FakeFilePicker extends FilePicker {
  _FakeFilePicker(this.answer);

  final Completer<String?> answer;
  String? savedName;
  Uint8List? savedBytes;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) {
    savedName = fileName;
    savedBytes = bytes;
    return answer.future;
  }
}

const _waId = '250788000001';
final _pdfBytes = Uint8List.fromList(utf8.encode('%PDF-1.4 test'));

WhatsAppDittoMessage _pdf({required String id, required bool outbound}) =>
    WhatsAppDittoMessage(
      id: id,
      phoneNumberId: 'pn-1',
      waId: _waId,
      from: outbound ? 'pn-1' : _waId,
      body: 'invoice.pdf',
      messageType: 'document',
      timestamp: DateTime(2026, 11, 21, 10, 30),
      outbound: outbound,
      filename: 'invoice.pdf',
      mimeType: 'application/pdf',
      mediaBase64: base64Encode(_pdfBytes),
    );

void main() {
  Future<void> pumpInbox(
    WidgetTester tester, {
    required bool connected,
    VoidCallback? onConnect,
    List<WhatsAppDittoThread> threads = const [],
  }) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          whatsappDittoThreadsProvider.overrideWith(
            (ref) => Stream.value(threads),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: FloInboxView(
              connected: connected,
              onConnect: onConnect ?? () {},
              chatService: FloChatService(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets(
      'locked inbox: the Connect button paints its gradient and calls '
      'onConnect', (tester) async {
    var connects = 0;
    await pumpInbox(tester, connected: false, onConnect: () => connects++);

    final connect = find.text('Connect WhatsApp');
    expect(connect, findsOneWidget);
    expectPaintedByContainer(tester, connect);
    final bg = backgroundOf(tester, connect);
    expect(bg.gradient, FloTheme.gradBtn);
    expect(bg.boxShadow, const [FloTheme.shBlue]);
    expect(bg.borderRadius, BorderRadius.circular(FloTheme.radiusMd));

    await tester.tap(connect);
    await tester.pump();
    expect(connects, 1);
  });

  testWidgets(
      'thread: PDF cards and the send button paint their own backgrounds; '
      'tapping a PDF saves it, with a spinner while it is busy',
      (tester) async {
    final picker = _FakeFilePicker(Completer<String?>());
    FilePicker.platform = picker;

    await pumpInbox(
      tester,
      connected: true,
      threads: [
        WhatsAppDittoThread(
          waId: _waId,
          displayName: 'Aline',
          messages: [
            _pdf(id: 'in-1', outbound: false),
            _pdf(id: 'out-1', outbound: true),
          ],
        ),
      ],
    );

    await tester.tap(find.text('Aline').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Inbound card on the white bubble, outbound card on the blue one.
    final cards = find.text('PDF document');
    expect(cards, findsNWidgets(2));
    final inbound = cards.at(0);
    final outbound = cards.at(1);
    expectPaintedByContainer(tester, inbound);
    expectPaintedByContainer(tester, outbound);
    expect(backgroundOf(tester, inbound).color, FloTheme.blueTint);
    expect(
      backgroundOf(tester, outbound).color,
      Colors.white.withValues(alpha: 0.14),
    );
    expect(find.byIcon(Icons.download_rounded), findsNWidgets(2));

    // Send button: 42x42 gradient square around the send icon.
    final sendBg = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.constraints ==
              const BoxConstraints.tightFor(width: 42, height: 42) &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).gradient == FloTheme.gradBtn,
    );
    expect(sendBg, findsOneWidget);
    final sendIcon =
        find.descendant(of: sendBg, matching: find.byType(Center)).first;
    expectPaintedByContainer(tester, sendIcon);
    expect(tester.widget<InkWell>(buttonInkWell(sendIcon)).onTap, isNotNull);
    // An empty reply is ignored.
    await tester.tap(buttonInkWell(sendIcon));
    await tester.pump();

    // Tap the inbound PDF: busy spinner until the save dialog answers.
    await tester.tap(buttonInkWell(inbound));
    await tester.pump();
    expect(picker.savedName, 'invoice.pdf');
    expect(picker.savedBytes, _pdfBytes);
    final spinner = find.descendant(
      of: buttonBackground(inbound),
      matching: find.byType(CircularProgressIndicator),
    );
    expect(spinner, findsOneWidget);
    expect(tester.widget<InkWell>(buttonInkWell(inbound)).onTap, isNull);

    picker.answer.complete('/tmp/invoice.pdf');
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.download_rounded), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);

    // Let the snackbar run out.
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 1));
  });
}
