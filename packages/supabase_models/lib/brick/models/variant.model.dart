import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'variants'),
)
class Variant extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final int id;
  DateTime? deletedAt;

  String? name;
  String? color;
  String? sku;

  int? productId;
  String? unit;
  String? productName;
  int? branchId;
  String? taxName;
  @Supabase(defaultValue: "18")
  int? taxPercentage;

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
  @Supabase(defaultValue: "0")
  int? prc;
  int? splyAmt;
  int? tin;
  String? bhfId;
  @Supabase(defaultValue: "0")
  int? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;
  int? supplyPrice;
  int? retailPrice;
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? spplrItemNm;
  bool? ebmSynced;

  int? dcRt;
  DateTime? expirationDate;

  Variant({
    required this.id,
    this.deletedAt,
    // required this.stockId,
    this.name,
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
}
