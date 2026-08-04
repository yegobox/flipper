import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/device_preview_no_layout_builder_test.dart
//
// device_preview_plus is forked in third_party/device_preview_plus for exactly
// one reason: upstream hosts the app inside a LayoutBuilder. A LayoutBuilder
// owns its own BuildScope and Element.buildScope propagates it to the whole
// subtree, so EVERY rebuild in the app would run during performLayout. Mounting
// or re-activating any OverlayPortal there (a Tooltip, a typeahead, a route push
// re-parenting stacked's GlobalKey'd Navigator) throws from
// _RenderTheater._addDeferredChild — and Flutter's guard flag latches, so the
// assert then repeats every frame until restart.
//
// This test fails if that LayoutBuilder comes back (e.g. after re-copying a
// newer release without re-applying the patch).
void main() {
  testWidgets('the hosted app has no LayoutBuilder ancestor', (tester) async {
    const appKey = Key('device-preview-hosted-app');

    await tester.pumpWidget(
      DevicePreview(
        enabled: true,
        storage: DevicePreviewStorage.none(),
        builder: (context) => const MaterialApp(
          home: Scaffold(body: SizedBox.shrink(key: appKey)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final app = find.byKey(appKey);
    expect(app, findsOneWidget, reason: 'the app should be hosted at all');

    expect(
      find.ancestor(of: app, matching: find.byType(LayoutBuilder)),
      findsNothing,
      reason: 'A LayoutBuilder above the app puts the entire app in its '
          'BuildScope, so every rebuild happens during performLayout and any '
          'OverlayPortal mount throws. Re-apply the FLIPPER PATCH in '
          'third_party/device_preview_plus/lib/src/device_preview.dart.',
    );
  });

  testWidgets('mounting a Tooltip in the hosted app does not throw',
      (tester) async {
    // The concrete symptom the patch exists to prevent: a Tooltip is an
    // OverlayPortal, and it used to be mounted during DevicePreview's layout.
    await tester.pumpWidget(
      DevicePreview(
        enabled: true,
        storage: DevicePreviewStorage.none(),
        builder: (context) => const MaterialApp(
          home: Scaffold(
            body: Tooltip(message: 'hello', child: Text('hi')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('hi'), findsOneWidget);
  });
}
