import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'variants'),
)
class Variant extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  @Supabase(foreignKey: 'purchase_id')
  @Sqlite(index: true)
  String? purchaseId;
  Stock? stock;
  String? stockId;

  @Sqlite(defaultValue: "18.0", columnType: Column.num)
  @Supabase(defaultValue: "18.0")
  num? taxPercentage;
  String name;
  String? color;
  String? sku;

  String? productId;
  String? unit;
  String? productName;
  int? branchId;
  String? taxName;

  // add RRA fields
  int? itemSeq;
  String? isrccCd;
  String? isrccNm;
  int? isrcRt;
  int? isrcAmt;
  String? taxTyCd;
  String? bcd;
  String? itemClsCd;
  String? itemTyCd;
  String? itemStdNm;
  String? orgnNatCd;
  int? pkg;
  String? itemCd;

  String? pkgUnitCd;
  String? qtyUnitCd;
  String? itemNm;
  @Supabase(defaultValue: "0.0")
  double? prc;
  double? splyAmt;
  int? tin;
  String? bhfId;
  @Supabase(defaultValue: "0.0")
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;
  double? supplyPrice;
  double? retailPrice;
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? spplrItemNm;
  bool? ebmSynced;

  double? dcRt;
  DateTime? expirationDate;

  /// only a placeholder for capturing stock quantity for this variant,
  /// since when capturing qty we only have variant and not stock.

  @Sqlite(defaultValue: "0.0", ignore: true)
  @Supabase(ignore: true)
  double? qty;
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double? rsdQty;

  /// add more field to support importing

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
  @Sqlite(name: 'impt_item_stts_cd')
  @Supabase(name: 'impt_item_stts_cd')
  String? imptItemSttsCd;

  // helper fields
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  String? barCode;
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  String? bcdU;
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double? quantity;
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  String? category;

  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  final double? dcAmt;

  final double? taxblAmt;

  final double? taxAmt;

  final double? totAmt;

  String? pchsSttsCd;
  // end of fields to ignore

  List<int>? branchIds;

  Variant({
    String? id,
    this.pchsSttsCd,
    this.qty,
    this.branchIds,
    this.stock,
    this.stockId,
    required this.name,
    this.color,
    this.sku,
    this.productId,
    this.unit,
    this.productName,
    this.branchId,
    this.taxName,
    this.taxPercentage,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm,
    this.isrcRt,
    this.isrcAmt,
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
    this.prc,
    this.splyAmt,
    this.tin,
    this.bhfId,
    this.dftPrc,
    this.addInfo,
    this.isrcAplcbYn,
    this.useYn,
    this.regrId,
    this.regrNm,
    String? modrId,
    this.modrNm,
    this.lastTouched,
    this.supplyPrice,
    this.retailPrice,
    this.spplrItemClsCd,
    this.spplrItemCd,
    this.spplrItemNm,
    this.ebmSynced,
    this.dcRt,
    this.expirationDate,
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
    String? imptItemSttsCd,
    this.barCode,
    this.bcdU,
    this.quantity,
    this.category,
    this.purchaseId,
    this.totAmt,
    this.taxblAmt,
    this.taxAmt,
    this.dcAmt = 0.0,
  })  : id = id ?? const Uuid().v4(),
        imptItemSttsCd = imptItemSttsCd ?? '3',
        modrId = modrId ?? const Uuid().v4().substring(0, 5);

  // fromJson method
  factory Variant.fromJson(Map<String, dynamic> json) {
    try {
      // Parse safely with type checks and default values
      T parseOrDefault<T>(dynamic value, T defaultValue) {
        if (value == null) return defaultValue;
        if (value is T) return value;
        return defaultValue;
      }

      return Variant(
        id: parseOrDefault<String>(json['id'], const Uuid().v4()),
        name: parseOrDefault<String>(json['name'], ''),
        color: parseOrDefault<String>(json['color'], ''),
        sku: parseOrDefault<String>(json['sku'], ''),
        productId: parseOrDefault<String>(json['productId'], ''),
        unit: parseOrDefault<String>(json['unit'], ''),
        qty: (json['qty'] as num?)?.toDouble() ?? 1.0,
        productName: parseOrDefault<String>(json['productName'], ''),
        branchId: parseOrDefault<int>(json['branchId'], 0),
        taxName: parseOrDefault<String>(json['taxName'], ''),
        taxPercentage:
            (json['taxPercentage'] as num?)?.toDouble() ?? 1.0, // Default to 1
        itemSeq: parseOrDefault<int>(json['itemSeq'], 1),
        isrccCd: parseOrDefault<String>(json['isrccCd'], ''),
        isrccNm: parseOrDefault<String>(json['isrccNm'], ''),
        isrcRt: (json['isrcRt'] as num?)?.toInt() ?? 0,
        isrcAmt: (json['isrcAmt'] as num?)?.toInt() ?? 0,
        taxTyCd: parseOrDefault<String>(json['taxTyCd'], ''),
        bcd: parseOrDefault<String>(json['bcd'], ''),
        itemClsCd: parseOrDefault<String>(json['itemClsCd'], ''),
        itemTyCd: parseOrDefault<String>(json['itemTyCd'], ''),
        itemStdNm: parseOrDefault<String>(json['itemStdNm'], ''),
        orgnNatCd: parseOrDefault<String>(json['orgnNatCd'], ''),
        pkg: (json['pkg'] as num?)?.toInt() ?? 1,
        itemCd: parseOrDefault<String>(json['itemCd'], ''),
        pkgUnitCd: parseOrDefault<String>(json['pkgUnitCd'], ''),
        qtyUnitCd: parseOrDefault<String>(json['qtyUnitCd'], ''),
        itemNm: parseOrDefault<String>(json['itemNm'], ''),
        prc: (json['prc'] as num?)?.toDouble() ?? 0.0,
        splyAmt: (json['splyAmt'] as num?)?.toDouble() ?? 0.0,
        tin: parseOrDefault<int>(json['tin'], 0),
        bhfId: parseOrDefault<String>(json['bhfId'], ''),
        dftPrc: (json['dftPrc'] as num?)?.toDouble() ?? 0.0,
        addInfo: parseOrDefault<String>(json['addInfo'], ''),
        isrcAplcbYn: parseOrDefault<String>(json['isrcAplcbYn'], 'Y'),
        useYn: parseOrDefault<String>(json['useYn'], ''),
        regrId: parseOrDefault<String>(json['regrId'], ''),
        regrNm: parseOrDefault<String>(json['regrNm'], ''),
        modrId: parseOrDefault<String>(json['modrId'], ''),
        modrNm: parseOrDefault<String>(json['modrNm'], ''),
        lastTouched: (json['lastTouched'] != null)
            ? DateTime.tryParse(json['lastTouched'] as String)
            : null,
        supplyPrice: (json['supplyPrice'] as num?)?.toDouble() ?? 0.0,
        retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
        spplrItemClsCd: parseOrDefault<String>(json['spplrItemClsCd'], ''),
        spplrItemCd: parseOrDefault<String>(json['spplrItemCd'], ''),
        spplrItemNm: parseOrDefault<String>(json['spplrItemNm'], ''),
        ebmSynced: parseOrDefault<bool>(json['ebmSynced'], false),
        dcRt: (json['dcRt'] as num?)?.toDouble() ?? 0.0,
        expirationDate: (json['expirationDate'] != null)
            ? DateTime.tryParse(json['expirationDate'] as String)
            : null,
        totWt: (json['totWt'] as num?)?.toInt() ?? 0,
        netWt: (json['netWt'] as num?)?.toInt() ?? 0,
        spplrNm: parseOrDefault<String>(json['spplrNm'], ''),
        agntNm: parseOrDefault<String>(json['agntNm'], ''),
        invcFcurAmt: (json['invcFcurAmt'] as num?)?.toInt() ?? 0,
        invcFcurCd: parseOrDefault<String>(json['invcFcurCd'], ''),
        invcFcurExcrt: (json['invcFcurExcrt'] as num?)?.toDouble() ?? 0.0,
        exptNatCd: parseOrDefault<String>(json['exptNatCd'], ''),
        dclNo: parseOrDefault<String>(json['dclNo'], ''),
        taskCd: parseOrDefault<String>(json['taskCd'], ''),
        dclDe: parseOrDefault<String>(json['dclDe'], ''),
        hsCd: parseOrDefault<String>(json['hsCd'], ''),

        /// because rra api in reponse return imptItemsttsCd yet when they request data
        /// they want imptItemSttsCd when receiving data we use imptItemsttsCd not imptItemSttsCd
        imptItemSttsCd: parseOrDefault<String>(json['imptItemsttsCd'], ''),
        barCode: parseOrDefault<String>(json['barCode'], ''),
        bcdU: parseOrDefault<String>(json['bcdU'], ''),
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
        category: parseOrDefault<String>(json['category'], ''),
        totAmt: (json['totAmt'] as num?)?.toDouble() ?? 0.0,
        taxblAmt: (json['taxblAmt'] as num?)?.toDouble() ?? 0.0,
        taxAmt: (json['taxAmt'] as num?)?.toDouble() ?? 0.0,
        dcAmt: (json['dcAmt'] as num?)?.toDouble() ?? 0.0,
        purchaseId: parseOrDefault<String>(json['purchaseId'], ''),
      );
    } catch (e, s) {
      print('Error parsing Variant JSON: $e');
      print(s);
      throw FormatException('Failed to parse Variant JSON: $e');
    }
  }

  // toJson() method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'sku': sku,
      'productId': productId,
      'unit': unit,
      'productName': productName,
      'branchId': branchId,
      'taxName': taxName,
      'taxPercentage': taxPercentage,
      'itemSeq': itemSeq,
      'isrccCd': isrccCd,
      'isrccNm': isrccNm,
      'isrcRt': isrcRt,
      'isrcAmt': isrcAmt,
      'taxTyCd': taxTyCd,
      'bcd': bcd,
      'itemClsCd': itemClsCd,
      'itemTyCd': itemTyCd,
      'itemStdNm': itemStdNm,
      'orgnNatCd': orgnNatCd,
      'pkg': pkg,
      'itemCd': itemCd,
      'pkgUnitCd': pkgUnitCd,
      'qtyUnitCd': qtyUnitCd,
      'itemNm': itemNm,
      'prc': prc,
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
      'supplyPrice': supplyPrice,
      'retailPrice': retailPrice,
      'spplrItemClsCd': spplrItemClsCd,
      'spplrItemCd': spplrItemCd,
      'spplrItemNm': spplrItemNm,
      'ebmSynced': ebmSynced,
      'dcRt': dcRt,
      'rsdQty': rsdQty,
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
      'totAmt': totAmt,
      'taxblAmt': taxblAmt,
      'taxAmt': taxAmt,
      'dcAmt': dcAmt,
      'purchaseId': purchaseId,
      "lastTouched": lastTouched?.toIso8601String(),
      'qty': qty
    };
  }

  // copyWith method
  Variant copyWith({
    String? id,
    Stock? stock,
    String? stockId,
    num? taxPercentage,
    String? name,
    String? color,
    String? sku,
    String? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName,
    int? itemSeq,
    String? isrccCd,
    String? isrccNm,
    int? isrcRt,
    int? isrcAmt,
    String? taxTyCd,
    String? bcd,
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm,
    String? orgnNatCd,
    int? pkg,
    String? itemCd,
    String? pkgUnitCd,
    String? qtyUnitCd,
    String? itemNm,
    double? prc,
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
    double? supplyPrice,
    double? retailPrice,
    String? spplrItemClsCd,
    String? spplrItemCd,
    String? spplrItemNm,
    bool? ebmSynced,
    double? dcRt,
    DateTime? expirationDate,
    double? qty,
    double? rsdQty,
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
    String? barCode,
    String? bcdU,
    double? quantity,
    String? category,
    double? dcAmt,
    double? totAmt,
    double? taxblAmt,
    double? taxAmt,
    String? purchaseId,
  }) {
    return Variant(
      id: id ?? this.id,
      stock: stock ?? this.stock,
      stockId: stockId ?? this.stockId,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      name: name ?? this.name,
      color: color ?? this.color,
      sku: sku ?? this.sku,
      productId: productId ?? this.productId,
      unit: unit ?? this.unit,
      productName: productName ?? this.productName,
      branchId: branchId ?? this.branchId,
      taxName: taxName ?? this.taxName,
      itemSeq: itemSeq ?? this.itemSeq,
      isrccCd: isrccCd ?? this.isrccCd,
      isrccNm: isrccNm ?? this.isrccNm,
      isrcRt: isrcRt ?? this.isrcRt,
      isrcAmt: isrcAmt ?? this.isrcAmt,
      taxTyCd: taxTyCd ?? this.taxTyCd,
      bcd: bcd ?? this.bcd,
      itemClsCd: itemClsCd ?? this.itemClsCd,
      itemTyCd: itemTyCd ?? this.itemTyCd,
      itemStdNm: itemStdNm ?? this.itemStdNm,
      orgnNatCd: orgnNatCd ?? this.orgnNatCd,
      pkg: pkg ?? this.pkg,
      itemCd: itemCd ?? this.itemCd,
      pkgUnitCd: pkgUnitCd ?? this.pkgUnitCd,
      qtyUnitCd: qtyUnitCd ?? this.qtyUnitCd,
      itemNm: itemNm ?? this.itemNm,
      prc: prc ?? this.prc,
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
      supplyPrice: supplyPrice ?? this.supplyPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      spplrItemClsCd: spplrItemClsCd ?? this.spplrItemClsCd,
      spplrItemCd: spplrItemCd ?? this.spplrItemCd,
      spplrItemNm: spplrItemNm ?? this.spplrItemNm,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      dcRt: dcRt ?? this.dcRt,
      expirationDate: expirationDate ?? this.expirationDate,
      qty: qty ?? this.qty,
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
      barCode: barCode ?? this.barCode,
      bcdU: bcdU ?? this.bcdU,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      dcAmt: dcAmt ?? this.dcAmt,
      totAmt: totAmt ?? this.totAmt,
      taxblAmt: taxblAmt ?? this.taxblAmt,
      taxAmt: taxAmt ?? this.taxAmt,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }
}
