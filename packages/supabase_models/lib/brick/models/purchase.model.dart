// import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'purchases'),
)
class Purchase extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  @Supabase(ignore: true)
  List<Variant>? variants;
  final String spplrTin;
  final String spplrNm;
  final String spplrBhfId;
  final int spplrInvcNo;
  final String rcptTyCd;
  final String pmtTyCd;
  final String cfmDt;
  final String salesDt;
  final String? stockRlsDt;
  final int totItemCnt;
  final num taxblAmtA;
  final num taxblAmtB;
  final num taxblAmtC;
  final num taxblAmtD;
  final num taxRtA;
  final num taxRtB;
  final num taxRtC;
  final num taxRtD;
  final num taxAmtA;
  final num taxAmtB;
  final num taxAmtC;
  final num taxAmtD;
  final num totTaxblAmt;
  final num totTaxAmt;
  final num totAmt;
  int? branchId;
  final String? remark;

  Purchase({
    String? id,
    this.branchId,
    required this.spplrTin,
    required this.spplrNm,
    required this.spplrBhfId,
    required this.spplrInvcNo,
    required this.rcptTyCd,
    required this.pmtTyCd,
    required this.cfmDt,
    required this.salesDt,
    this.stockRlsDt,
    required this.totItemCnt,
    required this.taxblAmtA,
    required this.taxblAmtB,
    required this.taxblAmtC,
    required this.taxblAmtD,
    required this.taxRtA,
    required this.taxRtB,
    required this.taxRtC,
    required this.taxRtD,
    required this.taxAmtA,
    required this.taxAmtB,
    required this.taxAmtC,
    required this.taxAmtD,
    required this.totTaxblAmt,
    required this.totTaxAmt,
    required this.totAmt,
    this.remark,
    this.variants,
  }) : id = id ?? const Uuid().v4();
  // from json method
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as String?,
      spplrTin: json['spplrTin'] as String,
      spplrNm: json['spplrNm'] as String,
      spplrBhfId: json['spplrBhfId'] as String,
      spplrInvcNo: (json['spplrInvcNo'] as num).toInt(),
      rcptTyCd: json['rcptTyCd'] as String,
      pmtTyCd: json['pmtTyCd'] as String,
      cfmDt: json['cfmDt'] as String,
      salesDt: json['salesDt'] as String,
      stockRlsDt: json['stockRlsDt'] as String?,
      totItemCnt: (json['totItemCnt'] as num).toInt(),
      taxblAmtA: (json['taxblAmtA'] as num).toDouble(),
      taxblAmtB: (json['taxblAmtB'] as num).toDouble(),
      taxblAmtC: (json['taxblAmtC'] as num).toDouble(),
      taxblAmtD: (json['taxblAmtD'] as num).toDouble(),
      taxRtA: (json['taxRtA'] as num).toDouble(),
      taxRtB: (json['taxRtB'] as num).toDouble(),
      taxRtC: (json['taxRtC'] as num).toDouble(),
      taxRtD: (json['taxRtD'] as num).toDouble(),
      taxAmtA: (json['taxAmtA'] as num).toDouble(),
      taxAmtB: (json['taxAmtB'] as num).toDouble(),
      taxAmtC: (json['taxAmtC'] as num).toDouble(),
      taxAmtD: (json['taxAmtD'] as num).toDouble(),
      totTaxblAmt: (json['totTaxblAmt'] as num).toDouble(),
      totTaxAmt: (json['totTaxAmt'] as num).toDouble(),
      totAmt: (json['totAmt'] as num).toDouble(),
      remark: json['remark'] as String?,
      variants: (json['itemList'] as List<dynamic>)
          .map((e) => Variant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  // toJson() method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spplrTin': spplrTin,
      'spplrNm': spplrNm,
      'spplrBhfId': spplrBhfId,
      'spplrInvcNo': spplrInvcNo,
      'rcptTyCd': rcptTyCd,
      'pmtTyCd': pmtTyCd,
      'cfmDt': cfmDt,
      'salesDt': salesDt,
      'stockRlsDt': stockRlsDt,
      'totItemCnt': totItemCnt,
      'taxblAmtA': taxblAmtA,
      'taxblAmtB': taxblAmtB,
      'taxblAmtC': taxblAmtC,
      'taxblAmtD': taxblAmtD,
      'taxRtA': taxRtA,
      'taxRtB': taxRtB,
      'taxRtC': taxRtC,
      'taxRtD': taxRtD,
      'taxAmtA': taxAmtA,
      'taxAmtB': taxAmtB,
      'taxAmtC': taxAmtC,
      'taxAmtD': taxAmtD,
      'totTaxblAmt': totTaxblAmt,
      'totTaxAmt': totTaxAmt,
      'totAmt': totAmt,
      'remark': remark,
      'itemList': variants,
    };
  }
}
