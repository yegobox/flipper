import 'package:flipper_overlay/flipper_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The app mounts the overlay host once at the root, outside MaterialApp.
Widget host() => OverlaySupport.global(
      child: const MaterialApp(home: Scaffold(body: SizedBox.expand())),
    );

void main() {
  testWidgets('toast shows the message, then removes it after its duration',
      (tester) async {
    await tester.pumpWidget(host());

    toast('Saved', duration: const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Saved'), findsOneWidget);

    // Hold for the duration, then fade out. Step the clock so the fade-out
    // animation gets its frames (one 2 s jump skips them).
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('a toast with no duration is never shown', (tester) async {
    await tester.pumpWidget(host());

    toast('Never', duration: Duration.zero);
    await tester.pumpAndSettle();
    expect(find.text('Never'), findsNothing);
  });

  testWidgets('showSimpleNotification at the bottom shows until dismissed',
      (tester) async {
    await tester.pumpWidget(host());

    final entry = showSimpleNotification(
      const Text('Sync failed'),
      background: Colors.red,
      position: NotificationPosition.bottom,
      autoDismiss: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Sync failed'), findsOneWidget);
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      tester.getCenter(find.text('Sync failed')).dy,
      greaterThan(screenHeight / 2),
      reason: 'NotificationPosition.bottom puts it in the lower half',
    );

    entry.dismiss();
    await tester.pumpAndSettle();
    expect(find.text('Sync failed'), findsNothing);
  });

  testWidgets(
      'dismissing before the entry mounts, then removing it, stops scheduling '
      'frames', (tester) async {
    await tester.pumpWidget(host());

    final entry = showSimpleNotification(
      const Text('Gone'),
      autoDismiss: false,
    );
    // Not mounted yet: the animated dismiss waits for a frame...
    entry.dismiss();
    // ...but the entry is removed before that frame.
    entry.dismiss(animate: false);

    await tester.pump();
    await tester.pump();
    expect(find.text('Gone'), findsNothing);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
