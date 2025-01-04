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
  String? pkg;
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
  @Sqlite(ignore: true)
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
  String? imptItemsttsCd;

  Variant({
    String? id,
    this.qty,
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
    this.modrId,
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
    this.imptItemsttsCd,
  }) : id = id ?? const Uuid().v4();

  // fromJson method
  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      sku: json['sku'],
      productId: json['productId'],
      unit: json['unit'],
      productName: json['productName'],
      branchId: json['branchId'],
      taxName: json['taxName'],
      taxPercentage: json['taxPercentage'],
      itemSeq: json['itemSeq'],
      isrccCd: json['isrccCd'],
      isrccNm: json['isrccNm'],
      isrcRt: json['isrcRt'],
      isrcAmt: json['isrcAmt'],
      taxTyCd: json['taxTyCd'],
      bcd: json['bcd'],
      itemClsCd: json['itemClsCd'],
      itemTyCd: json['itemTyCd'],
      itemStdNm: json['itemStdNm'],
      orgnNatCd: json['orgnNatCd'],
      pkg: json['pkg'],
      itemCd: json['itemCd'],
      pkgUnitCd: json['pkgUnitCd'],
      qtyUnitCd: json['qtyUnitCd'],
      itemNm: json['itemNm'],
      prc: json['prc'],
      splyAmt: json['splyAmt'],
      tin: json['tin'],
      bhfId: json['bhfId'],
      dftPrc: json['dftPrc'],
      addInfo: json['addInfo'],
      isrcAplcbYn: json['isrcAplcbYn'],
      useYn: json['useYn'],
      regrId: json['regrId'],
      regrNm: json['regrNm'],
      modrId: json['modrId'],
      modrNm: json['modrNm'],
      lastTouched: json['lastTouched'],
      supplyPrice: json['supplyPrice'],
      retailPrice: json['retailPrice'],
      spplrItemClsCd: json['spplrItemClsCd'],
      spplrItemCd: json['spplrItemCd'],
      spplrItemNm: json['spplrItemNm'],
      ebmSynced: json['ebmSynced'],
      dcRt: json['dcRt'],
      expirationDate: json['expirationDate'],
      totWt: json['totWt'],
      netWt: json['netWt'],
      spplrNm: json['spplrNm'],
      agntNm: json['agntNm'],
      invcFcurAmt: json['invcFcurAmt'],
      invcFcurCd: json['invcFcurCd'],
      invcFcurExcrt: json['invcFcurExcrt'],
      exptNatCd: json['exptNatCd'],
      dclNo: json['dclNo'],
      taskCd: json['taskCd'],
      dclDe: json['dclDe'],
      hsCd: json['hsCd'],
      imptItemsttsCd: json['imptItemsttsCd'],
    );
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
      'imptItemsttsCd': imptItemsttsCd,
    };
  }
}
