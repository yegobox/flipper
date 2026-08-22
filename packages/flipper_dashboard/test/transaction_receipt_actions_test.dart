import 'dart:typed_data';

import 'package:flipper_dashboard/services/stored_receipt_loader.dart';
import 'package:flipper_dashboard/services/transaction_receipt_actions_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class _FakeLoader extends StoredReceiptLoader {
  _FakeLoader(this.result);

  final StoredReceipt? result;
  int calls = 0;

  @override
  Future<StoredReceipt?> load(ITransaction transaction) async {
    calls++;
    return result;
  }
}

ITransaction _sale({String? receiptFileName}) => ITransaction(
      id: 'tx-1',
      branchId: 'branch-1',
      agentId: 'agent-1',
      status: 'complete',
      transactionType: 'Sale',
      subTotal: 161000,
      paymentType: 'CREDIT',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.utc(2026, 8, 22, 17, 36),
      isIncome: true,
      isExpense: false,
      receiptFileName: receiptFileName,
    );

final _fallbackBytes = Uint8List.fromList('%PDF-fallback'.codeUnits);
final _storedBytes = Uint8List.fromList('%PDF-stored'.codeUnits);

void main() {
  test('builds a local copy when the sale has no stored receipt', () async {
    final loader = _FakeLoader(null);
    var built = 0;
    final service = TransactionReceiptActionsService(
      loader: loader,
      fallbackBuilder: (_, __) async {
        built++;
        return _fallbackBytes;
      },
    );

    final resolved = await service.resolveReceipt(_sale(), null);

    expect(built, 1);
    expect(loader.calls, 0, reason: 'nothing stored to load');
    expect(resolved.bytes, _fallbackBytes);
    expect(resolved.fiscal, isFalse);
  });

  test('prefers the stored EBM receipt when one exists', () async {
    final loader = _FakeLoader(
      StoredReceipt(bytes: _storedBytes, localPath: '/tmp/receipt.pdf'),
    );
    var built = 0;
    final service = TransactionReceiptActionsService(
      loader: loader,
      fallbackBuilder: (_, __) async {
        built++;
        return _fallbackBytes;
      },
    );

    final resolved = await service.resolveReceipt(
      _sale(receiptFileName: 'receipt-1.pdf'),
      null,
    );

    expect(loader.calls, 1);
    expect(built, 0);
    expect(resolved.bytes, _storedBytes);
    expect(resolved.localPath, '/tmp/receipt.pdf');
    expect(resolved.fiscal, isTrue);
  });

  test('falls back when a stamped receipt file cannot be loaded', () async {
    final loader = _FakeLoader(null);
    final service = TransactionReceiptActionsService(
      loader: loader,
      fallbackBuilder: (_, __) async => _fallbackBytes,
    );

    final resolved = await service.resolveReceipt(
      _sale(receiptFileName: 'receipt-1.pdf'),
      null,
    );

    expect(loader.calls, 1);
    expect(resolved.bytes, _fallbackBytes);
    expect(resolved.fiscal, isFalse);
  });

  test('reports a friendly error when the copy cannot be built', () async {
    final service = TransactionReceiptActionsService(
      loader: _FakeLoader(null),
      fallbackBuilder: (_, __) async => throw StateError('boom'),
    );

    expect(
      () => service.resolveReceipt(_sale(), null),
      throwsA(
        isA<TransactionReceiptException>().having(
          (e) => e.message,
          'message',
          contains('Could not prepare a receipt'),
        ),
      ),
    );
  });

  test('empty bytes are treated as a failure, not a document', () async {
    final service = TransactionReceiptActionsService(
      loader: _FakeLoader(null),
      fallbackBuilder: (_, __) async => Uint8List(0),
    );

    expect(
      () => service.resolveReceipt(_sale(), null),
      throwsA(isA<TransactionReceiptException>()),
    );
  });
}
