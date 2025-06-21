import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

class EbmSyncService {
  final Repository repository;
  EbmSyncService(this.repository);

  Future<bool> syncVariantWithEbm({
    required Variant instance,
    required String serverUrl,
  }) async {
    talker.info("Hererooo on save \\${instance.id}");
    await repository.upsert(instance);
    instance.ebmSynced = false;

    final response =
        await ProxyService.tax.saveItem(variation: instance, URI: serverUrl);
    if (response.resultCd == "000") {
      Business? business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final pendingTransaction = await ProxyService.strategy.manageTransaction(
        transactionType: TransactionType.adjustment,
        isExpense: true,
        branchId: ProxyService.box.getBranchId()!,
      );
      await ProxyService.strategy.assignTransaction(
        variant: instance,
        doneWithTransaction: true,
        invoiceNumber: 0,
        pendingTransaction: pendingTransaction!,
        business: business!,
        randomNumber: DateTime.now().millisecondsSinceEpoch % 1000000,
        sarTyCd: "06",
      );
      double totalvat = 0;
      double taxB = 0;
      List<TransactionItem> items = await repository.get<TransactionItem>(
          query: Query(where: [
        Where('transactionId').isExactly(pendingTransaction.id)
      ]));
      Configurations taxConfigTaxB = (await repository.get<Configurations>(
              query: Query(where: [Where('taxType').isExactly("B")])))
          .first;
      for (var item in items) {
        if (item.taxTyCd == "B") {
          taxB += (item.price * item.qty);
        }
      }
      final totalTaxB = Repository.calculateTotalTax(taxB, taxConfigTaxB);
      totalvat = totalTaxB;
      await ProxyService.tax.saveStockItems(
        transaction: pendingTransaction,
        tinNumber: ProxyService.box.tin().toString(),
        bhFId: (await ProxyService.box.bhfId())!,
        customerName: null,
        custTin: null,
        regTyCd: "A",
        sarTyCd: pendingTransaction.sarTyCd!,
        custBhfId: pendingTransaction.customerBhfId!,
        totalSupplyPrice: pendingTransaction.subTotal!,
        totalvat: totalvat,
        totalAmount: pendingTransaction.subTotal!,
        remark: pendingTransaction.remark ?? "",
        ocrnDt: pendingTransaction.updatedAt ?? DateTime.now().toUtc(),
        URI: serverUrl,
      );
      instance.ebmSynced = true;
      await repository.upsert(instance);
      return true;
    }
    return false;
  }

  Future<bool> syncTransactionWithEbm(
      {required ITransaction instance, required String serverUrl}) async {
    talker.info("Syncing transaction with ${instance.items?.length}");
    return true;
  }
}
