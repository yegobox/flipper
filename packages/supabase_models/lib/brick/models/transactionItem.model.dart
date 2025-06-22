import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
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
  double qty;
  double price;
  double discount;
  double? remainingStock;
  DateTime? createdAt;
  DateTime? updatedAt;
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
  int? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
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

  // Additional fields from Variant
  String? purchaseId;
  Stock? stock;
  String? stockId;
  num? taxPercentage;
  String? color;
  String? sku;
  String? productId;
  String? unit;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? taxName;
  double? supplyPrice;
  double? retailPrice;
  String? spplrItemNm;
  int? totWt;
  int? netWt;
  String? spplrNm;
  String? agntNm;
  int? invcFcurAmt;
  String? invcFcurCd;
  double? invcFcurExcrt;
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
  double? compositePrice;

  @Supabase(foreignKey: 'inventory_request_id')
  InventoryRequest? inventoryRequest;

  // If the association will be created by the app, specify
  // a field that maps directly to the foreign key column
  // so that Brick can notify Supabase of the association.
  // @Sqlite(ignore: true)
  String? inventoryRequestId;

  @Sqlite(defaultValue: 'false')
  bool ignoreForReport;

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
    this.stockId,
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
    this.inventoryRequest,
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
    String? inventoryRequestId,
    required this.prc,
    this.spplrItemClsCd,
    this.spplrItemCd,
    bool? ignoreForReport,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc(),
        ignoreForReport = false,
        lastTouched = lastTouched ?? DateTime.now().toUtc(),
        inventoryRequestId = inventoryRequest?.id,
        updatedAt = updatedAt ?? DateTime.now().toUtc();
  TransactionItem copyWith({
    String? id,
    String? name,
    int? quantityRequested,
    int? quantityApproved,
    int? quantityShipped,
    String? transactionId,
    String? variantId,
    double? qty,
    double? price,
    double? discount,
    double? remainingStock,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRefunded,
    bool? doneWithTransaction,
    bool? active,
    double? dcRt,
    double? dcAmt,
    double? taxblAmt,
    double? taxAmt,
    double? totAmt,
    int? itemSeq,
    String? isrccCd,
    String? isrccNm,
    int? isrcRt,
    int? isrcAmt,
    String? inventoryRequestId,
    double? prc,
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
    double? splyAmt,
    int? tin,
    String? bhfId,
    double? dftPrc,
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
    double? supplyPrice,
    double? retailPrice,
    String? spplrItemNm,
    int? totWt,
    int? netWt,
    String? spplrNm,
    String? agntNm,
    int? invcFcurAmt,
    String? invcFcurCd,
    double? invcFcurExcrt,
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
    double? compositePrice,
    InventoryRequest? inventoryRequest,
    String? taxTyCd,
  }) {
    return TransactionItem(
      id: id,
      name: name!,
      quantityRequested: quantityRequested,
      quantityApproved: quantityApproved,
      quantityShipped: quantityShipped,
      transactionId: transactionId,
      variantId: variantId,
      qty: qty!,
      price: price!,
      discount: discount!,
      remainingStock: remainingStock,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isRefunded: isRefunded,
      doneWithTransaction: doneWithTransaction,
      active: active,
      dcRt: dcRt,
      dcAmt: dcAmt,
      taxblAmt: taxblAmt,
      taxAmt: taxAmt,
      totAmt: totAmt,
      itemSeq: itemSeq,
      isrccCd: isrccCd,
      isrccNm: isrccNm,
      isrcRt: isrcRt,
      isrcAmt: isrcAmt,
      inventoryRequestId: inventoryRequestId,
      prc: prc!,
      spplrItemClsCd: spplrItemClsCd,
      spplrItemCd: spplrItemCd,
      ignoreForReport: ignoreForReport,
      itemClsCd: itemClsCd,
      itemTyCd: itemTyCd,
      itemStdNm: itemStdNm,
      orgnNatCd: orgnNatCd,
      pkg: pkg,
      itemCd: itemCd,
      pkgUnitCd: pkgUnitCd,
      qtyUnitCd: qtyUnitCd,
      itemNm: itemNm,
      splyAmt: splyAmt,
      tin: tin,
      bhfId: bhfId,
      dftPrc: dftPrc,
      addInfo: addInfo,
      isrcAplcbYn: isrcAplcbYn,
      useYn: useYn,
      regrId: regrId,
      regrNm: regrNm,
      modrId: modrId,
      modrNm: modrNm,
      lastTouched: lastTouched,
      purchaseId: purchaseId,
      stock: stock,
      stockId: stockId,
      taxPercentage: taxPercentage,
      color: color,
      sku: sku,
      productId: productId,
      unit: unit,
      productName: productName,
      categoryId: categoryId,
      categoryName: categoryName,
      taxName: taxName,
      supplyPrice: supplyPrice,
      retailPrice: retailPrice,
      spplrItemNm: spplrItemNm,
      totWt: totWt,
      netWt: netWt,
      spplrNm: spplrNm,
      agntNm: agntNm,
      invcFcurAmt: invcFcurAmt,
      invcFcurCd: invcFcurCd,
      invcFcurExcrt: invcFcurExcrt,
      exptNatCd: exptNatCd,
      dclNo: dclNo,
      taskCd: taskCd,
      dclDe: dclDe,
      hsCd: hsCd,
      imptItemSttsCd: imptItemSttsCd,
      isShared: isShared,
      assigned: assigned,
      branchId: branchId,
      ebmSynced: ebmSynced,
      partOfComposite: partOfComposite,
      compositePrice: compositePrice,
      inventoryRequest: inventoryRequest,
      taxTyCd: taxTyCd,
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
      'inventoryRequestId': inventoryRequestId,
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
      'stockId': stockId,
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
      'inventoryRequest': inventoryRequest,
      'taxTyCd': taxTyCd,
    };
  }
}
