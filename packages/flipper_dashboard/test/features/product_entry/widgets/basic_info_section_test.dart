import 'package:flipper_dashboard/features/product_entry/widgets/basic_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/mocks.dart';

void main() {
  late MockScannViewModel mockViewModel;
  late TextEditingController nameController;

  setUp(() {
    mockViewModel = MockScannViewModel();
    nameController = TextEditingController();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BasicInfoSection(
          productNameController: nameController,
          model: mockViewModel,
          isEditMode: false,
        ),
      ),
    );
  }

  group('BasicInfoSection', () {
    testWidgets('renders Product Name text field', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Product Name'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('calls setProductName when text changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      const newName = 'New Product';
      await tester.enterText(find.byType(TextFormField), newName);
      await tester.pump();

      verify(() => mockViewModel.setProductName(name: newName)).called(1);
    });

    testWidgets('validates empty product name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final formField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      final validator = formField.validator;

      expect(validator!(null), 'Product name is required');
      expect(validator(''), 'Product name is required');
    });

    testWidgets('validates short product name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final formField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      final validator = formField.validator;

      expect(
        validator!('ab'),
        'Product name must be at least 3 characters long',
      );
    });

    testWidgets('accepts valid product name', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final formField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      final validator = formField.validator;

      expect(validator!('Valid Name'), null);
    });
  });
}
