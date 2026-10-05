import 'package:flipper_rw/touch_keyboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeKeyboard implements TouchKeyboard {
  int shows = 0;
  int hides = 0;

  @override
  void show() => shows++;

  @override
  void hide() => hides++;
}

MethodCall _setClient(TextInputConfiguration configuration) =>
    MethodCall('TextInput.setClient', <dynamic>[1, configuration.toJson()]);

const _show = MethodCall('TextInput.show');
const _hide = MethodCall('TextInput.hide');

void main() {
  late _FakeKeyboard keyboard;
  late TouchKeyboardTextInputTracker tracker;

  void press(PointerDeviceKind kind) =>
      tracker.handlePointerEvent(PointerDownEvent(kind: kind));

  setUp(() {
    keyboard = _FakeKeyboard();
    tracker = TouchKeyboardTextInputTracker(keyboard);
  });

  test('a finger tap into a text field opens the keyboard', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 1);
  });

  test('a pen tap counts as touch', () {
    press(PointerDeviceKind.stylus);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 1);
  });

  test('a mouse click never opens it', () {
    press(PointerDeviceKind.mouse);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('autofocus before any touch does not open it', () {
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('fields with their own keypad (TextInputType.none) are skipped', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(
      _setClient(const TextInputConfiguration(inputType: TextInputType.none)),
    );
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('read-only fields are skipped', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(
      _setClient(const TextInputConfiguration(readOnly: true)),
    );
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('updateConfig is honoured', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(MethodCall(
      'TextInput.updateConfig',
      const TextInputConfiguration(readOnly: true).toJson(),
    ));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('a cleared client does not open it', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(const MethodCall('TextInput.clearClient'));
    tracker.handleTextInputCall(_show);
    expect(keyboard.shows, 0);
  });

  test('hide closes a keyboard it opened', () {
    press(PointerDeviceKind.touch);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    tracker.handleTextInputCall(_hide);
    expect(keyboard.hides, 1);
  });

  test('hide leaves a keyboard it did not open alone', () {
    press(PointerDeviceKind.mouse);
    tracker.handleTextInputCall(_setClient(const TextInputConfiguration()));
    tracker.handleTextInputCall(_show);
    tracker.handleTextInputCall(_hide);
    expect(keyboard.hides, 0);
  });
}
