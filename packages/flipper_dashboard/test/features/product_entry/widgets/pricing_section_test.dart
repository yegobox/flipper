import 'package:flipper_dashboard/features/product_entry/widgets/pricing_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/mocks.dart';

void main() {
  late MockScannViewModel mockViewModel;
  late TextEditingController retailPriceController;
  late TextEditingController supplyPriceController;

  setUp(() {
    mockViewModel = MockScannViewModel();
    retailPriceController = TextEditingController();
    supplyPriceController = TextEditingController();
  });

  Widget buildTestWidget({bool isComposite = false}) {
    return MaterialApp(
      home: Scaffold(
        body: PricingSection(
          retailPriceController: retailPriceController,
          supplyPriceController: supplyPriceController,
          model: mockViewModel,
          isComposite: isComposite,
        ),
      ),
    );
  }

  group('PricingSection', () {
    testWidgets('renders Retail Price and Supply Price fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Pricing'), findsOneWidget);
      expect(find.text('Retail Price'), findsOneWidget);
      expect(find.text('Supply Price'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('calls setRetailPrice when retail price changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      const newPrice = '100.00';
      await tester.enterText(find.byType(TextFormField).first, newPrice);
      await tester.pump();

      verify(() => mockViewModel.setRetailPrice(price: newPrice)).called(1);
    });

    testWidgets('calls setSupplyPrice when supply price changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      const newPrice = '50.00';
      await tester.enterText(find.byType(TextFormField).last, newPrice);
      await tester.pump();

      verify(() => mockViewModel.setSupplyPrice(price: newPrice)).called(1);
    });

    testWidgets('validates empty retail price', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final formFields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );
      final retailPriceField = formFields.first;
      final validator = retailPriceField.validator;

      expect(validator!(null), 'Price is required');
      expect(validator!(''), 'Price is required');
    });

    testWidgets('validates invalid retail price format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final formFields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );
      final retailPriceField = formFields.first;
      final validator = retailPriceField.validator;

      expect(validator!('abc'), 'Invalid price');
    });

    testWidgets('accepts valid retail price', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final formFields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );
      final retailPriceField = formFields.first;
      final validator = retailPriceField.validator;

      expect(validator!('100.50'), null);
    });

    testWidgets('shows lock icon when isComposite is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(isComposite: true));

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('does not show lock icon when isComposite is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(isComposite: false));

      expect(find.byIcon(Icons.lock), findsNothing);
    });
  });
}
