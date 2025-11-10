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

    await ProxyService.tax.saveStockItems(
      updateMaster: false,
      items: [
        TransactionItemUtil.fromVariant(variant,
            itemSeq: 1, approvedQty: approvedQty.toDouble())
      ],
      tinNumber: ebm!.tinNumber.toString(),
      bhFId: ebm.bhfId,
      totalSupplyPrice: variant.supplyPrice ?? 0,
      totalvat: 0,
      totalAmount: variant.retailPrice ?? 0,
      sarTyCd: "06",
      sarNo: sar.sarNo.toString(),
      invoiceNumber: sar.sarNo,
      remark: remark,
      ocrnDt: DateTime.now().toUtc(),
      URI: ebm.taxServerUrl,
    );
  }

  static Future<void> saveStockMaster({
    required Variant variant,
    required num stockMasterQty,
  }) async {
    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    
    await ProxyService.tax.saveStockMaster(
      variant: variant,
      URI: ebm!.taxServerUrl,
      stockMasterQty: stockMasterQty.toDouble(),
    );
  }
}