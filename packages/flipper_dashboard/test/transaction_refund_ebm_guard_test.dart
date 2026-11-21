import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

// flutter test test/transaction_refund_ebm_guard_test.dart
//
// An EBM refund goes to RRA as a refund receipt. Reading an unknown EBM status
// as "off" used to complete the refund locally with no RRA record.

void main() {
  final service = TransactionRefundService(talker: Talker());

  test('an EBM branch refunds through RRA', () async {
    expect(await service.requireEbmStatus(() async => true), isTrue);
  });

  test('a branch off EBM refunds locally', () async {
    expect(await service.requireEbmStatus(() async => false), isFalse);
  });

  test('an unreadable EBM status blocks the refund', () {
    expect(
      service.requireEbmStatus(() async => throw StateError('no branch')),
      throwsA(
        isA<TransactionRefundException>().having(
          (e) => e.message,
          'message',
          FlipperL10n.current.refundEbmCheckFailed,
        ),
      ),
    );
  });
}
