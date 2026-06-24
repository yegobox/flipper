import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/rra_sar_sequence.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/transactionItemUtil.dart';
import 'package:supabase_models/brick/repository.dart';

const _rraRetryAttempts = 3;
const _rraRetryBaseDelay = Duration(seconds: 2);

/// True when [saveItems] succeeded locally but stock/master steps did not finish.
bool rraItemsRegisteredLocally(Variant variant) {
  return variant.ebmSynced != true &&
      variant.stockSynchronized == false &&
      variant.itemCd != null &&
      variant.itemCd!.trim().isNotEmpty;
}

bool isTransientRraNetworkError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('timeout') ||
      message.contains('connection') ||
      message.contains('socket') ||
      message.contains('network') ||
      message.contains('unexpected error occurred');
}

Future<T> retryTransientRraCall<T>(Future<T> Function() action) async {
  Object? lastError;
  for (var attempt = 0; attempt < _rraRetryAttempts; attempt++) {
    try {
      return await action();
    } catch (error) {
      lastError = error;
      final isLastAttempt = attempt == _rraRetryAttempts - 1;
      if (!isTransientRraNetworkError(error) || isLastAttempt) {
        rethrow;
      }
      await Future<void>.delayed(_rraRetryBaseDelay * (attempt + 1));
    }
  }
  throw lastError ?? Exception('RRA call failed');
}

void _mirrorRraProgress(Variant source, Variant target) {
  target.ebmSynced = source.ebmSynced;
  target.stockSynchronized = source.stockSynchronized;
  target.itemCd = source.itemCd;
  target.tin = source.tin;
  target.bhfId = source.bhfId;
  target.qty = source.qty;
  target.rsdQty = source.rsdQty;
}

/// DesktopProductAdd / bulk-add RRA sequence: saveItems → SAR → saveStockItems → saveStockMaster.
///
/// Persists partial progress ([stockSynchronized] = false after saveItems) so a failed
/// stock step can be retried without re-calling saveItems.
Future<void> registerVariantWithRraForAdd({
  required Repository repository,
  required String branchId,
  required Variant variantToSave,
  required Variant variantInput,
  required String serverUrl,
  required Ebm ebm,
  Ditto? ditto,
}) async {
  final stockQty = variantToSave.stock?.currentStock ?? 0;
  if (stockQty > 0) {
    variantToSave.qty = stockQty;
    variantToSave.rsdQty = stockQty;
  }

  if (variantToSave.tin == null || variantToSave.tin == 0) {
    variantToSave.tin = ebm.tinNumber;
  }
  if (variantToSave.bhfId == null || variantToSave.bhfId!.trim().isEmpty) {
    variantToSave.bhfId = ebm.bhfId;
  }

  if (!rraItemsRegisteredLocally(variantToSave)) {
    final saveResp = await retryTransientRraCall(
      () => ProxyService.tax.saveItem(
        variation: variantToSave,
        URI: serverUrl,
      ),
    );
    if (saveResp.resultCd != '000') {
      throw Exception(
        'RRA saveItems failed for ${variantToSave.name}: '
        '${saveResp.resultMsg} (${saveResp.resultCd})',
      );
    }
    variantToSave.stockSynchronized = false;
    _mirrorRraProgress(variantToSave, variantInput);
    await repository.upsert<Variant>(variantToSave);
  }

  if (variantToSave.itemTyCd == '3') {
    variantToSave.ebmSynced = true;
    variantToSave.stockSynchronized = true;
    _mirrorRraProgress(variantToSave, variantInput);
    await repository.upsert<Variant>(variantToSave);
    return;
  }

  final sar = await incrementAndPersistBranchSar(
    repository: repository,
    branchId: branchId,
    ditto: ditto,
  );

  final supplyUnit = variantToSave.supplyPrice ?? 0;
  final retailUnit = variantToSave.retailPrice ?? 0;

  final stockIoResp = await retryTransientRraCall(
    () => ProxyService.tax.saveStockItems(
      updateMaster: false,
      items: [TransactionItemUtil.fromVariant(variantToSave, itemSeq: 1)],
      tinNumber: ebm.tinNumber.toString(),
      bhFId: ebm.bhfId,
      totalSupplyPrice: supplyUnit * stockQty,
      totalvat: 0,
      totalAmount: retailUnit * stockQty,
      sarTyCd: '06',
      sarNo: sar.sarNo.toString(),
      invoiceNumber: sar.sarNo,
      remark: 'Stock In from adding new item',
      ocrnDt: DateTime.now().toUtc(),
      URI: serverUrl,
    ),
  );
  if (stockIoResp.resultCd != '000') {
    throw Exception(
      'RRA saveStockItems failed for ${variantToSave.name}: '
      '${stockIoResp.resultMsg} (${stockIoResp.resultCd})',
    );
  }

  final masterResp = await retryTransientRraCall(
    () => ProxyService.tax.saveStockMaster(
      variant: variantToSave,
      URI: serverUrl,
      stockMasterQty: stockQty,
    ),
  );
  if (masterResp.resultCd != '000') {
    throw Exception(
      'RRA saveStockMaster failed for ${variantToSave.name}: '
      '${masterResp.resultMsg} (${masterResp.resultCd})',
    );
  }

  variantToSave.ebmSynced = true;
  variantToSave.stockSynchronized = true;
  _mirrorRraProgress(variantToSave, variantInput);
  await repository.upsert<Variant>(variantToSave);
}
