import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/stock.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'variants'),
)
class Variant extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  Stock? stock;
  int? stockId;
  DateTime? deletedAt;
  @Sqlite(defaultValue: "18.0", columnType: Column.num)
  @Supabase(defaultValue: "18.0")
  num? taxPercentage;
  String name;
  String? color;
  String? sku;

  int? productId;
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

  Variant({
    required this.id,
    this.deletedAt,
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
  });
  // toJson() method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deletedAt': deletedAt,
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
      'lastTouched': lastTouched,
      'supplyPrice': supplyPrice,
      'retailPrice': retailPrice,
      'spplrItemClsCd': spplrItemClsCd,
      'spplrItemCd': spplrItemCd,
      'spplrItemNm': spplrItemNm,
      'ebmSynced': ebmSynced,
      'dcRt': dcRt,
      'expirationDate': expirationDate,
    };
  }
}
