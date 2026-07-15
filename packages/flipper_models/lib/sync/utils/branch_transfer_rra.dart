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

  final stockIoItems = <TransactionItem>[];
  double totalSupply = 0;
  double totalAmount = 0;
  for (final line in lines) {
    if (line.approvedQty <= 0) continue;
    final v = line.sourceVariant;
    final unitSupply = (v.supplyPrice ?? v.retailPrice ?? 0).toDouble();
    final unitRetail = (v.retailPrice ?? v.supplyPrice ?? 0).toDouble();
    final qty = line.approvedQty.toDouble();
    final lineSupply = unitSupply * qty;
    final lineRetail = unitRetail * qty;
    totalSupply += lineSupply;
    totalAmount += lineRetail;
    stockIoItems.add(
      TransactionItem(
        name: line.itemName,
        qty: qty,
        price: unitRetail,
        discount: 0,
        prc: unitRetail,
        supplyPrice: unitSupply,
        ttCatCd: v.taxTyCd ?? 'B',
        taxTyCd: v.taxTyCd ?? 'B',
        itemCd: v.itemCd,
        itemClsCd: v.itemClsCd,
        itemNm: v.name,
        itemTyCd: v.itemTyCd,
        qtyUnitCd: v.qtyUnitCd ?? 'U',
        pkgUnitCd: v.pkgUnitCd ?? 'NT',
        variantId: v.id,
        branchId: mainBranchId,
      ),
    );
  }

  if (stockIoItems.isEmpty) return BranchTransferRraResult.skipped;

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
        items: stockIoItems,
        updateMaster: false,
        tinNumber: tin,
        bhFId: sourceBhfId,
        sarTyCd: StockInOutType.stockMovementOut,
        isStockIn: false,
        customerName: 'Stock transfer to $destBhfId',
        custTin: tin,
        custBhfId: destBhfId,
        regTyCd: 'M',
        totalSupplyPrice: totalSupply,
        totalvat: 0,
        totalAmount: totalAmount,
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
        items: stockIoItems,
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
        totalSupplyPrice: totalSupply,
        totalvat: 0,
        totalAmount: totalAmount,
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

    // Stock masters with absolute on-hand after local move.
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
        if (masterResp.resultCd == '000' && sourceStock != null) {
          await ProxyService.strategy.updateStock(
            stockId: sourceStock.id,
            ebmSynced: true,
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
        if (masterResp.resultCd == '000' && destStock != null) {
          await ProxyService.strategy.updateStock(
            stockId: destStock.id,
            ebmSynced: true,
          );
        }
      }
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
