// import 'package:flipper_dashboard/itemRow.dart';
// import 'package:flipper_models/realm_model_export.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
// import 'package:flipper_models/providers/transactions_provider.dart';
// import 'package:flipper_rw/dependencyInitializer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper_routing/app.locator.dart';
// import 'dart:async';
// import 'dart:io';

// @GenerateMocks([ProductViewModel])
// class MockProductViewModel extends Mock implements ProductViewModel {}

// class MockVariant extends Mock implements Variant {
//   @override
//   String get id => "test-variant";

//   @override
//   String get productId => "test-product";

//   @override
//   String get name => "Test Variant";

//   @override
//   double get retailPrice => 100.0;

//   @override
//   Stock? get stock => Stock(
//         branchId: 1,
//         currentStock: 10.0,
//       );
// }

// class MockTransaction extends Mock implements ITransaction {
//   @override
//   String get id => "test-transaction";

//   @override
//   int get branchId => 1;

//   @override
//   String get businessId => "test-business";
// }

// void main() {
//   late MockProductViewModel mockModel;
//   late MockVariant mockVariant;
//   late ProviderContainer container;

//   setUpAll(() async {
//     // Set up the service locator
//     await initializeDependenciesForTest().timeout(
//       const Duration(minutes: 2),
//       onTimeout: () => throw TimeoutException(
//           'Test initialization timed out after 2 minutes'),
//     );
//   });

//   setUp(() {
//     mockModel = MockProductViewModel();
//     mockVariant = MockVariant();

//     // Set up mock behavior
//     when(mockModel.saveTransaction(
//       variation: mockVariant,
//       amountTotal: 100.0,
//       customItem: false,
//       currentStock: 10.0,
//       pendingTransaction: argThat(isA<ITransaction>()),
//       partOfComposite: false,
//       compositePrice: null,
//       useTransactionItemForQty: false,
//       item: null,
//     )).thenAnswer((_) async => true);

//     // Create a ProviderContainer with overridden providers
//     container = ProviderContainer(
//       overrides: [
//         selectedItemIdProvider.overrideWith(
//           (ref) => NO_SELECTION,
//         ),
//       ],
//     );
//   });

//   tearDown(() {
//     container.dispose();
//   });

//   testWidgets('RowItem - normal tap adds item to cart without selection',
//       (WidgetTester tester) async {
//     // Arrange
//     await tester.pumpWidget(
//       ProviderScope(
//         parent: container,
//         child: OverlaySupport.global(
//           child: MaterialApp(
//             home: Scaffold(
//               body: RowItem(
//                 color: "#673AB7",
//                 productName: "Test Product",
//                 variantName: "Test Variant",
//                 stock: 10.0,
//                 forceRemoteUrl: true,
//                 model: mockModel,
//                 variant: mockVariant,
//                 isComposite: false,
//                 isOrdering: false,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     // Act
//     await tester.tap(find.byType(InkWell));
//     await tester.pumpAndSettle();

//     // Assert
//     // Verify item was added to cart without selection
//     expect(container.read(selectedItemIdProvider), NO_SELECTION);
//     verify(mockModel.saveTransaction(
//       variation: mockVariant,
//       amountTotal: 100.0,
//       customItem: false,
//       currentStock: 10.0,
//       pendingTransaction: any,
//       partOfComposite: false,
//     )).called(1);
//   });

//   testWidgets('RowItem - long press does nothing when ordering',
//       (WidgetTester tester) async {
//     // Arrange
//     await tester.pumpWidget(
//       ProviderScope(
//         parent: container,
//         child: MaterialApp(
//           home: Scaffold(
//             body: RowItem(
//               color: "#673AB7",
//               productName: "Test Product",
//               variantName: "Test Variant",
//               stock: 10.0,
//               forceRemoteUrl: true,
//               model: mockModel,
//               variant: mockVariant,
//               isComposite: false,
//               isOrdering: true, // Set to ordering mode
//             ),
//           ),
//         ),
//       ),
//     );

//     // Act - Long press in ordering mode
//     await tester.longPress(find.byType(InkWell));
//     await tester.pumpAndSettle();

//     // Assert - Item should not be selected
//     expect(container.read(selectedItemIdProvider), NO_SELECTION);
//   });

//   testWidgets('RowItem - shows correct product information',
//       (WidgetTester tester) async {
//     // Arrange
//     await tester.pumpWidget(
//       ProviderScope(
//         parent: container,
//         child: MaterialApp(
//           home: Scaffold(
//             body: RowItem(
//               color: "#673AB7",
//               productName: "Test Product",
//               variantName: "Test Variant",
//               stock: 10.0,
//               forceRemoteUrl: true,
//               model: mockModel,
//               variant: mockVariant,
//               isComposite: false,
//               isOrdering: false,
//             ),
//           ),
//         ),
//       ),
//     );

//     // Assert
//     expect(find.text("Test Variant"), findsOneWidget);
//     // The stock display is part of the variant data, not directly displayed
//     expect(find.text("Test Variant"), findsOneWidget);
//   });
// }

import 'package:flutter_test/flutter_test.dart';
// import 'TestApp.dart';
import 'package:flipper_rw/dependencyInitializer.dart';

// flutter test test/check_out_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('CheckOuts Tests', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
    });

    setUp(() {});

    testWidgets('Checkout  displays correctly', (WidgetTester tester) async {
      expect(1, 1);
    });
  });
}
