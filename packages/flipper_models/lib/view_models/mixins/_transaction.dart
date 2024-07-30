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
      {double? compositePrice,
      required Variant variation,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock,
      required bool partOfComposite}) async {
    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName!;

    TransactionItem? existTransactionItem = ProxyService.realm
        .getTransactionItemByVariantId(
            variantId: variation.id!, transactionId: pendingTransaction.id);

    await addTransactionItems(
      variationId: variation.id!,
      pendingTransaction: pendingTransaction,
      name: name,
      variation: variation,
      currentStock: currentStock,
      amountTotal: amountTotal,
      isCustom: customItem,
      partOfComposite: partOfComposite,
      compositePrice: compositePrice,
      item: existTransactionItem,
    );

    return true;
  }

  Future<void> addTransactionItems({
    required int variationId,
    required ITransaction pendingTransaction,
    required String name,
    required Variant variation,
    required double currentStock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
    double? compositePrice,
    required bool partOfComposite,
  }) async {
    if (item != null && !isCustom) {
      // Update existing non-custom item
      ProxyService.realm.realm!.write(() {
        item.qty = (item.qty) + quantity;
        item.price = amountTotal / quantity;
        item.taxblAmt = variation.retailPrice * quantity;
        item.totAmt = variation.retailPrice * quantity;
        item.splyAmt = variation.supplyPrice;
        item.active = true;

        updatePendingTransactionTotals(pendingTransaction);
      });
    } else {
      // Add new item (for both custom and new non-custom items)
      double computedQty = isCustom ? 1.0 : quantity;
      if (partOfComposite) {
        Composite composite =
            ProxyService.realm.composite(variantId: variation.id!);
        computedQty = composite.qty ?? 0.0;
      }

      TransactionItem newItem = TransactionItem(
        ObjectId(),
        compositePrice: partOfComposite == true ? compositePrice! : 0.0,
        id: randomNumber(),
        action: AppActions.created,
        price: variation.retailPrice,
        variantId: variation.id!,
        name: name,
        branchId: variation.branchId,
        discount: 0.0,
        prc: variation.retailPrice,
        doneWithTransaction: false,
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
        totAmt: variation.retailPrice * quantity,
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
        splyAmt: variation.supplyPrice,
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
        partOfComposite: partOfComposite,
      );

      ProxyService.realm.addTransactionItem(
          transaction: pendingTransaction,
          item: newItem,
          partOfComposite: partOfComposite);
    }

    // Handle activation of inactive items
    List<TransactionItem> inactiveItems = ProxyService.realm.transactionItems(
        transactionId: pendingTransaction.id!,
        doneWithTransaction: false,
        active: false);

    if (inactiveItems.isNotEmpty) {
      ProxyService.realm.realm!.write(() {
        for (TransactionItem inactiveItem in inactiveItems) {
          inactiveItem.active = true;
        }
        updatePendingTransactionTotals(pendingTransaction);
      });
    }
  }

  void updatePendingTransactionTotals(ITransaction pendingTransaction) {
    List<TransactionItem> items = ProxyService.realm.transactionItems(
      transactionId: pendingTransaction.id!,
      doneWithTransaction: false,
      active: true,
    );
    pendingTransaction.subTotal =
        items.fold(0, (a, b) => a + (b.price * b.qty));
    pendingTransaction.updatedAt = DateTime.now().toIso8601String();
    pendingTransaction.lastTouched = DateTime.now();
  }
}
