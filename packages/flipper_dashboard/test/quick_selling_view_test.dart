import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

import '../lib/QuickSellingView.dart';

// Mock classes for testing
class MockITransaction extends Mock implements ITransaction {}

void main() {
  group('QuickSellingView Tests', () {
    test('QuickSellingView creates widget successfully', () {
      final formKey = GlobalKey<FormState>();
      final discountController = TextEditingController();
      final receivedAmountController = TextEditingController();
      final deliveryNoteController = TextEditingController();
      final customerPhoneNumberController = TextEditingController();
      final paymentTypeController = TextEditingController();
      final countryCodeController = TextEditingController();

      final widget = QuickSellingView(
        formKey: formKey,
        discountController: discountController,
        receivedAmountController: receivedAmountController,
        deliveryNoteCotroller: deliveryNoteController,
        customerPhoneNumberController: customerPhoneNumberController,
        paymentTypeController: paymentTypeController,
        countryCodeController: countryCodeController,
      );

      expect(widget, isNotNull);
      expect(widget.formKey, equals(formKey));
      expect(widget.discountController, equals(discountController));
      expect(widget.receivedAmountController, equals(receivedAmountController));
    });

    test('QuickSellingView constructor parameters are correctly assigned', () {
      final formKey = GlobalKey<FormState>();
      final discountController = TextEditingController(text: '10');
      final receivedAmountController = TextEditingController(text: '100');
      final deliveryNoteController = TextEditingController(text: 'Test delivery note');
      final customerPhoneNumberController = TextEditingController(text: '+1234567890');
      final paymentTypeController = TextEditingController(text: 'Cash');
      final countryCodeController = TextEditingController(text: '+1');

      final widget = QuickSellingView(
        formKey: formKey,
        discountController: discountController,
        receivedAmountController: receivedAmountController,
        deliveryNoteCotroller: deliveryNoteController,
        customerPhoneNumberController: customerPhoneNumberController,
        paymentTypeController: paymentTypeController,
        countryCodeController: countryCodeController,
      );

      expect(widget.formKey, equals(formKey));
      expect(widget.discountController.text, equals('10'));
      expect(widget.receivedAmountController.text, equals('100'));
      expect(widget.deliveryNoteCotroller.text, equals('Test delivery note'));
      expect(widget.customerPhoneNumberController.text, equals('+1234567890'));
      expect(widget.paymentTypeController.text, equals('Cash'));
      expect(widget.countryCodeController.text, equals('+1'));
    });
  });
}