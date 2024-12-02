import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'transaction_items'),
)
class TransactionItem extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final int id;

  final String name;
  final int? quantityRequested;
  final int? quantityApproved;
  final int? quantityShipped;
  final int? transactionId;
  final int? variantId;
  // quantity
  final double? qty;
  final double price;
  final double discount;
  final String? type;
  final double? remainingStock;
  final String? createdAt;
  final String? updatedAt;
  final bool? isTaxExempted;
  final bool? isRefunded;

  /// property to help us adding new item to transaction
  final bool? doneWithTransaction;
  final bool? active;

  // RRA fields
  // discount rate
  final double? dcRt;
  // discount amount
  final double? dcAmt;

  final double? taxblAmt;
  final double? taxAmt;

  final double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  final int? itemSeq;
  // insurance code
  final String? isrccCd;
  // insurance name
  final String? isrccNm;
  // premium rate
  final int? isrcRt;
  // insurance amount
  final int? isrcAmt;
  // taxation type code.
  final String? taxTyCd;
  // bar code
  final String? bcd;
  // Item code
  final String? itemClsCd;
  // Item type code
  final String? itemTyCd;
  // Item standard name
  final String? itemStdNm;
  // Item origin
  final String? orgnNatCd;
  // packaging unit code
  final String? pkg;
  // item code
  final String? itemCd;

  final String? pkgUnitCd;

  final String? qtyUnitCd;
  // same as name but for rra happiness
  final String itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  final double prc;
  // supply amount
  final double splyAmt;
  final int? tin;
  final String? bhfId;
  final double? dftPrc;
  final String? addInfo;
  final String? isrcAplcbYn;
  final String? useYn;
  final String? regrId;
  final String? regrNm;
  final String? modrId;
  final String? modrNm;

  final DateTime? lastTouched;
  final DateTime? deletedAt;

  final int? branchId;
  final bool? ebmSynced;
  final bool? partOfComposite;
  final double? compositePrice;
  TransactionItem({
    required this.splyAmt,
    required this.id,
    this.taxTyCd,
    this.bcd,
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm,
    this.orgnNatCd,
    this.pkg,
    this.itemCd,
    this.pkgUnitCd,
    this.qtyUnitCd,
    required this.itemNm,
    this.tin,
    this.bhfId,
    this.dftPrc,
    this.addInfo,
    this.isrcAplcbYn,
    this.useYn,
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
    this.lastTouched,
    this.deletedAt,
    this.branchId,
    this.ebmSynced,
    this.partOfComposite,
    this.compositePrice,
    required this.name,
    this.quantityRequested,
    this.quantityApproved,
    this.quantityShipped,
    this.transactionId,
    this.variantId,
    this.qty,
    required this.price,
    required this.discount,
    this.type,
    this.remainingStock,
    this.createdAt,
    this.updatedAt,
    this.isTaxExempted,
    this.isRefunded,
    this.doneWithTransaction,
    this.active,
    this.dcRt,
    this.dcAmt,
    this.taxblAmt,
    this.taxAmt,
    this.totAmt,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm,
    this.isrcRt,
    this.isrcAmt,
    required this.prc,
  });
}
