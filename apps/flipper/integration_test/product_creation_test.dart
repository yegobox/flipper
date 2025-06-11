import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/widgets.dart'; // For Key
import 'package:fluent_ui/fluent_ui.dart' show FluentIcons; // For FluentIcons.add_20_regular
import 'common.dart';
// common.dart sets up Patrol but doesn't export test_cases.dart, so import it directly.
import 'test_cases.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Product Creation Tests', () {
    // Using the custom patrol function from common.dart
    patrol('should create a new simple product and verify it in list', ($) async {
      // Setup: Start app
      // Pass $.tester to helpers expecting WidgetTester
      await startAppAndPump($.tester); 
      
      // Login Flow
      // This logic attempts to handle different initial states before PIN login.
      if (find.text('Log in to Flipper by QR Code').evaluate().isNotEmpty) {
        await $.tap(find.byKey(const Key('pinLogin'))); 
        await $.pumpAndSettle();
      } else if (find.text('Create Account').evaluate().isNotEmpty) {
        await $.tap(find.byKey(const Key('signInButtonKey')));
        await $.pumpAndSettle();
        await $.tap(find.byKey(const Key('pinLogin'))); 
        await $.pumpAndSettle();
      }
      
      // Assuming we are now on PIN login screen
      // Using a known working PIN. Replace if this PIN is invalid or for a different user.
      await $.enterText(find.byType(TextFormField), '73268'); 
      await $.tap(find.text('Log in'));
      // Increased pumpAndSettle duration to allow for network requests and dashboard loading.
      await $.pumpAndSettle(const Duration(seconds: 15));

      // Navigation to Add Product Screen (Mobile Flow)
      // 1. Tap "POS" Icon on MobileView (assuming AppIconsGrid is shown)
      print("Navigating to POS...");
      final Finder posCardFinder = find.widgetWithText(Card, 'Point of Sale');
      await $.ensureVisible(posCardFinder);
      await $.tap(posCardFinder);
      await $.pumpAndSettle(const Duration(seconds: 5)); // Allow time for POS screen to load

      // 2. Tap "Add" icon in SearchField on CheckOutRoute (CheckoutProductView)
      print("Tapping Add Product icon in SearchField...");
      // Ensure the search field is empty for the add icon to be visible as per SearchField.dart logic
      // final Finder searchFieldItself = find.byType(SearchField); // If needed to ensure it's empty first
      final Finder addProductIconInSearchField = find.byIcon(FluentIcons.add_20_regular);
      await $.ensureVisible(addProductIconInSearchField);
      await $.tap(addProductIconInSearchField);
      await $.pumpAndSettle();

      // 3. Select "Add Single Product" from AddProductDialog
      print("Selecting Add Single Product from dialog...");
      final Finder addSingleProductOption = find.text('Add Single Product');
      await $.ensureVisible(addSingleProductOption);
      await $.tap(addSingleProductOption);
      await $.pumpAndSettle(const Duration(seconds: 2)); // Allow time for ProductEntryScreen to load

      // ProductEntryScreen (using DesktopProductAdd layout) should now be visible.

      // Define product details
      final String productName = 'Test Simple Product ${DateTime.now().millisecondsSinceEpoch}';
      final double retailPrice = 10.99;
      final double supplyPrice = 5.50;
      // Ensure 'Test Category' and 'PCS' are valid options in your app's dropdowns,
      // or that the createProduct helper can handle their potential creation if necessary.
      final String category = 'Test Category'; 
      final String unit = 'PCS'; 

      // Action: Create the product using the helper
      // Ensure the createProduct helper is robust or that the product creation screen is active.
      final String? productId = await createProduct(
        $.tester, // Pass $.tester
        productName: productName,
        retailPrice: retailPrice,
        supplyPrice: supplyPrice,
        category: category,
        unit: unit,
        // barcode: '1234567890123', // Optional: add if testing barcode functionality
      );
      
      expect(productId, isNotNull, reason: 'Product creation failed, returned null ID.');
      // The productId returned by createProduct is currently simulated (e.g., productName_id).
      // For a real end-to-end test, this ID might need to be extracted from the app's state or UI after creation.
      print('Product creation helper called for "$productName". Simulated/Returned ID: $productId');

      // After product creation, ProductEntryScreen is likely still visible. Close it.
      print("Closing ProductEntryScreen...");
      // DesktopProductAdd.dart uses an ElevatedButton with Text('Close')
      final Finder closeButton = find.widgetWithText(ElevatedButton, 'Close');
      await $.ensureVisible(closeButton);
      await $.tap(closeButton);
      await $.pumpAndSettle(const Duration(seconds: 2)); // Allow time to return to previous screen (CheckoutProductView)

      // Now back on CheckoutProductView (which shows ProductView.normalMode()).
      // Verify the product appears in the list on this screen.
      print("Verifying product in list on CheckoutProductView...");
      await verifyProductInList($.tester, productName); // Pass $.tester
      
      // TODO: Add further verifications if needed (e.g., stock level if applicable on CheckoutProductView)
      // For a new simple product, stock might be 0 or managed separately.
      // await verifyStockLevel($.tester, productName, 0); 

      // Teardown (Optional): Delete the created product to keep tests clean.
      // This would require a deleteProduct helper function and potentially navigation to the product's edit/details screen.
      // Example:
      // await navigateToProductDetails($.tester, productName); // Custom helper to find and tap product
      // await tapButton($.tester, find.byKey(const Key('deleteProductButton')), buttonName: 'Delete Product');
      // await tapButton($.tester, find.text('Confirm Delete'), buttonName: 'Confirm Delete Dialog'); // If there's a confirmation
      // await $.pumpAndSettle();
      // await expectSnackBarWithMessage($.tester, 'Product deleted successfully'); // Or similar feedback
      print("Test for creating product '$productName' completed. Teardown (delete) is optional and not implemented.");
    });
  });
}
