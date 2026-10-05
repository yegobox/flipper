import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/sync/utils/branch_transfer_rra.dart';
import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flipper_models/sync/utils/rra_sar_sequence.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:meta/meta.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// One approved purchase line as stocked in to a catalog variant.
class PurchaseStockInLine {
  const PurchaseStockInLine({
    required this.variant,
    required this.qty,
    required this.onHandAfter,
    this.stockId,
  });

  /// The catalog variant that received the stock.
  final Variant variant;
  final double qty;

  /// Its on-hand after the increment, for the RRA stock master.
  final double onHandAfter;
  final String? stockId;
}

/// Reports an approved purchase's stock-in to RRA: one StockIO (`06`,
/// incoming adjustment — what data-connector sends for approved purchases)
/// for all lines, then each variant's stock master.
///
/// Never throws and never undoes the local stock: like branch transfers, a
/// tax-server failure is reported back as a message for the owner. Skips for
/// non-VAT / non-EBM branches.
Future<BranchTransferRraResult> reportPurchaseStockInToRra({
  required String branchId,
  required List<PurchaseStockInLine> lines,
  required String supplierName,
  required PurchaseApprovalDeps deps,
  String supplierTin = '',
  String? businessId,
  @visibleForTesting Future<Ebm?> Function(String businessId)? resolveEbm,
  @visibleForTesting Future<Sar> Function(String branchId)? nextBranchSar,
}) async {
  final stocked = lines.where((l) => l.qty > 0).toList();
  if (stocked.isEmpty) return BranchTransferRraResult.skipped;

  try {
    final branchEbm = await deps.strategy.ebm(
      branchId: branchId,
      fetchRemote: false,
    );
    if (branchEbm?.vatEnabled != true) return BranchTransferRraResult.skipped;

    final resolvedBusinessId = businessId ?? deps.businessId;
    if (resolvedBusinessId == null || resolvedBusinessId.isEmpty) {
      return BranchTransferRraResult.skipped;
    }
    final businessEbm = await (resolveEbm ?? resolveBusinessEbm)(
      resolvedBusinessId,
    );
    final taxUrl = businessEbm?.taxServerUrl?.trim();
    final bhfId = branchEbm?.bhfId.trim();
    if (businessEbm == null ||
        taxUrl == null ||
        taxUrl.isEmpty ||
        bhfId == null ||
        bhfId.isEmpty) {
      return BranchTransferRraResult.skipped;
    }
    final tin = businessEbm.tinNumber.toString();

    final items = <TransactionItem>[];
    double totalSupply = 0;
    double totalAmount = 0;
    for (final line in stocked) {
      final v = line.variant;
      final supply = (v.supplyPrice ?? v.retailPrice ?? 0).toDouble();
      final retail = (v.retailPrice ?? v.supplyPrice ?? 0).toDouble();
      totalSupply += supply * line.qty;
      totalAmount += retail * line.qty;
      items.add(
        TransactionItem(
          name: v.name,
          qty: line.qty,
          price: retail,
          discount: 0,
          prc: retail,
          supplyPrice: supply,
          ttCatCd: v.taxTyCd ?? 'B',
          taxTyCd: v.taxTyCd ?? 'B',
          itemCd: v.itemCd,
          itemClsCd: v.itemClsCd,
          itemNm: v.name,
          itemTyCd: v.itemTyCd,
          qtyUnitCd: v.qtyUnitCd ?? 'U',
          pkgUnitCd: v.pkgUnitCd ?? 'NT',
          variantId: v.id,
          branchId: branchId,
        ),
      );
    }

    final sar =
        await (nextBranchSar?.call(branchId) ??
            incrementAndPersistBranchSar(
              repository: Repository(),
              branchId: branchId,
              ditto: DittoService.instance.dittoInstance,
            ));
    final hasTin = RegExp(r'^\d{9}$').hasMatch(supplierTin.trim());
    final ioResp = await retryTransientRraCall(
      () => deps.tax.saveStockItems(
        items: items,
        updateMaster: false,
        tinNumber: tin,
        bhFId: bhfId,
        sarTyCd: StockInOutType.adjustmentIn,
        isStockIn: true,
        customerName: supplierName,
        custTin: hasTin ? supplierTin.trim() : null,
        includeCustomerFields: hasTin,
        regTyCd: 'M',
        totalSupplyPrice: totalSupply,
        totalvat: 0,
        totalAmount: totalAmount,
        remark: 'Purchase from $supplierName',
        ocrnDt: DateTime.now(),
        sarNo: sar.sarNo.toString(),
        invoiceNumber: sar.sarNo,
        URI: taxUrl,
      ),
    );
    if (ioResp.resultCd != '000') {
      talker.error(
        'PurchaseStockRra IO failed: ${ioResp.resultCd} ${ioResp.resultMsg}',
      );
      return BranchTransferRraResult(
        attempted: true,
        succeeded: false,
        message: userFacingBranchTransferRraFailure(
          ioResp.resultMsg.isEmpty
              ? 'Stock IN to EBM failed'
              : ioResp.resultMsg,
        ),
      );
    }

    var mastersSucceeded = true;
    for (final line in stocked) {
      final resp = await retryTransientRraCall(
        () => deps.tax.saveStockMaster(
          variant: line.variant,
          URI: taxUrl,
          stockMasterQty: line.onHandAfter,
        ),
      );
      if (resp.resultCd == '000') {
        final stockId = line.stockId;
        if (stockId != null) {
          await deps.strategy.updateStock(stockId: stockId, ebmSynced: true);
        }
      } else {
        mastersSucceeded = false;
        talker.error(
          'PurchaseStockRra master failed for ${line.variant.id}: '
          '${resp.resultCd} ${resp.resultMsg}',
        );
      }
    }
    return mastersSucceeded
        ? const BranchTransferRraResult(attempted: true, succeeded: true)
        : BranchTransferRraResult(
            attempted: true,
            succeeded: false,
            message: userFacingBranchTransferRraFailure(
              'Stock master update failed',
            ),
          );
  } catch (e, s) {
    talker.error('PurchaseStockRra failed: $e', s);
    return BranchTransferRraResult(
      attempted: true,
      succeeded: false,
      message: userFacingBranchTransferRraFailure(e),
    );
  }
}
