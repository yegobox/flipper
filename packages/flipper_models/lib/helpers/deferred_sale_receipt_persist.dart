import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/counter.model.dart' as brick_counter;

/// Receipt + counter writes deferred until after sale UI success (Quick Selling).
class DeferredSaleReceiptPersist {
  const DeferredSaleReceiptPersist({
    required this.receiptSignature,
    required this.transaction,
    required this.qrCode,
    required this.highestInvcNo,
    required this.receiptNumber,
    required this.whenCreated,
    required this.counters,
    required this.receiptType,
    this.consumedInvcNo,
  });

  final RwApiResponse receiptSignature;
  final ITransaction transaction;
  final String qrCode;
  final int highestInvcNo;
  final String receiptNumber;
  final DateTime whenCreated;
  final List<brick_counter.Counter> counters;
  final String receiptType;
  final int? consumedInvcNo;
}

/// In-memory receipt for PDF before [createReceipt] completes.
Receipt buildPresentationReceipt({
  required RwApiResponse receiptSignature,
  required ITransaction transaction,
  required String qrCode,
  required int highestInvcNo,
  required String receiptNumber,
  required DateTime whenCreated,
  required String receiptType,
}) {
  final branchId = ProxyService.box.getBranchId() ?? '';
  final vsdc = receiptSignature.data?.vsdcRcptPbctDate ?? '';
  return Receipt(
    transactionId: transaction.id,
    branchId: branchId,
    resultCd: receiptSignature.resultCd,
    resultMsg: receiptSignature.resultMsg,
    resultDt: receiptSignature.resultDt ?? '',
    rcptNo: receiptSignature.data?.rcptNo ?? 0,
    intrlData: receiptSignature.data?.intrlData ?? '',
    rcptSign: receiptSignature.data?.rcptSign ?? '',
    totRcptNo: receiptSignature.data?.totRcptNo ?? 0,
    vsdcRcptPbctDate: vsdc,
    sdcId: receiptSignature.data?.sdcId ?? '',
    mrcNo: receiptSignature.data?.mrcNo ?? '',
    qrCode: qrCode,
    receiptType: receiptType,
    invcNo: highestInvcNo,
    invoiceNumber: highestInvcNo,
    whenCreated: whenCreated,
    timeReceivedFromserver: vsdc.isNotEmpty ? DateTime.tryParse(vsdc) : whenCreated,
  );
}

Future<void> persistDeferredSaleReceipt(DeferredSaleReceiptPersist deferred) async {
  final sw = Stopwatch()..start();
  final tax = TaxController<ITransaction>(object: deferred.transaction);
  await tax.saveReceipt(
    deferred.receiptSignature,
    deferred.transaction,
    deferred.qrCode,
    deferred.highestInvcNo,
    deferred.receiptNumber,
    whenCreated: deferred.whenCreated,
    invoiceNumber: deferred.highestInvcNo,
  );
  await ProxyService.getStrategy(Strategy.capella).updateCounters(
    counters: deferred.counters,
    receiptSignature: deferred.receiptSignature,
    consumedInvcNo:
        deferred.consumedInvcNo ??
        deferred.receiptSignature.usedInvcNo ??
        deferred.highestInvcNo,
  );
  talker.debug(
    '[sale_completion_timing] deferred_receipt_persist_ms=${sw.elapsedMilliseconds}',
  );
}

void scheduleDeferredSaleReceiptPersist(DeferredSaleReceiptPersist? deferred) {
  if (deferred == null) return;
  unawaited(
    persistDeferredSaleReceipt(deferred).catchError((e, s) {
      talker.error('Deferred receipt persist failed: $e', s);
    }),
  );
}
