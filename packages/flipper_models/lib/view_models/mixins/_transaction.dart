import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

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
        : variation.productName!;

    /// if variation  given it exist in the transactionItems of currentPending transaction then we update the transaction with new count

    TransactionItem? existTransactionItem = ProxyService.realm
        .getTransactionItemByVariantId(
            variantId: variation.id!, transactionId: pendingTransaction.id);

    addTransactionItems(
      variationId: variation.id!,
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
    required int variationId,
    required ITransaction pendingTransaction,
    required String name,
    required Variant variation,
    required double currentStock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
  }) async {
    if (item != null && !isCustom) {
      List<TransactionItem> items = ProxyService.realm.transactionItems(
        transactionId: pendingTransaction.id!,
        doneWithTransaction: false,
        active: true,
      );

      ProxyService.realm.realm!.write(() {
        // Update existing transaction item
        item.qty = (item.qty) + quantity;
        item.price = amountTotal / quantity;

        /// this is to automatically show item in shopping cart
        item.active = true;
        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty));
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      });
      return;
    }
    List<TransactionItem> items = ProxyService.realm.transactionItems(
        transactionId: pendingTransaction.id!,
        doneWithTransaction: false,
        active: false);

    if (items.isEmpty) {
      TransactionItem newItem = TransactionItem(
        ObjectId(),
        id: randomNumber(),
        action: AppActions.created,
        price: variation.retailPrice,
        variantId: variation.id!,
        name: name,
        branchId: variation.branchId,
        discount: 0.0,
        prc: variation.retailPrice,
        doneWithTransaction: false,

        /// if we want to see the item to the preview, it should be made active as soon as we
        /// set active to true
        active: true,
        transactionId: pendingTransaction.id!,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isTaxExempted: variation.isTaxExempted,
        remainingStock: currentStock - quantity,
        lastTouched: DateTime.now(),
        qty: isCustom ? 1.0 : quantity,
        taxblAmt: variation.retailPrice * quantity,
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
      );
      await ProxyService.realm
          .addTransactionItem(transaction: pendingTransaction, item: newItem);
    }

    ProxyService.realm.realm!.write(() {
      // Create a new transaction item
      pendingTransaction.subTotal =
          items.fold(0, (a, b) => a + (b.price * b.qty));

      pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      pendingTransaction.lastTouched = DateTime.now();
    });
  }
}
