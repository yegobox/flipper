import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

mixin TransactionMixin {
  final KeyPadService keypad = getIt<KeyPadService>();
  get quantity => keypad.quantity;

  Future<bool> saveTransaction(
      {required Variant variation,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock}) async {
    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName;

    /// if variation  given it exist in the transactionItems of currentPending transaction then we update the transaction with new count

    TransactionItem? existTransactionItem = await ProxyService.isar
        .getTransactionItemByVariantId(
            variantId: variation.id, transactionId: pendingTransaction.id);

    await addTransactionItems(
      variationId: variation.id,
      pendingTransaction: pendingTransaction,
      name: name,
      variation: variation,
      currentStock: currentStock,
      amountTotal: amountTotal,
      isCustom: customItem,
      item: existTransactionItem,
    );

    return true;
  }

  /// adding item to current transaction,
  /// it is important to note that custom item is not incremented
  /// when added and there is existing custom item in the list
  /// because we don't know if this is not something different you are selling at this point.
  Future<void> addTransactionItems({
    required String variationId,
    required ITransaction pendingTransaction,
    required String name,
    required Variant variation,
    required double currentStock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
  }) async {
    if (item != null && !isCustom) {
      // Update existing transaction item
      item.qty += quantity.toDouble();
      item.price = amountTotal / quantity;

      /// this is to automatically show item in shoping cart
      item.active = true;

      List<TransactionItem> items = await ProxyService.isar.transactionItems(
          transactionId: pendingTransaction.id,
          doneWithTransaction: false,
          active: true);
      pendingTransaction.subTotal =
          items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.isar.update(data: pendingTransaction);
      await ProxyService.isar.update(data: item);
      return;
    }
    // Create a new transaction item
    TransactionItem newItem = TransactionItem(
        id: randomString(),
        branchId: variation.branchId,
        lastTouched: DateTime.now(),
        action: AppActions.created,
        qty: isCustom ? 1.0 : quantity,
        price: amountTotal / quantity,
        variantId: variationId,
        name: name,
        discount: 0.0,
        transactionId: pendingTransaction.id,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isTaxExempted: variation.isTaxExempted,
        dcRt: 0.0,
        dcAmt: 0.0,
        taxblAmt: pendingTransaction.subTotal,
        taxAmt: double.parse((amountTotal * 18 / 118).toStringAsFixed(2)),
        totAmt: variation.retailPrice,
        itemSeq: variation.itemSeq,
        isrccCd: variation.isrccCd,
        isrccNm: variation.isrccNm,
        isrcRt: variation.isrcRt,
        isrcAmt: variation.isrcAmt,
        taxTyCd: variation.taxTyCd,
        bcd: variation.bcd,
        itemClsCd: variation.itemClsCd,
        itemTyCd: variation.itemTyCd,
        itemStdNm: variation.itemStdNm,
        orgnNatCd: variation.orgnNatCd,
        pkg: variation.pkg,
        itemCd: variation.itemCd,
        pkgUnitCd: variation.pkgUnitCd,
        qtyUnitCd: variation.qtyUnitCd,
        itemNm: variation.itemNm,
        prc: variation.retailPrice,
        splyAmt: variation.splyAmt,
        tin: variation.tin,
        bhfId: variation.bhfId,
        dftPrc: variation.dftPrc,
        addInfo: variation.addInfo,
        isrcAplcbYn: variation.isrcAplcbYn,
        useYn: variation.useYn,
        regrId: variation.regrId,
        regrNm: variation.regrNm,
        modrId: variation.modrId,
        modrNm: variation.modrNm,
        remainingStock: currentStock - quantity,
        doneWithTransaction: false,
        active: true);

    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: pendingTransaction.id,
        doneWithTransaction: false,
        active: true);

    pendingTransaction.subTotal =
        items.fold(0, (a, b) => a + (b.price * b.qty));

    pendingTransaction.updatedAt = DateTime.now().toIso8601String();

    await ProxyService.isar.update(data: pendingTransaction);

    newItem.action = AppActions.created;
    await ProxyService.isar
        .addTransactionItem(transaction: pendingTransaction, item: newItem);
  }
}
