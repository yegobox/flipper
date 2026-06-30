import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/models/transactionItemUtil.dart';
import 'package:supabase_models/brick/repository.dart';

class StockIOUtil {
  static Future<void> saveStockIO({
    required Repository repository,
    required Variant variant,
    required num approvedQty,
    String remark = "Stock adjustment",
  }) async {
    final sar = await ProxyService.strategy
        .getSar(branchId: ProxyService.box.getBranchId()!);

    sar!.sarNo = sar.sarNo + 1;
    await repository.upsert<Sar>(sar);

    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);

    if (ebm == null) {
      throw StateError('EBM not found for branch');
    }

    final qty = approvedQty.toDouble();
    final supplyUnit = variant.supplyPrice ?? 0;
    final retailUnit = variant.retailPrice ?? 0;

    final taxUrl = ebm.taxServerUrl;
    if (taxUrl == null || taxUrl.isEmpty) {
      throw StateError('EBM tax server URL is not configured');
    }

    await ProxyService.tax.saveStockItems(
      updateMaster: false,
      items: [
        TransactionItemUtil.fromVariant(variant,
            itemSeq: 1, approvedQty: qty)
      ],
      tinNumber: ebm.tinNumber.toString(),
      bhFId: ebm.bhfId,
      totalSupplyPrice: supplyUnit * qty,
      totalvat: 0,
      totalAmount: retailUnit * qty,
      sarTyCd: "06",
      sarNo: sar.sarNo.toString(),
      invoiceNumber: sar.sarNo,
      remark: remark,
      ocrnDt: DateTime.now().toUtc(),
      URI: taxUrl,
    );
  }

  static Future<void> saveStockMaster({
    required Variant variant,
    required num stockMasterQty,
  }) async {
    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);

    final taxUrl = ebm?.taxServerUrl;
    if (taxUrl == null || taxUrl.isEmpty) {
      throw StateError('EBM tax server URL is not configured');
    }

    await ProxyService.tax.saveStockMaster(
      variant: variant,
      URI: taxUrl,
      stockMasterQty: stockMasterQty.toDouble(),
    );
  }
}