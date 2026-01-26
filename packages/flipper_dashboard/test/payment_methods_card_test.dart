import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/widgets/payment_methods_card.dart';

void main() {
  group('PaymentMethodsCard Tests', () {
    test('PaymentMethodsCard widget can be instantiated', () {
      final widget = PaymentMethodsCard(
        transactionId: 'test-id',
        totalPayable: 100.0,
      );
      
      expect(widget, isNotNull);
      expect(widget.transactionId, equals('test-id'));
      expect(widget.totalPayable, equals(100.0));
      expect(widget.isCardView, isTrue);
    });

    test('PaymentMethodsCard widget with custom isCardView', () {
      final widget = PaymentMethodsCard(
        transactionId: 'another-id',
        totalPayable: 50.0,
        isCardView: false,
      );
      
      expect(widget, isNotNull);
      expect(widget.transactionId, equals('another-id'));
      expect(widget.totalPayable, equals(50.0));
      expect(widget.isCardView, isFalse);
    });

    test('PaymentMethodsCard properties are correctly assigned', () {
      const key = Key('test-key');
      const transactionId = '12345';
      const totalPayable = 250.75;
      const isCardView = true;
      
      final widget = PaymentMethodsCard(
        key: key,
        transactionId: transactionId,
        totalPayable: totalPayable,
        isCardView: isCardView,
      );
      
      expect(widget.key, equals(key));
      expect(widget.transactionId, equals(transactionId));
      expect(widget.totalPayable, equals(totalPayable));
      expect(widget.isCardView, equals(isCardView));
    });

    test('PaymentMethodsCard widget has correct default value for isCardView', () {
      final widget = PaymentMethodsCard(
        transactionId: 'default-test',
        totalPayable: 75.50,
      );
      
      expect(widget.isCardView, isTrue); // Default value should be true
    });

    test('PaymentMethodsCard widget with zero totalPayable', () {
      final widget = PaymentMethodsCard(
        transactionId: 'zero-total',
        totalPayable: 0.0,
      );
      
      expect(widget.totalPayable, equals(0.0));
    });

    test('PaymentMethodsCard widget with negative totalPayable', () {
      final widget = PaymentMethodsCard(
        transactionId: 'negative-total',
        totalPayable: -10.0,
      );
      
      expect(widget.totalPayable, equals(-10.0));
    });

    test('PaymentMethodsCard widget with large totalPayable', () {
      final widget = PaymentMethodsCard(
        transactionId: 'large-total',
        totalPayable: 999999.99,
      );
      
      expect(widget.totalPayable, equals(999999.99));
    });
  });
}