import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';

mixin TransactionItemMixin implements TransactionItemInterface {
  Repository get repository;

  @override
  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    double? compositePrice,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal,
    required String name,
    TransactionItem? item,
  }) async {
    try {
      if (item == null && variation == null) {
        throw ArgumentError('Either `item` or `variation` must be provided.');
      }
      if (transaction == null) {
        throw ArgumentError('Transaction must be provided.');
      }

      TransactionItem transactionItem;

      if (item != null) {
        transactionItem = item;
        transactionItem.qty = quantity;

        if (variation?.retailPrice != null) {
          transactionItem.taxblAmt = variation!.retailPrice! * quantity;
          transactionItem.totAmt = variation.retailPrice! * quantity;
          transactionItem.remainingStock = currentStock - quantity;
        } else {
          throw ArgumentError('Retail price is required for transaction item calculations');
        }
      } else {
        final double price = variation!.retailPrice!;
        final double taxblAmt = price * quantity;
        final double taxAmt = double.parse((amountTotal * 18 / 118).toStringAsFixed(2));
        final double totAmt = price * quantity;
        final double dcAmt = (price * (variation.qty ?? 1.0)) * (variation.dcRt ?? 0.0);

        transactionItem = TransactionItem(
          itemNm: variation.itemNm ?? variation.name,
          lastTouched: lastTouched,
          name: name,
          qty: quantity,
          price: price,
          discount: discount,
          prc: price,
          splyAmt: variation.supplyPrice,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg.toString(),
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: variation.qtyUnitCd,
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
          branchId: ProxyService.box.getBranchId(),
          ebmSynced: false,
          partOfComposite: partOfComposite,
          compositePrice: compositePrice,
          quantityRequested: quantity.toInt(),
          quantityApproved: 0,
          quantityShipped: 0,
          transactionId: transaction.id,
          variantId: variation.id,
          remainingStock: currentStock - quantity,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isRefunded: false,
          doneWithTransaction: false,
          active: true,
          dcRt: variation.dcRt,
          dcAmt: dcAmt,
          taxblAmt: taxblAmt,
          taxAmt: taxAmt,
          totAmt: totAmt,
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
        );
      }

      await repository.upsert<TransactionItem>(transactionItem);

      final allItems = await repository.get<TransactionItem>(
        query: Query(
          where: [Where('transactionId').isExactly(transaction.id)],
        ),
      );

      allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      for (var i = 0; i < allItems.length; i++) {
        allItems[i].itemSeq = i + 1;
        await repository.upsert<TransactionItem>(allItems[i]);
      }
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }
}
