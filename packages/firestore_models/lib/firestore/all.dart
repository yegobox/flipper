import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flipper_models/power_sync/schema.dart';

part 'all.g.dart';
// part 'all.freezed.dart';

class NullableNumConverter implements JsonConverter<num?, dynamic> {
  const NullableNumConverter();

  @override
  num? fromJson(dynamic value) {
    // Handle null directly
    if (value == null) return null;

    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
    if (value is Map<String, dynamic>) {
      if (value.containsKey('integerValue')) {
        return int.tryParse(value['integerValue']);
      }
      if (value.containsKey('doubleValue')) {
        return value['doubleValue'];
      }
    }
    // Return null for any other type.
    return null;
  }

  @override
  dynamic toJson(num? value) => value;
}

class NullableIntConverter implements JsonConverter<int?, dynamic> {
  const NullableIntConverter();

  @override
  int? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    if (value is Map<String, dynamic> && value.containsKey('integerValue')) {
      return int.tryParse(value['integerValue']);
    }
    return null; // Return null instead of throwing an error
  }

  @override
  dynamic toJson(int? value) => value;
}

class NullableDoubleConverter implements JsonConverter<double?, dynamic> {
  const NullableDoubleConverter();

  @override
  double? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    if (value is Map<String, dynamic> && value.containsKey('doubleValue')) {
      return value['doubleValue'];
    }
    return null; // Return null instead of throwing an error
  }

  @override
  dynamic toJson(double? value) => value;
}

@JsonSerializable(explicitToJson: true)
class StockRequest {
  StockRequest({
    required this.id,
    required this.main_branch_id,
    required this.sub_branch_id,
    required this.created_at,
    required this.status,
    this.delivery_date,
    this.delivery_note,
    this.order_note,
    this.customer_received_order = false,
    this.driver_request_delivery_confirmation = false,
    this.driver_id,
    required this.items,
    this.updated_at,
  });

  factory StockRequest.fromJson(Map<String, dynamic> json) =>
      _$StockRequestFromJson(json);

  @NullableIntConverter()
  final int? id; // Changed to nullable
  @NullableIntConverter()
  final int? main_branch_id; // Changed to nullable
  @NullableIntConverter()
  final int? sub_branch_id; // Changed to nullable
  @TimestampConverter()
  final DateTime? created_at; // Changed to nullable
  final String? status; // Changed to nullable
  @TimestampConverter()
  final DateTime? delivery_date;
  final String? delivery_note;
  final String? order_note;
  final bool? customer_received_order;
  final bool? driver_request_delivery_confirmation;
  @NullableIntConverter()
  final int? driver_id;
  final List<TransactionItem>? items; // Changed to nullable
  @TimestampConverter()
  final DateTime? updated_at;

  Map<String, dynamic> toJson() => _$StockRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionItem {
  TransactionItem({
    this.isTaxExempted,
    this.isRefunded,
    this.doneWithTransaction,
    this.dcRt,
    this.dcAmt,
    this.taxblAmt,
    this.taxAmt,
    this.totAmt,
    this.itemSeq,
    this.id,
    this.name,
    this.quantityRequested,
    this.quantityApproved,
    this.quantityShipped,
    this.transactionId,
    this.variantId,
    this.qty,
    this.price,
    this.discount,
    this.type,
    this.remainingStock,
    this.createdAt,
    this.updatedAt,
    this.active,
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
    this.deletedAt,
    this.action,
    this.branchId,
    this.ebmSynced,
    this.partOfComposite,
    this.compositePrice,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  @NullableIntConverter()
  final int? id;
  final String? name;
  @NullableIntConverter()
  final int? quantityRequested;
  @NullableIntConverter()
  final int? quantityApproved;
  @NullableIntConverter()
  final int? quantityShipped;
  @NullableIntConverter()
  final int? transactionId;
  @NullableIntConverter()
  final int? variantId;
  @NullableDoubleConverter()
  final double? qty;
  @NullableDoubleConverter()
  final double? price;
  @NullableDoubleConverter()
  final double? discount;
  final String? type;
  @NullableDoubleConverter()
  final double? remainingStock;
  final String? createdAt;
  final String? updatedAt;
  final bool? isTaxExempted;
  final bool? isRefunded;
  final bool? doneWithTransaction;
  final bool? active;
  @NullableDoubleConverter()
  final double? dcRt;
  @NullableDoubleConverter()
  final double? dcAmt;
  @NullableDoubleConverter()
  final double? taxblAmt;
  @NullableDoubleConverter()
  final double? taxAmt;
  @NullableDoubleConverter()
  final double? totAmt;
  @NullableIntConverter()
  final int? itemSeq;
  final String? isrccCd;
  final String? isrccNm;
  @NullableIntConverter()
  final int? isrcRt;
  @NullableIntConverter()
  final int? isrcAmt;
  final String? taxTyCd;
  final String? bcd;
  final String? itemClsCd;
  final String? itemTyCd;
  final String? itemStdNm;
  final String? orgnNatCd;
  final String? pkg;
  final String? itemCd;
  final String? pkgUnitCd;
  final String? qtyUnitCd;
  final String? itemNm;
  @NullableDoubleConverter()
  final double? prc;
  @NullableDoubleConverter()
  final double? splyAmt;
  @NullableIntConverter()
  final int? tin;
  final String? bhfId;
  @NullableDoubleConverter()
  final double? dftPrc;
  final String? addInfo;
  final String? isrcAplcbYn;
  final String? useYn;
  final String? regrId;
  final String? regrNm;
  final String? modrId;
  final String? modrNm;
  @TimestampConverter()
  final DateTime? lastTouched;
  @TimestampConverter()
  final DateTime? deletedAt;
  final String? action;
  @NullableIntConverter()
  final int? branchId;
  final bool? ebmSynced;
  final bool? partOfComposite;
  @NullableDoubleConverter()
  final double? compositePrice;

  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) return null;

    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    } else {
      throw ArgumentError(
          'Unsupported timestamp type: ${timestamp.runtimeType}');
    }
  }

  @override
  dynamic toJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}

// Variant

@JsonSerializable(explicitToJson: true)
class Variant {
  String? id;
  @NullableDoubleConverter()
  int? variant_id;
  @NullableDoubleConverter()
  DateTime? deleted_at;
  @NullableDoubleConverter()
  String? name;
  @NullableDoubleConverter()
  String? color;
  String? sku;
  @NullableDoubleConverter()
  int? product_id;
  @NullableDoubleConverter()
  String? unit;
  @NullableDoubleConverter()
  String? product_name;
  @NullableDoubleConverter()
  int? branch_id;
  @NullableDoubleConverter()
  String tax_name = "";
  double tax_percentage = 0.0;
  bool is_tax_exempted = false;
  @NullableDoubleConverter()
  int? item_seq;
  String isrcc_cd = "";
  String isrcc_nm = "";
  int isrc_rt = 0;
  int isrc_amt = 0;
  String tax_ty_cd = "B";
  String bcd = "";
  @NullableDoubleConverter()
  String? item_cls_cd;
  @NullableDoubleConverter()
  String? item_ty_cd;
  String item_std_nm = "";
  String orgn_nat_cd = "";
  String pkg = "1";
  String item_cd = "";
  String pkg_unit_cd = "CT";
  String qty_unit_cd = "BX";
  @NullableDoubleConverter()
  String? item_nm;
  double qty = 0.0;
  double prc = 0.0;
  double sply_amt = 0.0;
  @NullableDoubleConverter()
  int? tin;
  @NullableDoubleConverter()
  String? bhf_id;
  double dft_prc = 0.0;
  String add_info = "";
  String isrc_aplcb_yn = "";
  String use_yn = "";
  @NullableDoubleConverter()
  String? regr_id;
  @NullableDoubleConverter()
  String? regr_nm;
  @NullableDoubleConverter()
  String? modr_id;
  @NullableDoubleConverter()
  String? modr_nm;
  double rsd_qty = 0.0;
  @TimestampConverter()
  DateTime? last_touched;
  double supply_price = 0.0;
  double retail_price = 0.0;
  @NullableDoubleConverter()
  String? spplr_item_cls_cd;
  @NullableDoubleConverter()
  String? spplr_item_cd;
  @NullableDoubleConverter()
  String? spplr_item_nm;
  bool ebm_synced = false;
  String tax_type = "B";
  List<int> branch_ids = [];
  Stock stock;
  @TimestampConverter()
  DateTime? updated_at;

  Variant(
      {this.id,
      this.variant_id,
      this.deleted_at,
      this.name,
      this.color,
      this.sku,
      this.product_id,
      this.unit,
      this.product_name,
      this.branch_id,
      required this.tax_name,
      required this.tax_percentage,
      required this.is_tax_exempted,
      this.item_seq,
      required this.isrcc_cd,
      required this.isrcc_nm,
      required this.isrc_rt,
      required this.isrc_amt,
      required this.tax_ty_cd,
      required this.bcd,
      required this.item_cls_cd,
      required this.item_ty_cd,
      required this.item_std_nm,
      required this.orgn_nat_cd,
      required this.pkg,
      required this.item_cd,
      required this.pkg_unit_cd,
      required this.qty_unit_cd,
      required this.item_nm,
      required this.qty,
      required this.prc,
      required this.sply_amt,
      this.tin,
      this.bhf_id,
      required this.dft_prc,
      required this.add_info,
      required this.isrc_aplcb_yn,
      required this.use_yn,
      this.regr_id,
      this.regr_nm,
      this.modr_id,
      this.modr_nm,
      required this.rsd_qty,
      required this.last_touched,
      required this.supply_price,
      required this.retail_price,
      this.spplr_item_cls_cd,
      this.spplr_item_cd,
      this.spplr_item_nm,
      required this.ebm_synced,
      required this.tax_type,
      required this.branch_ids,
      required this.stock,
      this.updated_at});

  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);

  // For Firestore integration
  factory Variant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Variant.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..removeWhere((key, value) => value == null);
  }
}

@JsonSerializable(explicitToJson: true)
class Stock {
  int? id;
  int? tin;
  String? bhf_id;
  int? branch_id;
  int? variant_id;
  double current_stock = 0.0;
  double low_stock = 0;
  bool? can_tracking_stock = true;
  bool? show_low_stock_alert = true;
  int? product_id;
  bool? active;
  double value = 0.0;
  double rsd_qty = 0.0;
  double supply_price = 0.0;
  double retail_price = 0.0;
  DateTime? last_touched;
  DateTime? deleted_at;
  bool ebm_synced = false;
  bool cloud_synced = true;
  Variant? variant;
  double? initial_stock;

  Stock({
    this.id,
    this.tin,
    this.bhf_id,
    this.branch_id,
    this.variant_id,
    required this.current_stock,
    this.low_stock = 0,
    this.can_tracking_stock,
    this.show_low_stock_alert,
    this.product_id,
    this.active,
    this.value = 0.0,
    this.rsd_qty = 0.0,
    this.supply_price = 0.0,
    this.retail_price = 0.0,
    this.last_touched,
    this.deleted_at,
    this.ebm_synced = false,
    this.cloud_synced = true,
    this.variant,
    this.initial_stock,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);

  Map<String, dynamic> toJson() => _$StockToJson(this);
}

@Collection<StockRequest>(stockRequestsTable)
final stockRequestsRef = StockRequestCollectionReference();

// for variant
@Collection<Variant>(variantTable)
final variantsRef = VariantCollectionReference();

@Collection<Stock>(stocksTable)
final stocksRef = StockCollectionReference();
