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

@Collection<StockRequest>(stockRequestsTable)
final stockRequestsRef = StockRequestCollectionReference();
