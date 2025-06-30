// ignore_for_file: prefer_const_constructors

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/retryable.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// Service responsible for synchronizing data with the EBM (Electronic Billing Machine) system.
/// Handles synchronization of variants, transactions, and customers with the tax authority's system.

/// Service that manages synchronization between the local database and the EBM system.
/// Provides methods to sync product variants, transactions, and customer data with the tax authority.
class EbmSyncService {
  /// Repository instance for database operations
  final Repository repository;

  /// Creates an instance of [EbmSyncService] with the provided [repository].
  EbmSyncService(this.repository);

  /// Handles the case when the system is in proforma or training mode.
  /// Marks the variant and transaction as synced without sending to EBM.
  /// Returns true if in proforma/training mode, false otherwise.
  Future<bool> _handleProformaOrTrainingMode(
      Variant? variant, ITransaction? transaction) async {
    if (ProxyService.box.isProformaMode() ||
        ProxyService.box.isTrainingMode()) {
      return true;
    }
    return false;
  }

  /// Synchronizes a product variant with the EBM system, including its stock information.
  ///
  /// This method handles:
  /// 1. Saving item and stock master data for the variant
  /// 2. Creating or updating transactions if needed
  /// 3. Calculating taxes
  /// 4. Syncing stock movements
  ///
  /// Parameters:
  /// - [variant]: The product variant to sync (optional if transaction is provided)
  /// - [serverUrl]: The base URL of the EBM server
  /// - [transaction]: Existing transaction (optional, will create one if not provided)
  /// - [sarTyCd]: Transaction type code (e.g., '06' for stock adjustment, '11' for sale)
  ///
  /// Returns: `true` if synchronization was successful, `false` otherwise
  /// either of these functions can't throw exceptions because they might be called in the loop and will break the loop
  /// which can cause the half saving data in our db.
  Future<bool> stockIo({
    Variant? variant,
    required String serverUrl,
    ITransaction? transaction,
    String? sarTyCd,
  }) async {
    if (await _handleProformaOrTrainingMode(variant, transaction)) {
      return true;
    }

    /// variant is used to save item and stock master and stock In
    /// transaction is used to save stock io
    /// sarTyCd is used to determine the type of transaction

    if (variant != null) {
      /// skip saving a service in stock master
      if (variant.itemCd == null ||
          variant.itemCd?.isEmpty == true ||
          variant.pchsSttsCd == "01" ||
          variant.pchsSttsCd ==
              "1" || // unsent, item that has been mapped to another item after import of purchase.
          variant.imptItemSttsCd == "4" ||
          variant.imptItemSttsCd == "2" ||
          variant.itemCd == "3") {
        /// save it anyway so we do not miss things
        talker.info("Syncing service called but skipped ${variant.itemCd}");
        variant.ebmSynced = true;
        return true;
      }
      final saveItemResponse =
          await ProxyService.tax.saveItem(variation: variant, URI: serverUrl);
      if (saveItemResponse.resultCd != "000") {
        await _handleFailedSync(
          entityId: variant.id,
          entityTable: "variants",
          failureReason: saveItemResponse.resultMsg,
        );
      } else if (saveItemResponse.resultCd == "000") {
        // delete retryable if exist with same entity id and entity table
        // get retryable
        final retryable = await repository.get<Retryable>(
            query: Query(where: [
          Where('entityId').isExactly(variant.id),
          Where('entityTable').isExactly("variants")
        ]));
        if (retryable.isNotEmpty) {
          await repository.delete(retryable.first);
        }
      }

      final saveStockMasterResponse = await ProxyService.tax
          .saveStockMaster(variant: variant, URI: serverUrl);

      if (saveStockMasterResponse.resultCd != "000") {
        await _handleFailedSync(
          entityId: variant.id,
          entityTable: "variants",
          failureReason: saveStockMasterResponse.resultMsg,
        );
      } else if (saveStockMasterResponse.resultCd == "000") {
        // delete retryable if exist with same entity id and entity table
        // get retryable
        final retryable = await repository.get<Retryable>(
            query: Query(where: [
          Where('entityId').isExactly(variant.id),
          Where('entityTable').isExactly("variants")
        ]));
        if (retryable.isNotEmpty) {
          await repository.delete(retryable.first);
        }
      }
    }

    // Sync stock items with the EBM system
    return await _syncStockItems(
      transaction: transaction,
      serverUrl: serverUrl,
      variant: variant,
      sarTyCd: sarTyCd,
    );
  }

  /// Handles failed synchronization by creating and upserting a Retryable entity.
  ///
  /// Parameters:
  /// - [entityId]: The ID of the entity that failed to sync
  /// - [entityTable]: The name of the table for the entity
  /// - [failureReason]: The reason for the sync failure
  Future<void> _handleFailedSync({
    required String entityId,
    required String entityTable,
    required String failureReason,
  }) async {
    // check if this has been retried before
    final retryable = await repository.get<Retryable>(
        query: Query(where: [
      Where('entityId').isExactly(entityId),
      Where('entityTable').isExactly(entityTable)
    ]));
    if (retryable.isNotEmpty) {
      // increment retry count
      retryable.first.retryCount++;
      await repository.upsert(retryable.first);
    } else {
      await repository.upsert(Retryable(
        entityId: entityId,
        entityTable: entityTable,
        lastFailureReason: failureReason,
        retryCount: 0,
        createdAt: DateTime.now(),
      ));
    }
  }

  /// Synchronizes stock items for a transaction with the EBM system.
  ///
  /// This method handles the process of syncing stock items for a given transaction
  /// with the tax authority's system. It calculates taxes, saves stock items, and
  /// updates the transaction and variant status upon successful sync.
  ///
  /// Parameters:
  /// - [pendingTransaction]: The transaction containing the items to sync
  /// - [variant]: The variant being synced (optional)
  /// - [sarTyCd]: The stock adjustment reason code (defaults to transaction's sarTyCd)
  /// - [serverUrl]: The server URL for the API endpoint
  ///
  /// Returns:
  /// - `true` if the sync was successful, `false` otherwise
  Future<bool> _syncStockItems({
    required ITransaction? transaction,
    required String serverUrl,
    Variant? variant,
    String? sarTyCd,
  }) async {
    // Get business and transaction
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    ITransaction? pendingTransaction = transaction;
    // Create new transaction if needed
    if (transaction == null && variant != null) {
      pendingTransaction = await ProxyService.strategy.manageTransaction(
        transactionType: TransactionType.adjustment,
        isExpense: true,
        status: PENDING,
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

        ///06 stock adjustment is needed for stock io to take effect
        sarTyCd: sarTyCd ?? "06",
      );
    }

    if (pendingTransaction == null) {
      talker.error('No transaction available for stock sync');
      return false;
    }
    double totalvat = 0;
    double taxB = 0;

    // Get transaction items
    List<TransactionItem> items = await repository.get<TransactionItem>(
        query: Query(
            where: [Where('transactionId').isExactly(pendingTransaction.id)]));

    // Get tax configuration for tax type B
    Configurations taxConfigTaxB = (await repository.get<Configurations>(
            query: Query(where: [Where('taxType').isExactly("B")])))
        .first;

    // Calculate total tax B
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
        // delete retryable if exist with same entity id and entity table
        final retryable = await repository.get<Retryable>(
            query: Query(where: [
          Where('entityId').isExactly(pendingTransaction.id),
          Where('entityTable').isExactly("transactions")
        ]));
        if (retryable.isNotEmpty) {
          await repository.delete(retryable.first);
        }
        if (variant != null) {
          ProxyService.notification
              .sendLocalNotification(body: "Synced ${variant.itemCd}");
          return true;
        }
      } else if (responseSaveStockInput.resultCd != "000") {
        await _handleFailedSync(
          entityId: pendingTransaction.id,
          entityTable: "transactions",
          failureReason: responseSaveStockInput.resultMsg,
        );
      }
    } catch (e, s) {
      talker.error(e, s);
    }

    return false;
  }

  /// Synchronizes a transaction with the EBM system.
  ///
  /// This method will sync all items in the transaction and mark the transaction
  /// as synced if successful. Only processes transactions that are complete and
  /// haven't been synced before.
  ///
  /// Parameters:
  /// - [instance]: The transaction to sync
  /// - [serverUrl]: The base URL of the EBM server
  ///
  /// Returns: `true` if synchronization was successful or not needed, `false` otherwise
  Future<bool> syncTransactionWithEbm(
      {required ITransaction instance, required String serverUrl}) async {
    if (instance.status == COMPLETE) {
      if (instance.customerName == null ||
          instance.customerTin == null ||
          instance.sarNo == null ||
          instance.receiptType == "TS" ||
          instance.receiptType == "PS" ||
          instance.receiptType == "TR" ||
          instance.ebmSynced!) {
        return false;
      }
      talker.info("Syncing transaction with ${instance.items?.length} items");

      // Variant variant = Variant.copyFromTransactionItem(item);
      // get transaction items
      await stockIo(serverUrl: serverUrl, transaction: instance, sarTyCd: "11");

      talker
          .info("Successfully synced all items for transaction ${instance.id}");

      return true;
    }
    return true;
  }

  /// Synchronizes customer information with the EBM system.
  ///
  /// This method sends customer data to the tax authority's system and updates
  /// the local record to mark it as synced.
  ///
  /// Parameters:
  /// - [instance]: The customer to sync
  /// - [serverUrl]: The base URL of the EBM server
  ///
  /// Returns: `true` if synchronization was successful, `false` otherwise
  Future<bool> syncCustomerWithEbm(
      {required Customer instance, required String serverUrl}) async {
    try {
      final response = await ProxyService.tax.saveCustomer(
        customer: ICustomer.fromJson(instance.toFlipperJson()),
        URI: serverUrl,
      );
      if (response.resultCd == "000") {
        return true;
      }
    } catch (e, s) {
      talker.error(e, s);
    }
    return false;
  }
}
