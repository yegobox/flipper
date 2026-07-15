import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:meta/meta.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flipper_models/sync/utils/rra_sar_sequence.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// One line stock-moved during a branch-transfer approval (local Capella already applied).
class BranchTransferApprovedLine {
  const BranchTransferApprovedLine({
    required this.sourceVariant,
    required this.destVariant,
    required this.approvedQty,
    required this.itemName,
  });

  final Variant sourceVariant;
  final Variant destVariant;
  final int approvedQty;
  final String itemName;
}

/// Result of attempting RRA report (never throws into callers for soft failures).
class BranchTransferRraResult {
  const BranchTransferRraResult({
    required this.attempted,
    required this.succeeded,
    this.message,
  });

  final bool attempted;
  final bool succeeded;
  final String? message;

  static const skipped = BranchTransferRraResult(
    attempted: false,
    succeeded: true,
    message: null,
  );
}

/// Posts RRA StockIO OUT (`13`) / IN (`04`) + dual StockMaster after a branch transfer.
///
/// Gate is **business-scoped** EBM (any vat-enabled ebm for [businessId]). Per-branch
/// `bhfId` still comes from each branch's ebm row.
Future<BranchTransferRraResult> reportBranchTransferToRra({
  required InventoryRequest request,
  required List<BranchTransferApprovedLine> lines,
  String? businessId,

  /// Test seams: default to the production singletons.
  @visibleForTesting Future<Ebm?> Function(String businessId)? resolveEbm,
  @visibleForTesting Future<Sar> Function(String branchId)? nextBranchSar,
}) async {
  if (lines.isEmpty) return BranchTransferRraResult.skipped;

  final mainBranchId = request.mainBranchId;
  final subBranchId = request.subBranchId;
  if (mainBranchId == null ||
      mainBranchId.isEmpty ||
      subBranchId == null ||
      subBranchId.isEmpty) {
    talker.warning(
      'BranchTransferRra: skip — missing mainBranchId/subBranchId on request',
    );
    return BranchTransferRraResult.skipped;
  }

  final resolvedBusinessId =
      businessId ?? ProxyService.box.getBusinessId();
  if (resolvedBusinessId == null || resolvedBusinessId.isEmpty) {
    talker.warning('BranchTransferRra: skip — no businessId');
    return BranchTransferRraResult.skipped;
  }

  final businessEbm =
      await (resolveEbm ?? resolveBusinessEbm)(resolvedBusinessId);
  if (businessEbm == null) {
    return BranchTransferRraResult.skipped;
  }

  final taxUrl = businessEbm.taxServerUrl?.trim();
  if (taxUrl == null || taxUrl.isEmpty) {
    return BranchTransferRraResult.skipped;
  }

  final sourceEbm = await ProxyService.strategy.ebm(branchId: mainBranchId);
  final destEbm = await ProxyService.strategy.ebm(branchId: subBranchId);
  final sourceBhfId = sourceEbm?.bhfId.trim();
  final destBhfId = destEbm?.bhfId.trim();
  if (sourceBhfId == null ||
      sourceBhfId.isEmpty ||
      destBhfId == null ||
      destBhfId.isEmpty) {
    talker.warning(
      'BranchTransferRra: skip — missing bhfId '
      '(source=$sourceBhfId dest=$destBhfId)',
    );
    return BranchTransferRraResult(
      attempted: false,
      succeeded: false,
      message: 'EBM branch codes missing for transfer',
    );
  }

  final tin = businessEbm.tinNumber.toString();
  final now = DateTime.now();

  // OUT reports the source branch's item identity; IN reports the destination
  // branch's (its own itemCd / units may differ from the source's).
  final outItems = <TransactionItem>[];
  final inItems = <TransactionItem>[];
  double outTotalSupply = 0;
  double outTotalAmount = 0;
  double inTotalSupply = 0;
  double inTotalAmount = 0;
  for (final line in lines) {
    if (line.approvedQty <= 0) continue;
    final qty = line.approvedQty.toDouble();

    final source = line.sourceVariant;
    outTotalSupply += (source.supplyPrice ?? source.retailPrice ?? 0) * qty;
    outTotalAmount += (source.retailPrice ?? source.supplyPrice ?? 0) * qty;
    outItems.add(_transferLineItem(line.itemName, source, qty, mainBranchId));

    final dest = line.destVariant;
    inTotalSupply += (dest.supplyPrice ?? dest.retailPrice ?? 0) * qty;
    inTotalAmount += (dest.retailPrice ?? dest.supplyPrice ?? 0) * qty;
    inItems.add(_transferLineItem(line.itemName, dest, qty, subBranchId));
  }

  if (outItems.isEmpty) return BranchTransferRraResult.skipped;

  try {
    Future<Sar> bumpSar(String branchId) =>
        nextBranchSar?.call(branchId) ??
        incrementAndPersistBranchSar(
          repository: Repository(),
          branchId: branchId,
          ditto: DittoService.instance.dittoInstance,
        );

    final sourceSar = await bumpSar(mainBranchId);
    final sourceSarNo = sourceSar.sarNo;

    final outResp = await retryTransientRraCall(
      () => ProxyService.tax.saveStockItems(
        items: outItems,
        updateMaster: false,
        tinNumber: tin,
        bhFId: sourceBhfId,
        sarTyCd: StockInOutType.stockMovementOut,
        isStockIn: false,
        customerName: 'Stock transfer to $destBhfId',
        custTin: tin,
        custBhfId: destBhfId,
        regTyCd: 'M',
        totalSupplyPrice: outTotalSupply,
        totalvat: 0,
        totalAmount: outTotalAmount,
        remark: 'Stock transfer to branch $destBhfId',
        ocrnDt: now,
        sarNo: sourceSarNo.toString(),
        invoiceNumber: sourceSarNo,
        URI: taxUrl,
      ),
    );

    if (outResp.resultCd != '000') {
      talker.error(
        'BranchTransferRra OUT failed: ${outResp.resultCd} ${outResp.resultMsg}',
      );
      return BranchTransferRraResult(
        attempted: true,
        succeeded: false,
        message: outResp.resultMsg.isEmpty
            ? 'Stock OUT to EBM failed'
            : outResp.resultMsg,
      );
    }

    final destSar = await bumpSar(subBranchId);
    final destSarNo = destSar.sarNo;

    final inResp = await retryTransientRraCall(
      () => ProxyService.tax.saveStockItems(
        items: inItems,
        updateMaster: false,
        tinNumber: tin,
        bhFId: destBhfId,
        sarTyCd: StockInOutType.stockMovementIn,
        isStockIn: true,
        customerName: 'Stock received from $sourceBhfId',
        custTin: tin,
        custBhfId: sourceBhfId,
        includeCustomerFields: true,
        regTyCd: 'M',
        totalSupplyPrice: inTotalSupply,
        totalvat: 0,
        totalAmount: inTotalAmount,
        remark: 'Stock received from branch $sourceBhfId',
        ocrnDt: now,
        sarNo: destSarNo.toString(),
        invoiceNumber: sourceSarNo, // orgSarNo links to A's OUT
        URI: taxUrl,
      ),
    );

    if (inResp.resultCd != '000') {
      talker.error(
        'BranchTransferRra IN failed: ${inResp.resultCd} ${inResp.resultMsg}',
      );
      return BranchTransferRraResult(
        attempted: true,
        succeeded: false,
        message: inResp.resultMsg.isEmpty
            ? 'Stock IN to EBM failed'
            : inResp.resultMsg,
      );
    }

    // Stock masters with absolute on-hand after local move. StockIO already
    // succeeded, so a master failure is a partial sync: leave that stock's
    // ebmSynced false and report the transfer as not fully reconciled.
    var mastersSucceeded = true;
    for (final line in lines) {
      final sourceStock = line.sourceVariant.stock;
      final destStock = line.destVariant.stock;
      final sourceQty =
          (sourceStock?.rsdQty ?? sourceStock?.currentStock)?.toDouble();
      final destQty =
          (destStock?.rsdQty ?? destStock?.currentStock)?.toDouble();

      if (sourceQty != null) {
        final masterResp = await retryTransientRraCall(
          () => ProxyService.tax.saveStockMaster(
            variant: line.sourceVariant,
            URI: taxUrl,
            stockMasterQty: sourceQty,
          ),
        );
        if (masterResp.resultCd == '000') {
          if (sourceStock != null) {
            await ProxyService.strategy.updateStock(
              stockId: sourceStock.id,
              ebmSynced: true,
            );
          }
        } else {
          mastersSucceeded = false;
          talker.error(
            'BranchTransferRra source master failed: '
            '${masterResp.resultCd} ${masterResp.resultMsg}',
          );
        }
      }
      if (destQty != null) {
        final masterResp = await retryTransientRraCall(
          () => ProxyService.tax.saveStockMaster(
            variant: line.destVariant,
            URI: taxUrl,
            stockMasterQty: destQty,
          ),
        );
        if (masterResp.resultCd == '000') {
          if (destStock != null) {
            await ProxyService.strategy.updateStock(
              stockId: destStock.id,
              ebmSynced: true,
            );
          }
        } else {
          mastersSucceeded = false;
          talker.error(
            'BranchTransferRra dest master failed: '
            '${masterResp.resultCd} ${masterResp.resultMsg}',
          );
        }
      }
    }

    if (!mastersSucceeded) {
      return const BranchTransferRraResult(
        attempted: true,
        succeeded: false,
        message: 'EBM stock master sync incomplete',
      );
    }
    return const BranchTransferRraResult(attempted: true, succeeded: true);
  } catch (e, s) {
    talker.error('BranchTransferRra failed', e, s);
    return BranchTransferRraResult(
      attempted: true,
      succeeded: false,
      message: e.toString(),
    );
  }
}

/// One `saveStockItems` line for [variant] at [branchId], moving [qty] units.
TransactionItem _transferLineItem(
  String name,
  Variant variant,
  double qty,
  String branchId,
) {
  final unitSupply =
      (variant.supplyPrice ?? variant.retailPrice ?? 0).toDouble();
  final unitRetail =
      (variant.retailPrice ?? variant.supplyPrice ?? 0).toDouble();
  return TransactionItem(
    name: name,
    qty: qty,
    price: unitRetail,
    discount: 0,
    prc: unitRetail,
    supplyPrice: unitSupply,
    ttCatCd: variant.taxTyCd ?? 'B',
    taxTyCd: variant.taxTyCd ?? 'B',
    itemCd: variant.itemCd,
    itemClsCd: variant.itemClsCd,
    itemNm: variant.name,
    itemTyCd: variant.itemTyCd,
    qtyUnitCd: variant.qtyUnitCd ?? 'U',
    pkgUnitCd: variant.pkgUnitCd ?? 'NT',
    variantId: variant.id,
    branchId: branchId,
  );
}

/// Any vat-enabled EBM row for the business (shared tin / tax URL).
Future<Ebm?> resolveBusinessEbm(String businessId) async {
  try {
    final repo = Repository();
    final fetched = await repo.get<Ebm>(
      query: Query(
        where: [Where('businessId').isExactly(businessId)],
      ),
      policy: OfflineFirstGetPolicy.localOnly,
    );
    for (final e in fetched) {
      final url = e.taxServerUrl?.trim();
      if ((e.vatEnabled ?? false) && url != null && url.isNotEmpty) {
        return e;
      }
    }

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM ebms WHERE businessId = :businessId',
      arguments: {'businessId': businessId},
    );
    for (final item in result.items) {
      final map = Map<String, dynamic>.from(item.value);
      final vat = map['vatEnabled'] == true || map['vat_enabled'] == true;
      final url = (map['taxServerUrl'] ?? map['tax_server_url'])?.toString();
      if (vat && url != null && url.trim().isNotEmpty) {
        return Ebm(
          id: map['_id']?.toString() ?? map['id']?.toString(),
          bhfId: (map['bhfId'] ?? map['bhf_id'] ?? '').toString(),
          tinNumber: (map['tinNumber'] ?? map['tin_number'] as num?)?.toInt() ??
              0,
          dvcSrlNo: (map['dvcSrlNo'] ?? map['dvc_srl_no'] ?? '').toString(),
          taxServerUrl: url.trim(),
          businessId: businessId,
          branchId: (map['branchId'] ?? map['branch_id'] ?? '').toString(),
          vatEnabled: true,
          mrc: (map['mrc'] ?? '').toString(),
        );
      }
    }
  } catch (e, s) {
    talker.error('resolveBusinessEbm failed', e, s);
  }
  return null;
}
