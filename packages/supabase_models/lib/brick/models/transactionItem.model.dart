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

  String name;
  int? quantityRequested;
  int? quantityApproved;
  int? quantityShipped;
  int? transactionId;
  int? variantId;
  // quantity
  double qty;
  double price;
  double discount;
  String? type;
  double? remainingStock;
  String? createdAt;
  String? updatedAt;
  bool? isRefunded;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double? dcRt;
  // discount amount
  double? dcAmt;

  double? taxblAmt;
  double? taxAmt;

  double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  int? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  int? isrcRt;
  // insurance amount
  int? isrcAmt;
  // taxation type code.
  String? taxTyCd;
  // bar code
  String? bcd;
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm;
  // Item origin
  String? orgnNatCd;
  // packaging unit code
  String? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  double prc;
  // supply amount
  double? splyAmt;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;
  DateTime? deletedAt;

  int? branchId;
  bool? ebmSynced;
  bool? partOfComposite;
  double? compositePrice;
  TransactionItem({
    this.splyAmt,
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
    required this.qty,
    required this.price,
    required this.discount,
    this.type,
    this.remainingStock,
    this.createdAt,
    this.updatedAt,
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
