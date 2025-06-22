// ignore_for_file: prefer_const_constructors

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

class EbmSyncService {
  final Repository repository;
  EbmSyncService(this.repository);

  Future<bool> syncVariantWithEbm({
    Variant? variant,
    required String serverUrl,
    ITransaction? transaction,
    String? sarTyCd,
  }) async {
    /// variant is used to save item and stock master and stock In
    /// transaction is used to save stock io
    /// sarTyCd is used to determine the type of transaction
    if (variant != null) {
      await ProxyService.tax.saveItem(variation: variant, URI: serverUrl);

      /// skip saving a service in stock master
      if (variant.itemCd != null &&
          variant.itemCd!.isNotEmpty &&
          variant.itemCd! == "3") {
        throw Exception("Service item cannot be saved in stock master");
      }
      await ProxyService.tax.saveStockMaster(variant: variant, URI: serverUrl);
    }

    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    ITransaction? pendingTransaction;
    if (transaction == null && variant != null) {
      pendingTransaction = await ProxyService.strategy.manageTransaction(
        transactionType: TransactionType.adjustment,
        isExpense: true,
        branchId: ProxyService.box.getBranchId()!,
      );
      await ProxyService.strategy.assignTransaction(
        variant: variant,
        doneWithTransaction: true,
        invoiceNumber: 0,
        updatableQty: variant.stock?.currentStock,
        pendingTransaction: pendingTransaction!,
        business: business!,
        randomNumber: DateTime.now().millisecondsSinceEpoch % 1000000,
        sarTyCd: "06",
      );
    } else {
      pendingTransaction = transaction;
    }
    double totalvat = 0;
    double taxB = 0;
    List<TransactionItem> items = await repository.get<TransactionItem>(
        query: Query(
            where: [Where('transactionId').isExactly(pendingTransaction!.id)]));
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

    try {
      /// stock io will be used to either save stock out or stock in, this will be determined by sarTyCd
      /// if sarTyCd is 11 then it is a sale
      /// if sarTyCd is 06 then it is a stock adjustment
      final responseSaveStockInput = await ProxyService.tax.saveStockItems(
        transaction: pendingTransaction,
        tinNumber: ProxyService.box.tin().toString(),
        bhFId: (await ProxyService.box.bhfId()) ?? "00",
        customerName: null,
        custTin: null,
        regTyCd: "A",
        sarTyCd: sarTyCd ?? pendingTransaction.sarTyCd!,
        custBhfId: pendingTransaction.customerBhfId,
        totalSupplyPrice: pendingTransaction.subTotal!,
        totalvat: totalvat,
        totalAmount: pendingTransaction.subTotal!,
        remark: pendingTransaction.remark ?? "",
        ocrnDt: pendingTransaction.updatedAt ?? DateTime.now().toUtc(),
        URI: serverUrl,
      );
      if (responseSaveStockInput.resultCd == "000") {
        if (variant != null) {
          variant.ebmSynced = true;
          await repository.upsert(variant);
          ProxyService.notification
              .sendLocalNotification(body: "Synced ${variant.itemCd}");
          return true;
        }
      }
    } catch (e, s) {
      talker.error(e, s);
    }
    return false;
  }

  Future<bool> syncTransactionWithEbm(
      {required TransactionItem instance, required String serverUrl}) async {
    final transaction = (await repository.get<ITransaction>(
            query: Query(where: [
      Where('id').isExactly(instance.transactionId),
      Where('transactionType').isExactly(TransactionType.adjustment),
    ])))
        .firstOrNull;
    if (transaction != null) {
      if (transaction.customerName == null ||
          transaction.customerTin == null ||
          transaction.sarNo == null ||
          transaction.receiptType == "TS" ||
          transaction.receiptType == "PS" ||
          transaction.ebmSynced!) {
        return false;
      }
      talker
          .info("Syncing transaction with ${transaction.items?.length} items");

      // Variant variant = Variant.copyFromTransactionItem(item);
      // get transaction items
      await syncVariantWithEbm(
          serverUrl: serverUrl, transaction: transaction, sarTyCd: "11");

      // If all items synced successfully, mark transaction as synced
      instance.ebmSynced = true;
      await repository.upsert(instance);
      talker
          .info("Successfully synced all items for transaction ${instance.id}");

      return true;
    }
    return true;
  }

  Future<bool> syncCustomerWithEbm(
      {required Customer instance, required String serverUrl}) async {
    try {
      final response = await ProxyService.tax.saveCustomer(
        customer: ICustomer.fromJson(instance.toFlipperJson()),
        URI: serverUrl,
      );
      if (response.resultCd == "000") {
        instance.ebmSynced = true;
        await repository.upsert<Customer>(instance);
        return true;
      }
    } catch (e, s) {
      talker.error(e, s);
    }
    return false;
  }
}
