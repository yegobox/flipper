import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_leave_repository.dart';

void main() {
  group('LeaveBalance.of', () {
    test('a year with nothing booked leaves the full entitlement', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: const [],
      );

      expect(balance.entitlement, 18);
      expect(balance.committed, 0);
      expect(balance.remaining, 18);
      expect(balance.isExhausted, isFalse);
    });

    test('approved days are spent', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 5, status: LeaveStatus.approved),
        ],
      );

      expect(balance.approved, 5);
      expect(balance.remaining, 13);
    });

    test('pending days are held, so two requests cannot both look affordable',
        () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 10, status: LeaveStatus.approved),
          leaveRequest(id: 'b', days: 6, status: LeaveStatus.pending),
        ],
      );

      expect(balance.approved, 10);
      expect(balance.pending, 6);
      expect(balance.committed, 16);
      expect(balance.remaining, 2);
    });

    test('rejected and cancelled days cost nothing', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 8, status: LeaveStatus.rejected),
          leaveRequest(id: 'b', days: 4, status: LeaveStatus.cancelled),
        ],
      );

      expect(balance.committed, 0);
      expect(balance.remaining, 18);
    });

    test('only counts the requested type', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 5, status: LeaveStatus.approved),
          leaveRequest(
            id: 'b',
            type: LeaveType.sick,
            days: 4,
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(balance.remaining, 13);
    });

    test('only counts the requested year, by start date', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(
            id: 'a',
            startDate: DateTime(2025, 9, 7),
            endDate: DateTime(2025, 9, 11),
            days: 5,
            status: LeaveStatus.approved,
          ),
          // Straddles New Year, charged to 2026 because it starts there.
          leaveRequest(
            id: 'b',
            startDate: DateTime(2026, 12, 28),
            endDate: DateTime(2027, 1, 8),
            days: 8,
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(balance.approved, 8);
      expect(balance.remaining, 10);
    });

    test('a contract override replaces the statutory annual entitlement', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: const [],
        annualOverride: 25,
      );

      expect(balance.entitlement, 25);
      expect(balance.remaining, 25);
    });

    test('the override applies to annual leave only', () {
      final sick = LeaveBalance.of(
        type: LeaveType.sick,
        year: 2026,
        requests: const [],
        annualOverride: 25,
      );

      expect(sick.entitlement, 15);
    });

    test('an override of zero means zero, not the statutory default', () {
      // The distinction the nullable column exists for: null is "use 18", 0 is
      // "none at all".
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: const [],
        annualOverride: 0,
      );

      expect(balance.entitlement, 0);
      expect(balance.isExhausted, isTrue);
    });

    test('unpaid leave has no cap, so nothing is remaining or exhausted', () {
      final balance = LeaveBalance.of(
        type: LeaveType.unpaid,
        year: 2026,
        requests: [
          leaveRequest(
            id: 'a',
            type: LeaveType.unpaid,
            days: 40,
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(balance.isCapped, isFalse);
      expect(balance.entitlement, isNull);
      expect(balance.remaining, isNull);
      expect(balance.isExhausted, isFalse);
      expect(balance.usedFraction, isNull);
      // The days are still counted; there is just no denominator.
      expect(balance.committed, 40);
    });

    test('an overdraft shows as negative rather than clamping to zero', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 20, status: LeaveStatus.approved),
        ],
      );

      expect(balance.remaining, -2);
      expect(balance.isExhausted, isTrue);
      // The bar still cannot overflow.
      expect(balance.usedFraction, 1);
    });

    test('usedFraction is the committed share of the entitlement', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 9, status: LeaveStatus.approved),
        ],
      );

      expect(balance.usedFraction, 0.5);
    });

    test('a zero entitlement has no fraction to show', () {
      final balance = LeaveBalance.of(
        type: LeaveType.annual,
        year: 2026,
        requests: const [],
        annualOverride: 0,
      );

      expect(balance.usedFraction, isNull);
    });
  });

  group('LeaveBalance.allFor', () {
    test('returns every type in declaration order', () {
      final balances = LeaveBalance.allFor(year: 2026, requests: const []);

      expect(
        [for (final b in balances) b.type],
        LeaveType.values,
      );
    });

    test('applies the annual override to the annual entry only', () {
      final balances = LeaveBalance.allFor(
        year: 2026,
        requests: const [],
        annualOverride: 30,
      );
      final byType = {for (final b in balances) b.type: b};

      expect(byType[LeaveType.annual]!.entitlement, 30);
      expect(byType[LeaveType.sick]!.entitlement, 15);
    });

    test('splits a mixed history across the right types', () {
      final balances = LeaveBalance.allFor(
        year: 2026,
        requests: [
          leaveRequest(id: 'a', days: 5, status: LeaveStatus.approved),
          leaveRequest(
            id: 'b',
            type: LeaveType.sick,
            days: 3,
            status: LeaveStatus.approved,
          ),
          leaveRequest(
            id: 'c',
            type: LeaveType.sick,
            days: 2,
            status: LeaveStatus.pending,
          ),
        ],
      );
      final byType = {for (final b in balances) b.type: b};

      expect(byType[LeaveType.annual]!.remaining, 13);
      expect(byType[LeaveType.sick]!.approved, 3);
      expect(byType[LeaveType.sick]!.pending, 2);
      expect(byType[LeaveType.sick]!.remaining, 10);
      expect(byType[LeaveType.paternity]!.remaining, 4);
    });

    test('accepts a lazy iterable without re-walking it per type', () {
      // allFor materialises its input; passing a one-shot iterable would throw
      // if it did not.
      final once = [
        leaveRequest(id: 'a', days: 5, status: LeaveStatus.approved),
      ].map((r) => r);

      final balances = LeaveBalance.allFor(year: 2026, requests: once);
      final annual = balances.firstWhere((b) => b.type == LeaveType.annual);

      expect(annual.remaining, 13);
    });
  });

  group('entitlementFor', () {
    test('null override keeps the statutory figure', () {
      expect(
        LeaveBalance.entitlementFor(LeaveType.annual, annualOverride: null),
        18,
      );
    });

    test('uncapped types stay uncapped whatever the override', () {
      expect(
        LeaveBalance.entitlementFor(LeaveType.unpaid, annualOverride: 25),
        isNull,
      );
    });
  });
}
