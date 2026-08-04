import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_variants_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/widgets/product_editor_variants_empty_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// TableVariants renders the placeholder inside a Stack, which passes loose
  /// constraints — so the box has to claim the width itself or it shrink-wraps
  /// its text and stops lining up with the scan field above it.
  testWidgets('fills the available width under loose constraints',
      (tester) async {
    // Wide enough that the placeholder text cannot wrap — at narrow widths the
    // wrapped text fills the box on its own and hides a missing width.
    const available = 780.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: available,
              child: Stack(children: [ProductEditorVariantsEmpty()]),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(ProductEditorVariantsEmpty)).width,
      equals(available),
    );
  });

  testWidgets('wording differs for a product that already exists',
      (tester) async {
    Future<void> pump(bool isEditMode) => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductEditorVariantsEmpty(isEditMode: isEditMode),
            ),
          ),
        );

    await pump(false);
    await tester.pumpAndSettle();
    expect(find.text('No variants yet'), findsOneWidget);

    await pump(true);
    await tester.pumpAndSettle();
    expect(find.text('This product has no variants'), findsOneWidget);
  });
}
