import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'stock.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'variants'),
  sqliteConfig: SqliteSerializable(),
)
class Variant extends OfflineFirstWithSupabaseModel {
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
  String? taxName = "";
  double taxPercentage = 0.0;

  // add RRA fields
  int? itemSeq;
  String? isrccCd = "";
  String? isrccNm = "";
  int? isrcRt = 0;
  int? isrcAmt = 0;
  String? taxTyCd = "B";
  String? bcd = "";
  String? itemClsCd;
  String? itemTyCd;
  String? itemStdNm = "";
  String? orgnNatCd = "";
  String? pkg = "1";
  String? itemCd = "";

  String? pkgUnitCd = "CT";
  String? qtyUnitCd = "BX";
  String? itemNm;
  double qty = 0.0;
  double prc = 0.0;
  double splyAmt = 0.0;
  int? tin;
  String? bhfId;
  double? dftPrc = 0;
  String? addInfo = "";
  String? isrcAplcbYn = "";
  String? useYn = "";
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  double rsdQty = 0.0;
  DateTime? lastTouched;
  double supplyPrice = 0.0;
  double retailPrice = 0.0;
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? spplrItemNm;
  bool ebmSynced = false;

  final List<int> branchIds;
  final Stock? stock; // Assuming Stock is a defined class
  double dcRt = 0.0;
  DateTime? expirationDate;

  Variant({
    required this.id,
    this.deletedAt,
    this.name,
    this.color,
    this.sku,
    this.productId,
    this.unit,
    this.productName,
    this.branchId,
    this.taxName = "",
    this.taxPercentage = 0.0,
    this.itemSeq,
    this.isrccCd = "",
    this.isrccNm = "",
    this.isrcRt = 0,
    this.isrcAmt = 0,
    this.taxTyCd = "B",
    this.bcd = "",
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm = "",
    this.orgnNatCd = "",
    this.pkg = "1",
    this.itemCd = "",
    this.pkgUnitCd = "CT",
    this.qtyUnitCd = "BX",
    this.itemNm,
    this.qty = 0.0,
    this.prc = 0.0,
    this.splyAmt = 0.0,
    this.tin,
    this.bhfId,
    this.dftPrc = 0,
    this.addInfo = "",
    this.isrcAplcbYn = "",
    this.useYn = "",
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
    this.rsdQty = 0.0,
    this.lastTouched,
    this.supplyPrice = 0.0,
    this.retailPrice = 0.0,
    this.spplrItemClsCd,
    this.spplrItemCd,
    this.spplrItemNm,
    this.ebmSynced = false,
    required this.branchIds,
    this.stock,
    this.dcRt = 0.0,
    this.expirationDate,
  });
}
