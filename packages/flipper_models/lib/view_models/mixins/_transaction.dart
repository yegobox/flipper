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
      required double currentStock,
      required bool partOfComposite}) async {
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
      partOfComposite: partOfComposite,
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
    required bool partOfComposite,
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
      /// check if given variant is part of composite before adding it to the cart, we lock it for it to be editable on the cart
      double computedQty = isCustom ? 1.0 : quantity;
      if (partOfComposite) {
        /// get this composite by variantId to use the default qty set when the composite is sold
        Composite composite =
            ProxyService.realm.composite(variantId: variation.id!);
        computedQty = composite.qty ?? 0.0;
      }

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
        qty: computedQty,
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

      await ProxyService.realm.addTransactionItem(
          transaction: pendingTransaction,
          item: newItem,
          partOfComposite: partOfComposite);
    } else {
      ///set the current items to active for them to be added to the cart as well
      /// This means if there is pending custom item it will be added as well
      /// even if the intention was not there, but the assumption is that only
      /// custom amount is added when a user is on keypadview
      /// and clicked +, if for somereason a user pressed a number on keyboard and leave the keypad
      /// the custom amount with the number pressed will be available waiting
      /// so it is logical to add it here so user can decide to delete it later.
      for (TransactionItem item in items) {
        ProxyService.realm.realm!.write(() {
          item.active = true;
        });
      }
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
