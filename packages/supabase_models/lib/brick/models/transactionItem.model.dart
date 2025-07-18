import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:uuid/uuid.dart';

// Date,Item Name,Price,Profit,Units Sold,Tax Rate,Traffic Count
// https://aistudio.google.com/app/prompts/1vt4fnINIbiy_qmgSIHQHxa5YoNGXEjM9
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'transaction_items'),
)
class TransactionItem extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String name;
  int? quantityRequested;
  int? quantityApproved;
  int? quantityShipped;
  @Sqlite(index: true)
  String? transactionId;
  @Sqlite(index: true)
  String? variantId;
  // quantity
  num qty;
  num price;
  num discount;
  num? remainingStock;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isRefunded;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RR`A fields
  // discount rate
  num? dcRt;
  // discount amount
  num? dcAmt;

  num? taxblAmt;
  num? taxAmt;

  num? totAmt;

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
  int? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  num prc;
  // supply amount
  num? splyAmt;
  int? tin;
  String? bhfId;
  num? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;

  // Additional fields from Variant
  String? purchaseId;
  Stock? stock;

  num? taxPercentage;
  String? color;
  String? sku;
  String? productId;
  String? unit;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? taxName;
  num? supplyPrice;
  num? retailPrice;
  String? spplrItemNm;
  int? totWt;
  int? netWt;
  String? spplrNm;
  String? agntNm;
  int? invcFcurAmt;
  String? invcFcurCd;
  num? invcFcurExcrt;
  String? exptNatCd;
  String? dclNo;
  String? taskCd;
  String? dclDe;
  String? hsCd;
  String? imptItemSttsCd;
  bool? isShared;
  bool? assigned;
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? branchId;
  bool? ebmSynced;
  bool? partOfComposite;
  num? compositePrice;

  // If the association will be created by the app, specify
  // a field that maps directly to the foreign key column
  // so that Brick can notify Supabase of the association.
  // @Sqlite(ignore: true)
  @Sqlite(index: true)
  @Supabase(foreignKey: 'inventory_requests')
  String? inventoryRequestId;

  @Sqlite(defaultValue: 'false')
  bool ignoreForReport;

  num? supplyPriceAtSale;

  /// Creates a new TransactionItem with required fields for proper functionality
  ///
  /// Required fields:
  /// - [name]: The name of the item
  /// - [qty]: The quantity of the item
  /// - [price]: The price of the item
  /// - [discount]: The discount applied to the item
  /// - [itemNm]: The display name of the item (same as name)
  /// - [prc]: The price of the item (same as price)
  /// - [itemCd]: The item code for identification
  /// - [itemTyCd]: The item type code for RRA compliance
  /// - [pkgUnitCd]: The packaging unit code
  /// - [qtyUnitCd]: The quantity unit code
  TransactionItem({
    this.purchaseId,
    this.stock,
    this.taxPercentage,
    this.color,
    this.sku,
    this.productId,
    this.unit,
    this.productName,
    this.categoryId,
    this.categoryName,
    this.taxName,
    this.supplyPrice,
    this.retailPrice,
    this.spplrItemNm,
    this.totWt,
    this.netWt,
    this.spplrNm,
    this.agntNm,
    this.invcFcurAmt,
    this.invcFcurCd,
    this.invcFcurExcrt,
    this.exptNatCd,
    this.dclNo,
    this.taskCd,
    this.dclDe,
    this.hsCd,
    this.imptItemSttsCd,
    this.isShared,
    this.assigned,
    this.splyAmt,
    String? id,
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
    this.itemNm,
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
    DateTime? lastTouched,
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
    this.remainingStock,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    this.inventoryRequestId,
    required this.prc,
    this.spplrItemClsCd,
    this.spplrItemCd,
    bool? ignoreForReport,
    this.supplyPriceAtSale,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc(),
        ignoreForReport = false,
        lastTouched = lastTouched ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

  /// Creates a copy of this TransactionItem with the given fields replaced by the non-null values.
  ///
  /// All parameters are optional. If a parameter is not provided, the value from
  /// the current instance will be used in the copy.
  TransactionItem copyWith(
      {String? id,
      String? name,
      int? quantityRequested,
      int? quantityApproved,
      int? quantityShipped,
      String? transactionId,
      String? variantId,
      num? qty,
      num? price,
      num? discount,
      num? remainingStock,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isRefunded,
      bool? doneWithTransaction,
      bool? active,
      num? dcRt,
      num? dcAmt,
      num? taxblAmt,
      num? taxAmt,
      num? totAmt,
      int? itemSeq,
      String? isrccCd,
      String? isrccNm,
      int? isrcRt,
      int? isrcAmt,
      String? inventoryRequestId,
      num? prc,
      String? spplrItemClsCd,
      String? spplrItemCd,
      bool? ignoreForReport,
      String? itemClsCd,
      String? itemTyCd,
      String? itemStdNm,
      String? orgnNatCd,
      int? pkg,
      String? itemCd,
      String? pkgUnitCd,
      String? qtyUnitCd,
      String? itemNm,
      num? splyAmt,
      int? tin,
      String? bhfId,
      num? dftPrc,
      String? addInfo,
      String? isrcAplcbYn,
      String? useYn,
      String? regrId,
      String? regrNm,
      String? modrId,
      String? modrNm,
      DateTime? lastTouched,
      String? purchaseId,
      Stock? stock,
      String? stockId,
      num? taxPercentage,
      String? color,
      String? sku,
      String? productId,
      String? unit,
      String? productName,
      String? categoryId,
      String? categoryName,
      String? taxName,
      num? supplyPrice,
      num? retailPrice,
      String? spplrItemNm,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      num? invcFcurExcrt,
      String? exptNatCd,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? imptItemSttsCd,
      bool? isShared,
      bool? assigned,
      String? branchId,
      bool? ebmSynced,
      bool? partOfComposite,
      num? compositePrice,
      String? taxTyCd,
      num? supplyPriceAtSale}) {
    return TransactionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantityRequested: quantityRequested ?? this.quantityRequested,
      quantityApproved: quantityApproved ?? this.quantityApproved,
      quantityShipped: quantityShipped ?? this.quantityShipped,
      transactionId: transactionId ?? this.transactionId,
      variantId: variantId ?? this.variantId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      remainingStock: remainingStock ?? this.remainingStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRefunded: isRefunded ?? this.isRefunded,
      doneWithTransaction: doneWithTransaction ?? this.doneWithTransaction,
      active: active ?? this.active,
      dcRt: dcRt ?? this.dcRt,
      dcAmt: dcAmt ?? this.dcAmt,
      taxblAmt: taxblAmt ?? this.taxblAmt,
      taxAmt: taxAmt ?? this.taxAmt,
      totAmt: totAmt ?? this.totAmt,
      itemSeq: itemSeq ?? this.itemSeq,
      isrccCd: isrccCd ?? this.isrccCd,
      isrccNm: isrccNm ?? this.isrccNm,
      isrcRt: isrcRt ?? this.isrcRt,
      isrcAmt: isrcAmt ?? this.isrcAmt,
      prc: prc ?? this.prc,
      spplrItemClsCd: spplrItemClsCd ?? this.spplrItemClsCd,
      spplrItemCd: spplrItemCd ?? this.spplrItemCd,
      ignoreForReport: ignoreForReport ?? this.ignoreForReport,
      itemClsCd: itemClsCd ?? this.itemClsCd,
      itemTyCd: itemTyCd ?? this.itemTyCd,
      itemStdNm: itemStdNm ?? this.itemStdNm,
      orgnNatCd: orgnNatCd ?? this.orgnNatCd,
      pkg: pkg ?? this.pkg,
      itemCd: itemCd ?? this.itemCd,
      pkgUnitCd: pkgUnitCd ?? this.pkgUnitCd,
      qtyUnitCd: qtyUnitCd ?? this.qtyUnitCd,
      itemNm: itemNm ?? this.itemNm,
      splyAmt: splyAmt ?? this.splyAmt,
      tin: tin ?? this.tin,
      bhfId: bhfId ?? this.bhfId,
      dftPrc: dftPrc ?? this.dftPrc,
      addInfo: addInfo ?? this.addInfo,
      isrcAplcbYn: isrcAplcbYn ?? this.isrcAplcbYn,
      useYn: useYn ?? this.useYn,
      regrId: regrId ?? this.regrId,
      regrNm: regrNm ?? this.regrNm,
      modrId: modrId ?? this.modrId,
      modrNm: modrNm ?? this.modrNm,
      lastTouched: lastTouched ?? this.lastTouched,
      purchaseId: purchaseId ?? this.purchaseId,
      stock: stock ?? this.stock,
      inventoryRequestId: inventoryRequestId ?? this.inventoryRequestId,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      color: color ?? this.color,
      sku: sku ?? this.sku,
      productId: productId ?? this.productId,
      unit: unit ?? this.unit,
      productName: productName ?? this.productName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      taxName: taxName ?? this.taxName,
      supplyPrice: supplyPrice ?? this.supplyPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      spplrItemNm: spplrItemNm ?? this.spplrItemNm,
      totWt: totWt ?? this.totWt,
      netWt: netWt ?? this.netWt,
      spplrNm: spplrNm ?? this.spplrNm,
      agntNm: agntNm ?? this.agntNm,
      invcFcurAmt: invcFcurAmt ?? this.invcFcurAmt,
      invcFcurCd: invcFcurCd ?? this.invcFcurCd,
      invcFcurExcrt: invcFcurExcrt ?? this.invcFcurExcrt,
      exptNatCd: exptNatCd ?? this.exptNatCd,
      dclNo: dclNo ?? this.dclNo,
      taskCd: taskCd ?? this.taskCd,
      dclDe: dclDe ?? this.dclDe,
      hsCd: hsCd ?? this.hsCd,
      imptItemSttsCd: imptItemSttsCd ?? this.imptItemSttsCd,
      isShared: isShared ?? this.isShared,
      assigned: assigned ?? this.assigned,
      branchId: branchId ?? this.branchId,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      partOfComposite: partOfComposite ?? this.partOfComposite,
      compositePrice: compositePrice ?? this.compositePrice,
      taxTyCd: taxTyCd ?? this.taxTyCd,
      supplyPriceAtSale: supplyPriceAtSale ?? this.supplyPriceAtSale,
    );
  }

  Map<String, dynamic> toFlipperJson() {
    return {
      'id': id,
      'name': name,
      'quantityRequested': quantityRequested,
      'quantityApproved': quantityApproved,
      'quantityShipped': quantityShipped,
      'transactionId': transactionId,
      'variantId': variantId,
      'qty': qty,
      'price': price,
      'discount': discount,
      'remainingStock': remainingStock,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isRefunded': isRefunded,
      'doneWithTransaction': doneWithTransaction,
      'active': active,
      'dcRt': dcRt,
      'dcAmt': dcAmt,
      'taxblAmt': taxblAmt,
      'taxAmt': taxAmt,
      'totAmt': totAmt,
      'itemSeq': itemSeq,
      'isrccCd': isrccCd,
      'isrccNm': isrccNm,
      'isrcRt': isrcRt,
      'isrcAmt': isrcAmt,
      'prc': prc,
      'spplrItemClsCd': spplrItemClsCd,
      'spplrItemCd': spplrItemCd,
      'ignoreForReport': ignoreForReport,
      'itemClsCd': itemClsCd,
      'itemTyCd': itemTyCd,
      'itemStdNm': itemStdNm,
      'orgnNatCd': orgnNatCd,
      'pkg': pkg,
      'itemCd': itemCd,
      'pkgUnitCd': pkgUnitCd,
      'qtyUnitCd': qtyUnitCd,
      'itemNm': itemNm,
      'splyAmt': splyAmt,
      'tin': tin,
      'bhfId': bhfId,
      'dftPrc': dftPrc,
      'addInfo': addInfo,
      'isrcAplcbYn': isrcAplcbYn,
      'useYn': useYn,
      'regrId': regrId,
      'regrNm': regrNm,
      'modrId': modrId,
      'modrNm': modrNm,
      'lastTouched': lastTouched,
      'purchaseId': purchaseId,
      'stock': stock,
      'taxPercentage': taxPercentage,
      'color': color,
      'sku': sku,
      'productId': productId,
      'unit': unit,
      'productName': productName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'taxName': taxName,
      'supplyPrice': supplyPrice,
      'retailPrice': retailPrice,
      'spplrItemNm': spplrItemNm,
      'totWt': totWt,
      'netWt': netWt,
      'spplrNm': spplrNm,
      'agntNm': agntNm,
      'invcFcurAmt': invcFcurAmt,
      'invcFcurCd': invcFcurCd,
      'invcFcurExcrt': invcFcurExcrt,
      'exptNatCd': exptNatCd,
      'dclNo': dclNo,
      'taskCd': taskCd,
      'dclDe': dclDe,
      'hsCd': hsCd,
      'imptItemSttsCd': imptItemSttsCd,
      'isShared': isShared,
      'assigned': assigned,
      'branchId': branchId,
      'ebmSynced': ebmSynced,
      'partOfComposite': partOfComposite,
      'compositePrice': compositePrice,
      'taxTyCd': taxTyCd,
      'supplyPriceAtSale': supplyPriceAtSale,
    };
  }
}
