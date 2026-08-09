import 'package:flipper_ai_feature/src/services/speech_dictation.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MockSpeechToText extends Mock implements SpeechToText {}

void main() {
  late MockSpeechToText speech;
  late SpeechDictation dictation;
  late TextEditingController controller;
  SpeechResultListener? onResult;

  setUp(() {
    onResult = null;
    speech = MockSpeechToText();
    when(() => speech.initialize(
          onError: any(named: 'onError'),
          onStatus: any(named: 'onStatus'),
        )).thenAnswer((_) async => true);
    when(() => speech.listen(
          onResult: any(named: 'onResult'),
          listenOptions: any(named: 'listenOptions'),
        )).thenAnswer((invocation) async {
      onResult = invocation.namedArguments[#onResult] as SpeechResultListener?;
      return null;
    });
    when(() => speech.stop()).thenAnswer((_) async {});
    when(() => speech.cancel()).thenAnswer((_) async {});

    dictation = SpeechDictation(speech: speech);
    controller = TextEditingController();
  });

  tearDown(() {
    dictation.dispose();
    controller.dispose();
  });

  Future<void> pumpComposer(WidgetTester tester, {VoidCallback? onSend}) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FloComposer(
          controller: controller,
          onSend: onSend ?? () {},
          dictation: dictation,
        ),
      ),
    ));
  }

  Finder micButton() => find.bySemanticsLabel(
        RegExp(r'Dictate|Stop dictating'),
      );

  testWidgets('tapping the mic starts dictation and shows it is listening',
      (tester) async {
    await pumpComposer(tester);

    expect(find.text('Listening…'), findsNothing);

    await tester.tap(micButton());
    await tester.pumpAndSettle();

    verify(() => speech.listen(
          onResult: any(named: 'onResult'),
          listenOptions: any(named: 'listenOptions'),
        )).called(1);
    expect(dictation.isListening, isTrue);
    expect(find.text('Listening…'), findsOneWidget);
  });

  testWidgets('spoken words land in the composer field', (tester) async {
    await pumpComposer(tester);
    await tester.tap(micButton());
    await tester.pumpAndSettle();

    onResult!(SpeechRecognitionResult.init(
      [const SpeechRecognitionWords('how many users', null, 1.0)],
      ResultType.finalResult,
    ));
    await tester.pumpAndSettle();

    expect(controller.text, 'how many users');
    expect(find.text('how many users'), findsOneWidget);
  });

  testWidgets('tapping the mic again stops dictation', (tester) async {
    await pumpComposer(tester);

    await tester.tap(micButton());
    await tester.pumpAndSettle();
    await tester.tap(micButton());
    await tester.pumpAndSettle();

    verify(() => speech.stop()).called(1);
    expect(dictation.isListening, isFalse);
    expect(find.text('Listening…'), findsNothing);
  });

  testWidgets('sending ends the dictation session', (tester) async {
    var sent = 0;
    await pumpComposer(tester, onSend: () => sent++);

    await tester.tap(micButton());
    await tester.pumpAndSettle();

    onResult!(SpeechRecognitionResult.init(
      [const SpeechRecognitionWords('todays sales', null, 1.0)],
      ResultType.finalResult,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(InkWell).last);
    await tester.pumpAndSettle();

    expect(sent, 1);
    verify(() => speech.stop()).called(1);
    expect(dictation.isListening, isFalse);
  });
}
