import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a finger tap switches desktop density to touch size and a '
      'mouse click switches it back', (tester) async {
    final mode = TouchInputMode(initial: false);
    addTearDown(mode.dispose);
    bool? seenTouch;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        builder: (context, child) =>
            TouchInputDetector(mode: mode, child: child!),
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                seenTouch = TouchInputMode.of(context);
                return IconButton(
                  key: const Key('btn'),
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                );
              },
            ),
          ),
        ),
      ),
    );

    final compact = tester.getSize(find.byKey(const Key('btn')));
    expect(seenTouch, isFalse);
    expect(compact.height, lessThan(48));

    final center = tester.getCenter(find.byKey(const Key('btn')));
    final finger = await tester.startGesture(
      center,
      kind: PointerDeviceKind.touch,
    );
    // Not resized mid-gesture — that would cancel the tap.
    await tester.pump();
    expect(mode.value, isFalse);
    await finger.up();
    await tester.pump();

    expect(mode.value, isTrue);
    expect(seenTouch, isTrue);
    expect(
      tester.getSize(find.byKey(const Key('btn'))).height,
      greaterThanOrEqualTo(48),
    );

    final mouse = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('btn'))),
      kind: PointerDeviceKind.mouse,
    );
    await mouse.up();
    await tester.pump();

    expect(mode.value, isFalse);
    expect(tester.getSize(find.byKey(const Key('btn'))).height, compact.height);
  });
}
