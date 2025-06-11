import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Note: Material.dart was already imported, removed duplicate.

import 'package:flipper_rw/main.dart' as app;

// General Navigation Helpers
Future<void> navigateToScreen(WidgetTester tester, Finder tapTarget, Finder screenIdentifier, {String? screenName}) async {
  await tester.tap(tapTarget);
  await tester.pumpAndSettle();
  expect(screenIdentifier, findsOneWidget, reason: 'Failed to navigate to ${screenName ?? 'screen'}.');
}

Future<void> goBack(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

// Product Management Helpers
Future<String?> createProduct(WidgetTester tester, {
  required String productName,
  required double retailPrice,
  required double supplyPrice,
  String? category,
  String? unit,
  String? barcode,
  List<Map<String, dynamic>>? variants,
}) async {
  // Example: Navigate to add product screen first. This finder needs to be actual.
  // await tapButton(tester, find.byKey(const Key('navigateToCreateProductScreenButton')), buttonName: 'Add Product');
  // await tester.pumpAndSettle();

  // Product Name
  final Finder productNameField = find.byWidgetPredicate(
      (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Product Name',
      description: 'Product Name TextFormField');
  await enterTextInField(tester, productNameField, productName, fieldName: 'Product Name');

  // Retail Price
  final Finder retailPriceField = find.byWidgetPredicate(
      (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Price',
      description: 'Retail Price TextFormField');
  await enterTextInField(tester, retailPriceField, retailPrice.toString(), fieldName: 'Retail Price');

  // Supply Price (Cost)
  final Finder supplyPriceField = find.byWidgetPredicate(
      (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Cost',
      description: 'Supply Price TextFormField');
  await enterTextInField(tester, supplyPriceField, supplyPrice.toString(), fieldName: 'Supply Price');
  
  // Category Dropdown
  if (category != null) {
    // Assuming DropdownButtonWithLabel has a label Text widget with content 'Category'
    // And the tappable part of DropdownButtonWithLabel can be found this way.
    // This might need adjustment based on the actual widget structure of DropdownButtonWithLabel.
    final Finder categoryDropdown = find.ancestor(
        of: find.text('Category'), 
        matching: find.byType(InkWell), // Or the specific tappable widget in DropdownButtonWithLabel
    ).first; // Or find.widgetWithText(DropdownButtonWithLabel, 'Category') if it's directly tappable
    
    await tapButton(tester, categoryDropdown, buttonName: 'Category Dropdown');
    await tester.pumpAndSettle(); // Wait for dropdown items to appear
    
    final Finder categoryItem = find.text(category).last; // Use last to avoid tapping the label if it's also found
    await tapButton(tester, categoryItem, buttonName: 'Category: $category');
    await tester.pumpAndSettle();
  }

  // Packaging Unit Dropdown
  if (unit != null) {
     final Finder unitDropdown = find.ancestor(
        of: find.text('Packaging Unit'), 
        matching: find.byType(InkWell),
    ).first;
    // Or find.widgetWithText(DropdownButtonWithLabel, 'Packaging Unit')
    await tapButton(tester, unitDropdown, buttonName: 'Packaging Unit Dropdown');
    await tester.pumpAndSettle();
    
    final Finder unitItem = find.text(unit).last;
    await tapButton(tester, unitItem, buttonName: 'Unit: $unit');
    await tester.pumpAndSettle();
  }

  // Barcode field (SKU for the main product - if applicable on this screen)
  // This is a placeholder, actual field might have a different label or key.
  if (barcode != null) {
    // Assuming there's a main barcode field, if not, this part should be removed or adjusted.
    // The provided 'Scan or Type' was for variants. If there's a main SKU field:
    // final Finder barcodeField = find.byWidgetPredicate(
    //   (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'SKU / Barcode',
    //   description: 'Main SKU/Barcode TextFormField');
    // await enterTextInField(tester, barcodeField, barcode, fieldName: 'Main SKU/Barcode');
    print('Skipping main barcode field for now, as specific finder is TBD.');
  }

  // Variants and Composite Product parts are kept as placeholders
  if (variants != null) {
    for (var variant in variants) {
      // Placeholder: Actual variant creation will need more detailed interaction
      // e.g., tapping 'Add Variant', finding fields for name, SKU, price within TableVariants
      // final Finder scanOrTypeVariantField = find.widgetWithText(TextFormField, 'Scan or Type');
      // await enterTextInField(tester, scanOrTypeVariantField, variant['sku'] ?? '', fieldName: 'Variant SKU');
      print('Adding variant: ${variant['name']} - Note: Variant creation logic is a placeholder.');
    }
  }

  // Tap the save button
  final Finder saveButton = find.widgetWithText(ElevatedButton, 'Save');
  await tapButton(tester, saveButton, buttonName: 'Save Product');

  // Optionally, verify success (e.g., by expecting a snackbar or navigation)
  // await expectSnackBarWithMessage(tester, 'Product saved successfully');
  // await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for UI to update

  // In a real scenario, you might want to fetch the product ID from the app's state
  // or look for it on the screen if displayed after creation.
  // For now, returning a simulated ID.
  String simulatedProductId = '${productName.replaceAll(' ', '_').toLowerCase()}_id';
  print('Product creation process for "$productName" simulated. Returning ID: $simulatedProductId');
  return simulatedProductId;
}

Future<void> verifyProductInList(WidgetTester tester, String productName) async {
  // This assumes the product name is directly visible on the current screen.
  // In a real scenario, you might need to scroll within a list to find the product.
  // e.g., await tester.scrollUntilVisible(find.text(productName), 50.0);
  await tester.ensureVisible(find.text(productName));
  expect(find.text(productName), findsOneWidget, reason: 'Product "$productName" not found in list.');
  await tester.pumpAndSettle();
}

Future<void> addStock(WidgetTester tester, String productIdOrName, int quantity, {double? supplyPrice}) async {
  // 1. Find the product in a list and tap on it to navigate to its details or a stock management screen.
  //    This assumes 'productIdOrName' is the text displayed for the product in a list.
  //    Actual navigation to product's stock management screen is needed.
  print('Attempting to tap product: $productIdOrName to add stock.');
  await tapButton(tester, find.text(productIdOrName), buttonName: 'Product: $productIdOrName');
  await tester.pumpAndSettle(); // Wait for navigation

  // 2. On the product's screen, find and tap an "Add Stock" or "Receive Stock" button.
  //    This is a placeholder key.
  // await tapButton(tester, find.byKey(const Key('manageStockButton')), buttonName: 'Manage Stock');
  // await tester.pumpAndSettle();
  // await tapButton(tester, find.byKey(const Key('addStockButton')), buttonName: 'Add Stock');
  // await tester.pumpAndSettle();
  print('Placeholder: Navigated to add stock screen for $productIdOrName.');

  // 3. Enter quantity. This is a placeholder key.
  await enterTextInField(tester, find.byKey(const Key('stockQuantityField')), quantity.toString(), fieldName: 'Stock Quantity');
  
  if (supplyPrice != null) {
    // This is a placeholder key.
    await enterTextInField(tester, find.byKey(const Key('stockSupplyPriceField')), supplyPrice.toString(), fieldName: 'Supply Price (Stock)');
  }
  
  // 4. Tap save/confirm button for adding stock. This is a placeholder key.
  // await tapButton(tester, find.byKey(const Key('saveStockAdjustmentButton')), buttonName: 'Save Stock Adjustment');
  // await tester.pumpAndSettle();
  
  // await expectSnackBarWithMessage(tester, 'Stock added successfully');
  print('Simulating adding $quantity stock for $productIdOrName. Save action is a placeholder.');
  await tester.pumpAndSettle(const Duration(seconds: 1)); 
}

Future<void> verifyStockLevel(WidgetTester tester, String productIdOrName, int expectedQuantity) async {
  // 1. Navigate to where stock is displayed (e.g., product details page or a stock report).
  //    This might involve tapping on the product in a list first if not already on its details page.
  //    print('Attempting to tap product: $productIdOrName to verify stock.');
  //    await tapButton(tester, find.text(productIdOrName), buttonName: 'Product: $productIdOrName');
  //    await tester.pumpAndSettle(); // Wait for navigation
  print('Placeholder: Navigated to product screen for $productIdOrName to verify stock.');

  // 2. Find the text widget displaying its stock quantity. This is highly dependent on your UI.
  //    It might be find.text('Stock: $expectedQuantity'), or find.byKey(const Key('productStockLevelText')),
  //    or a more complex finder if the quantity is part of a larger string.
  //    The finder below is a placeholder and likely needs to be more specific.
  final Finder stockLevelFinder = find.byKey(const Key('currentStockLevelText')); // Placeholder Key
  
  // await tester.ensureVisible(stockLevelFinder); // Ensure it's visible if scrolling is needed on the page
  // expect(find.descendant(of: stockLevelFinder, matching: find.text(expectedQuantity.toString())), findsOneWidget,
  //   reason: 'Expected stock quantity $expectedQuantity for $productIdOrName not found.');
  
  // Fallback to a general text search as a temporary measure if the key above isn't found.
  // This is less robust.
  print('Verifying stock level for $productIdOrName, expecting $expectedQuantity. Specific finder is a placeholder.');
  expect(find.textContaining(expectedQuantity.toString()), findsOneWidget,
    reason: 'Expected stock quantity $expectedQuantity for $productIdOrName not found using textContaining.');
  await tester.pumpAndSettle();
}


// Sales & Checkout Helpers

// Note: addItemToCart typically interacts with a product selection screen (e.g., POS grid)
// BEFORE navigating or displaying the QuickSellingView.
Future<void> addItemToCart(WidgetTester tester, String itemNameOrBarcode, {int quantity = 1}) async {
  // 1. Find item by text/barcode on the product selection/catalog screen.
  final Finder itemFinder = find.text(itemNameOrBarcode);
  await tester.ensureVisible(itemFinder);

  // 2. Tap on item to add to cart. Loop for quantity.
  for (int i = 0; i < quantity; i++) {
    await tester.tap(itemFinder);
    await tester.pumpAndSettle(); 
    print('Tapped "$itemNameOrBarcode" to add to cart (tap ${i+1} of $quantity).');
  }
  // Optionally, verify item was added (e.g., by checking cart icon badge or a brief message on that screen).
}

// Note: verifyCartItem also assumes visibility of cart details, which might be on the
// QuickSellingView or a dedicated cart screen.
Future<void> verifyCartItem(WidgetTester tester, String itemName, {int? quantity, double? price}) async {
  // This assumes you are on a screen where the cart details (e.g., within QuickSellingView) are visible.
  // The Key 'cartListView' is an assumption for where items are listed.
  final Finder itemInCartFinder = find.descendant(
    of: find.byKey(const Key('cartListView')), 
    matching: find.textContaining(itemName),
  );
  
  expect(itemInCartFinder, findsOneWidget, reason: 'Item "$itemName" not found in cart view.');

  if (quantity != null) {
    // This finder needs to be specific to how quantity is displayed next to an item in your cart.
    final Finder quantityFinder = find.descendant(
        of: itemInCartFinder, 
        matching: find.textContaining('x$quantity') // Example: "Item Name ... x3"
    );
    expect(quantityFinder, findsOneWidget, reason: 'Quantity $quantity for item "$itemName" not found or not matching.');
  }
  if (price != null) {
    // This finder needs to be specific to how price is displayed for an item in your cart.
     final Finder priceFinder = find.descendant(
        of: itemInCartFinder, 
        matching: find.textContaining(price.toStringAsFixed(2)) // Example: "Item Name ... $10.00"
    );
    expect(priceFinder, findsOneWidget, reason: 'Price ${price.toStringAsFixed(2)} for item "$itemName" not found or not matching.');
  }
  await tester.pumpAndSettle();
}

Future<void> verifyCartTotals(WidgetTester tester, {required double subtotal, double? tax, required double total}) async {
  // Verify Grand Total based on QuickSellingView information
  final Finder grandTotalFinder = find.textContaining('Grand Total: ${total.toStringAsFixed(2)}');
  await tester.ensureVisible(grandTotalFinder);
  expect(grandTotalFinder, findsOneWidget, reason: "Grand Total on QuickSellingView not matching or not found.");

  // Placeholders for Subtotal and Tax as their specific finders on QuickSellingView are not yet defined.
  // These might be part of the `buildTransactionItemsTable` or elsewhere.
  if (subtotal != null) {
     // final Finder subtotalFinder = find.textContaining('Subtotal: ${subtotal.toStringAsFixed(2)}');
     // await tester.ensureVisible(subtotalFinder);
     // expect(subtotalFinder, findsOneWidget, reason: "Subtotal not matching or not found.");
     print('Subtotal verification is a placeholder in verifyCartTotals.');
  }
  if (tax != null) {
    // final Finder taxFinder = find.textContaining('Tax: ${tax.toStringAsFixed(2)}');
    // await tester.ensureVisible(taxFinder);
    // expect(taxFinder, findsOneWidget, reason: "Tax not matching or not found.");
    print('Tax verification is a placeholder in verifyCartTotals.');
  }
  await tester.pumpAndSettle();
}

Future<void> applyPayment(WidgetTester tester, {
  required double amount, 
  required String paymentMethod, // e.g., "CASH"
  String? receivedAmount, // For overall received amount if different from payment amount
  String? customerName,
  String? customerPhone,
  bool addAnotherPayment = false,
}) async {
  // Enter Received Amount (overall for the transaction)
  if (receivedAmount != null) {
    final Finder receivedAmountField = find.byWidgetPredicate(
        (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Received Amount', // Assuming StyledTextFormField renders a TextFormField
        description: 'Received Amount field');
    await enterTextInField(tester, receivedAmountField, receivedAmount, fieldName: 'Received Amount');
  }

  // Enter Customer Name
  if (customerName != null) {
     final Finder customerNameField = find.byWidgetPredicate(
        (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Customer  Name', // Note double space
        description: 'Customer Name field');
    await enterTextInField(tester, customerNameField, customerName, fieldName: 'Customer Name');
  }

  // Enter Customer Phone
  if (customerPhone != null) {
    final Finder customerPhoneField = find.byWidgetPredicate(
        (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Customer Phone number',
        description: 'Customer Phone field');
    await enterTextInField(tester, customerPhoneField, customerPhone, fieldName: 'Customer Phone number');
  }
  
  // --- Payment Method Row Interaction ---
  // This section assumes we are interacting with the *first* or a uniquely identifiable payment row.
  // For multiple payment rows, more specific finders for each row would be needed.

  // 1. Select Payment Method Type (e.g., CASH)
  // Assuming the DropdownButton is the first one for payment types.
  final Finder paymentTypeDropdown = find.byType(DropdownButton<String>).first;
  await tapButton(tester, paymentTypeDropdown, buttonName: 'Payment Type Dropdown');
  await tester.pumpAndSettle();
  final Finder paymentMethodItem = find.text(paymentMethod).last; // Find the text in the dropdown list
  await tapButton(tester, paymentMethodItem, buttonName: 'Select $paymentMethod');
  await tester.pumpAndSettle();

  // 2. Enter Amount for this specific payment method
  // Assuming the 'Amount' field is the first TextFormField in a payment row,
  // or is uniquely identifiable near the selected payment method.
  // This finder might need to be more specific if there are multiple 'Amount' fields.
   final Finder paymentAmountField = find.byWidgetPredicate(
        (Widget widget) => widget is TextFormField && widget.decoration?.labelText == 'Amount',
        description: 'Payment method amount field');
  await enterTextInField(tester, paymentAmountField, amount.toString(), fieldName: 'Payment Method Amount for $paymentMethod');
  
  if (addAnotherPayment) {
    // This assumes FlipperButton is a custom widget that might render an ElevatedButton or similar.
    // If FlipperButton is the tappable widget itself:
    // final Finder addPaymentButton = find.widgetWithText(FlipperButton, 'Add Payment Method');
    // Or find the specific button type it renders:
    final Finder addPaymentButton = find.byWidgetPredicate(
        (Widget widget) => (widget is ElevatedButton || widget is TextButton) && widget.child is Text && (widget.child as Text).data == 'Add Payment Method',
        description: 'Add Payment Method button');
    await tapButton(tester, addPaymentButton, buttonName: 'Add Payment Method');
    await tester.pumpAndSettle(); // Wait for new payment row to appear
    // Subsequent calls to applyPayment would need to target the new row specifically.
  }

  // Placeholder for tapping the main "Pay" button, which is likely in PayableView.
  // final Finder mainPayButton = find.widgetWithText(FlipperButton, "Pay ${totalAmount}"); // Or similar
  // await tapButton(tester, mainPayButton, buttonName: 'Main Pay Button');
  print('Applied payment details for $amount using $paymentMethod. Final "Pay" button is a placeholder.');
  await tester.pumpAndSettle(const Duration(seconds: 1)); 
}

Future<void> completeSale(WidgetTester tester) async {
  // This action typically follows applyPayment.
  // The main "Pay" or "Complete Sale" button is likely within a PayableView widget.
  // Its exact finder (e.g., specific text, key, or type) needs to be determined by inspecting PayableView.
  // Example placeholder:
  // final Finder completeSaleButton = find.byKey(const Key('payableCompleteSaleButton')); // Or find.text('PAY') etc.
  // await tapButton(tester, completeSaleButton, buttonName: 'Complete Sale Button');
  print('Completing sale... (Actual button tap is a placeholder, likely in PayableView)');
  // await expectDialogWithTitle(tester, 'Sale Completed'); // Or verify navigation to a receipt screen.
  await tester.pumpAndSettle(const Duration(seconds:2)); 
}

Future<void> verifySaleReceipt(WidgetTester tester, {List<String>? items, double? total}) async {
  // This assumes a receipt dialog or a new screen is shown after completing a sale.
  // The Key 'saleReceiptView' is a placeholder for the main receipt widget.
  expect(find.byKey(const Key('saleReceiptView')), findsOneWidget, reason: 'Sale receipt view/dialog not found.');

  if (items != null) {
    for (String item in items) {
      await tester.ensureVisible(find.descendant(of: find.byKey(const Key('saleReceiptView')), matching: find.textContaining(item)));
      expect(find.descendant(of: find.byKey(const Key('saleReceiptView')), matching: find.textContaining(item)), findsWidgets, reason: 'Item "$item" not found on receipt.');
    }
  }
  if (total != null) {
    await tester.ensureVisible(find.descendant(of: find.byKey(const Key('saleReceiptView')), matching: find.textContaining('Total: ${total.toStringAsFixed(2)}')));
    expect(find.descendant(of: find.byKey(const Key('saleReceiptView')), matching: find.textContaining('Total: ${total.toStringAsFixed(2)}')), findsOneWidget, reason: 'Total on receipt not matching or not found.');
  }
  print('Verified sale receipt.');
  await tester.pumpAndSettle();
}

// Note: parkSale likely involves tapping a button on QuickSellingView (or similar POS screen)
// and then potentially interacting with a dialog to name the parked sale/ticket.
Future<void> parkSale(WidgetTester tester, {String? ticketName}) async {
  // 1. Tap a "Park Sale" or "Hold" button on the main sales screen.
  //    (Placeholder: find.byKey(const Key('parkSaleButton')) or find.text('Park Sale'))
  // await tapButton(tester, find.byKey(const Key('parkSaleButton')), buttonName: 'Park Sale');
  
  if (ticketName != null) {
    // If a dialog appears to name the ticket:
    // await enterTextInField(tester, find.byKey(const Key('ticketNameFieldDialog')), ticketName, fieldName: 'Ticket Name Input');
    // await tapButton(tester, find.text('Save Ticket'), buttonName: 'Save Ticket Dialog');
  }
  // await expectSnackBarWithMessage(tester, 'Sale parked successfully');
  print('Parked sale${ticketName != null ? ' with name "$ticketName"' : ''}. (Interaction logic is a placeholder)');
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

// Note: resumeSaleFromTicket involves navigating to a dedicated "Tickets" or "Parked Sales" screen,
// finding the ticket, and tapping it to load it back into the sales view.
Future<void> resumeSaleFromTicket(WidgetTester tester, String ticketName) async {
  // 1. Navigate to parked sales / tickets list (e.g., from a menu or button on sales screen).
  // await tapButton(tester, find.byKey(const Key('navigateToParkedSalesScreenButton')));
  // await tester.pumpAndSettle();
  
  // 2. Find and tap the ticket with `ticketName` on the tickets screen.
  //    This might involve scrolling if there are many parked sales.
  final Finder ticketFinder = find.text(ticketName); // This assumes ticketName is unique and visible.
  // await tester.scrollUntilVisible(ticketFinder, 50.0, scrollable: find.byType(Scrollable)); 
  // await tapButton(tester, ticketFinder, buttonName: 'Ticket "$ticketName"');
  
  print('Resumed sale from ticket: "$ticketName". (Interaction logic is a placeholder)');
  // Expect to be back on the sales screen (e.g., QuickSellingView) with cart items loaded.
  await tester.pumpAndSettle();
}


// Settings Helpers
Future<void> setTaxConfiguration(WidgetTester tester, {bool? enableTax, bool? trainingMode}) async {
  // 1. Navigate to settings.
  // await tapButton(tester, find.byKey(const Key('settingsMenuButton')), buttonName: 'Settings');
  // await tapButton(tester, find.byKey(const Key('taxSettingsNavButton')), buttonName: 'Tax Settings');

  if (enableTax != null) {
    await enableFeatureToggle(tester, find.byKey(const Key('taxToggle')), enableTax, featureName: 'Tax Enabled');
  }
  if (trainingMode != null) {
    await enableFeatureToggle(tester, find.byKey(const Key('trainingModeToggle')), trainingMode, featureName: 'Training Mode');
  }
  
  // await tapButton(tester, find.byKey(const Key('saveSettingsButton')), buttonName: 'Save Settings');
  // await expectSnackBarWithMessage(tester, 'Settings saved');
  print('Set tax configuration: enableTax=$enableTax, trainingMode=$trainingMode.');
  await tester.pumpAndSettle();
}

Future<void> enableFeatureToggle(WidgetTester tester, Finder toggleFinder, bool enable, {String? featureName}) async {
  // This helper assumes the toggle is a standard Flutter Switch or similar.
  // It checks the current value and only taps if necessary.
  // For more complex custom toggles, this logic might need adjustment.
  
  // It's hard to get the current value of a generic 'Finder'.
  // Usually, you'd find a specific widget type like Switch and check its 'value' property.
  // Example for a Switch:
  // final Finder switchFinder = find.byKey(const Key('mySwitchKey')); // Be specific
  // bool currentValue = tester.widget<Switch>(switchFinder).value;
  // if (currentValue != enable) {
  //   await tester.tap(switchFinder);
  //   await tester.pumpAndSettle();
  // }

  // Simplified: tap the toggle. If it's already in the desired state, this might toggle it off.
  // A more robust solution would check the state first.
  // For now, this assumes tapping changes the state to the desired one or that
  // the toggle is always set from a known default.
  await tester.ensureVisible(toggleFinder);
  await tester.tap(toggleFinder);
  await tester.pumpAndSettle();
  print('${enable ? "Enabled" : "Disabled"} feature: ${featureName ?? toggleFinder.toString()}.');
  // Verification of the toggle state should be done after this call by the test itself.
}

// Common Verifications
Future<void> expectSnackBarWithMessage(WidgetTester tester, String message, {bool isError = false, Duration timeout = const Duration(seconds: 4)}) async {
  // This looks for a SnackBar widget.
  // Note: Default SnackBar uses Material widget internally for background.
  final snackBarFinder = find.byType(SnackBar); 
  
  await tester.pump(const Duration(milliseconds: 100)); // Allow time for SnackBar to start animating
  await tester.pumpAndSettle(); // Completes animations

  expect(snackBarFinder, findsOneWidget, reason: 'SnackBar not found.');
  expect(find.descendant(of: snackBarFinder, matching: find.text(message)), findsOneWidget, 
         reason: 'SnackBar with message "$message" not found.');

  if (isError) {
    // Example: Check for a specific background color if error SnackBars have one
    // final Material material = tester.widget<Material>(find.descendant(of: snackBarFinder, matching: find.byType(Material)));
    // expect(material.color, Colors.red); // Or your app's error color
  }
  
  // Wait for SnackBar to disappear by default (usually 4 seconds)
  // This pumpAndSettle should be long enough for it to go away.
  await tester.pumpAndSettle(timeout);
}

Future<void> expectDialogWithTitle(WidgetTester tester, String title, {Duration timeout = const Duration(seconds: 4)}) async {
  // Looks for an AlertDialog with a title widget that is a Text widget.
  final dialogFinder = find.byType(AlertDialog);
  
  await tester.pumpAndSettle(); // Ensure dialog is fully built

  expect(dialogFinder, findsOneWidget, reason: 'AlertDialog not found.');
  expect(
    find.descendant(
      of: dialogFinder, 
      matching: find.widgetWithText(Title, title) // Common for dialog titles
    ), 
    findsOneWidget, 
    reason: 'Dialog with title "$title" not found.'
  );
  // Do not automatically dismiss the dialog here, let the test decide next steps.
}

Future<void> tapButton(WidgetTester tester, Finder buttonFinder, {String? buttonName}) async {
  await tester.ensureVisible(buttonFinder); // Scroll if necessary
  await tester.tap(buttonFinder);
  await tester.pumpAndSettle(); // Wait for animations and UI updates
  if (buttonName != null) {
    print('Tapped button: "$buttonName".');
  } else {
    print('Tapped button: ${buttonFinder.toString()}.');
  }
}

Future<void> enterTextInField(WidgetTester tester, Finder fieldFinder, String text, {String? fieldName}) async {
  await tester.ensureVisible(fieldFinder); // Scroll if necessary
  await tester.enterText(fieldFinder, text);
  await tester.pumpAndSettle(); // Wait for UI to update, e.g., if there's validation or formatting
  if (fieldName != null) {
    print('Entered "$text" in field: "$fieldName".');
  } else {
    print('Entered "$text" in field: ${fieldFinder.toString()}.');
  }
}

/// desktop test cases
Future<void> startAppAndPump(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 12));
}

Future<void> verifyLoginPage(WidgetTester tester) async {
  expect(find.text('Log in to Flipper by QR Code'), findsOneWidget);
  await tester.tap(find.byKey(const Key('pinLogin')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.byType(Form), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);
}

Future<void> enterEmptyPINAndVerifyErrorMessage(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.text('PIN is required'), findsOneWidget);
}

Future<void> enterNonEmptyPINAndLogIn(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '1234');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.enterText(find.byType(TextFormField), '67814');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.tap(find.byKey(const Key('openDrawerPage')));
}

/// end of desktop

/// start of android

Future<void> runAppAndVerifyInitialScreen(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
  expect(find.text('Create Account'), findsOneWidget);
  expect(find.text('Sign In'), findsOneWidget);
}

Future<void> tapSignInButtonAndVerifyOptions(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('signInButtonKey')));
  await tester.pumpAndSettle();
  expect(find.text("Phone Number"), findsOneWidget);
  expect(find.byKey(const Key('phoneNumberLogin')), findsOneWidget);
  expect(find.byKey(const Key('googleLogin')), findsOneWidget);
  expect(find.byKey(const Key('microsoftLogin')), findsOneWidget);
  expect(find.text("How would you like to proceed?"), findsOneWidget);
}

Future<void> testPINLogin(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('pinLogin')));
  await tester.pumpAndSettle();
  expect(find.byType(Form), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);

  // Simulate entering an empty PIN
  await tester.enterText(find.byType(TextFormField), '');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.text('PIN is required'), findsOneWidget);

  // Simulate entering a non-empty PIN
  await tester.enterText(find.byType(TextFormField), '1234');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 5));

  // Log in with real PIN and go to openDrawerPage
  await tester.enterText(find.byType(TextFormField), '67814');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.tap(find.byKey(const Key('openDrawerPage')));
}
