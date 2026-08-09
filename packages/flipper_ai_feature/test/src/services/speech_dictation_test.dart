import 'package:flipper_ai_feature/src/services/speech_dictation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MockSpeechToText extends Mock implements SpeechToText {}

/// Captures the callbacks `SpeechDictation` hands to the engine so a test can
/// drive them the way a real recognizer would.
class _Engine {
  _Engine(this.speech);

  final MockSpeechToText speech;
  SpeechResultListener? onResult;
  SpeechStatusListener? onStatus;
  SpeechErrorListener? onError;

  void wire({bool initializes = true}) {
    when(() => speech.initialize(
          onError: any(named: 'onError'),
          onStatus: any(named: 'onStatus'),
        )).thenAnswer((invocation) async {
      onError = invocation.namedArguments[#onError] as SpeechErrorListener?;
      onStatus = invocation.namedArguments[#onStatus] as SpeechStatusListener?;
      return initializes;
    });

    when(() => speech.listen(
          onResult: any(named: 'onResult'),
          listenOptions: any(named: 'listenOptions'),
        )).thenAnswer((invocation) async {
      onResult = invocation.namedArguments[#onResult] as SpeechResultListener?;
      return null;
    });

    when(() => speech.stop()).thenAnswer((_) async {});
    when(() => speech.cancel()).thenAnswer((_) async {});
  }

  void say(String words, {bool isFinal = false}) => onResult!(_result(words, isFinal));
}

SpeechRecognitionResult _result(String words, bool isFinal) =>
    SpeechRecognitionResult.init(
      [SpeechRecognitionWords(words, null, 1.0)],
      isFinal ? ResultType.finalResult : ResultType.partial,
    );

void main() {
  late MockSpeechToText speech;
  late _Engine engine;
  late SpeechDictation dictation;
  late TextEditingController field;

  setUp(() {
    speech = MockSpeechToText();
    engine = _Engine(speech)..wire();
    dictation = SpeechDictation(speech: speech);
    field = TextEditingController();
  });

  tearDown(() {
    dictation.dispose();
    field.dispose();
  });

  test('writes recognised words into the field as they arrive', () async {
    await dictation.start(field);

    expect(dictation.isListening, isTrue);

    engine.say('how many');
    expect(field.text, 'how many');

    engine.say('how many sales today', isFinal: true);
    expect(field.text, 'how many sales today');
    expect(field.selection.baseOffset, field.text.length);
  });

  test('appends to text the user already typed', () async {
    field.text = 'Show me';
    await dictation.start(field);

    engine.say('last week');
    expect(field.text, 'Show me last week');
  });

  test('stop ends the session and leaves the text in place', () async {
    await dictation.start(field);
    engine.say('total revenue', isFinal: true);

    await dictation.stop();

    verify(() => speech.stop()).called(1);
    expect(dictation.isListening, isFalse);
    expect(field.text, 'total revenue');
  });

  test('toggle starts then stops', () async {
    await dictation.toggle(field);
    expect(dictation.isListening, isTrue);

    await dictation.toggle(field);
    expect(dictation.isListening, isFalse);
  });

  test('engine ending on its own drops back to idle', () async {
    await dictation.start(field);

    engine.onStatus!(SpeechToText.notListeningStatus);

    expect(dictation.isListening, isFalse);
    expect(dictation.error, isNull);
  });

  test('failed initialize surfaces a permission message', () async {
    engine.wire(initializes: false);

    await dictation.start(field);

    expect(dictation.isListening, isFalse);
    expect(dictation.consumeError(), contains('Microphone access'));
    expect(dictation.consumeError(), isNull);
  });

  test('a silent listen is not reported as an error', () async {
    await dictation.start(field);

    engine.onError!(SpeechRecognitionError('error_no_match', false));

    expect(dictation.isListening, isFalse);
    expect(dictation.error, isNull);
  });

  test('a real engine error is reported', () async {
    await dictation.start(field);

    engine.onError!(SpeechRecognitionError('error_network', true));

    expect(dictation.isListening, isFalse);
    expect(dictation.consumeError(), contains('network'));
  });

  test('partial results overwrite rather than accumulate', () async {
    await dictation.start(field);

    engine.onResult!(_result('sales', false));
    engine.onResult!(_result('sales this', false));
    engine.onResult!(_result('sales this month', false));

    expect(field.text, 'sales this month');
  });
}
