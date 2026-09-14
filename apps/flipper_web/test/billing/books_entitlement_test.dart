import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/data/books_entitlement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 14, 12);
  final future = now.add(const Duration(days: 10));
  final past = now.subtract(const Duration(days: 1));

  BooksAccessState evaluate(Plan? plan, {int? businessTypeId, bool isDefault = false}) =>
      evaluateBooksEntitlement(
        plan,
        now: now,
        businessTypeId: businessTypeId,
        isDefault: isDefault,
      );

  group('evaluateBooksEntitlement', () {
    test('no row means the business has never subscribed', () {
      final state = evaluate(null);
      expect(state.status, BooksAccessStatus.noPlan);
      expect(state.grantsAccess, isFalse);
      expect(state.needsPayment, isTrue);
    });

    test('paid and inside the period is entitled', () {
      final state = evaluate(
        Plan(paymentCompletedByUser: true, nextBillingDate: future),
      );
      expect(state.status, BooksAccessStatus.entitled);
      expect(state.grantsAccess, isTrue);
      expect(state.validUntil, future);
      expect(state.daysLeft(now: now), 10);
    });

    test('payment_status COMPLETED counts as paid, whatever the case', () {
      final state = evaluate(
        Plan(
          paymentCompletedByUser: false,
          paymentStatus: 'completed',
          nextBillingDate: future,
        ),
      );
      expect(state.status, BooksAccessStatus.entitled);
    });

    test('a paid period that ended is expired', () {
      final state = evaluate(
        Plan(paymentCompletedByUser: true, nextBillingDate: past),
      );
      expect(state.status, BooksAccessStatus.expired);
      expect(state.hasLapsed, isTrue);
      expect(state.grantsAccess, isFalse);
    });

    test('an unpaid row past its date is expired too, not merely unpaid', () {
      final state = evaluate(Plan(nextBillingDate: past));
      expect(state.status, BooksAccessStatus.expired);
    });

    test('unpaid with a charge in flight is awaiting settlement', () {
      final state = evaluate(
        Plan(paymentStatus: 'PENDING', nextBillingDate: future),
      );
      expect(state.status, BooksAccessStatus.awaitingSettlement);
      expect(state.isAwaitingSettlement, isTrue);
      expect(state.grantsAccess, isFalse);
    });

    test('unpaid with no status needs payment', () {
      final state = evaluate(Plan(nextBillingDate: future));
      expect(state.status, BooksAccessStatus.needsPayment);
    });

    test('unpaid with no date at all needs payment', () {
      final state = evaluate(Plan());
      expect(state.status, BooksAccessStatus.needsPayment);
    });

    test('a default Individual business is waived, like on the phone', () {
      final state = evaluate(null, businessTypeId: 2, isDefault: true);
      expect(state.status, BooksAccessStatus.entitled);
      expect(state.waived, isTrue);
      expect(state.grantsAccess, isTrue);
    });

    test('the waiver needs both the type and the default flag', () {
      expect(
        evaluate(null, businessTypeId: 2).status,
        BooksAccessStatus.noPlan,
      );
      expect(
        evaluate(null, businessTypeId: 1, isDefault: true).status,
        BooksAccessStatus.noPlan,
      );
    });

    test('unknown grants access so an outage never locks a payer out', () {
      const state = BooksAccessState.unknown();
      expect(state.grantsAccess, isTrue);
    });

    test('remembers the number that paid last time', () {
      final state = evaluate(
        Plan(paymentCompletedByUser: true, nextBillingDate: past, phoneNumber: '0788123456'),
      );
      expect(state.phoneNumber, '0788123456');
    });
  });
}
