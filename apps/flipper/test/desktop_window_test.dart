import 'package:flipper_rw/desktop_window.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/desktop_window_test.dart
//
// On a computer Flipper must open maximized, not in the runner's small default
// window. This pins the startup decision: maximize on macOS/Linux, leave the
// maximize to the native runner on Windows, do nothing on mobile/web, and never
// let a window-plugin failure block startup. The real OS window is covered by
// integration_test/desktop_window_maximized_test.dart.

class _FakeWindow implements DesktopWindow {
  _FakeWindow({this.failMaximize = false});

  final bool failMaximize;
  final calls = <String>[];

  @override
  Future<void> ensureInitialized() async => calls.add('ensureInitialized');

  @override
  Future<void> maximize() async {
    calls.add('maximize');
    if (failMaximize) throw StateError('plugin unavailable');
  }

  @override
  Future<bool> isMaximized() async => calls.contains('maximize');
}

void main() {
  test('maximizes the window on macOS and Linux', () async {
    final window = _FakeWindow();

    await maximizeOnLaunch(window: window, isDesktop: true, isWindows: false);

    expect(window.calls, ['ensureInitialized', 'maximize']);
  });

  test('on Windows only initializes; the native runner maximizes', () async {
    // A Dart maximize before the first frame was undone by the runner's
    // first-frame ShowWindow, leaving a black border around a small window.
    final window = _FakeWindow();

    await maximizeOnLaunch(window: window, isDesktop: true, isWindows: true);

    expect(window.calls, ['ensureInitialized']);
  });

  test('leaves mobile and web alone', () async {
    final window = _FakeWindow();

    await maximizeOnLaunch(window: window, isDesktop: false);

    expect(window.calls, isEmpty);
  });

  test('a window failure does not block startup', () async {
    final window = _FakeWindow(failMaximize: true);

    await expectLater(
      maximizeOnLaunch(window: window, isDesktop: true, isWindows: false),
      completes,
    );
  });
}
