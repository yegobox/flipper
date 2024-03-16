import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';

part 'receipt.g.dart';

@JsonSerializable()
@Collection()
class Receipt extends IJsonSerializable {
  late String id;
  late String resultCd;
  late String resultMsg;
  late String resultDt;
  late int rcptNo;
  late String intrlData;
  late String rcptSign;
  late int totRcptNo;
  late String vsdcRcptPbctDate;
  late String sdcId;
  late String mrcNo;
  late String qrCode;
  late String receiptType;
  late int branchId;
  @Index()
  late String transactionId;

  DateTime? lastTouched;
  String action;
  // constructor
  Receipt({
    required this.id,
    required this.resultCd,
    required this.branchId,
    required this.resultMsg,
    required this.resultDt,
    required this.rcptNo,
    required this.intrlData,
    required this.rcptSign,
    required this.totRcptNo,
    required this.vsdcRcptPbctDate,
    required this.sdcId,
    required this.mrcNo,
    required this.qrCode,
    required this.receiptType,
    required this.transactionId,
    this.lastTouched,
    this.action = "created",
  });

  // toJson
  @override
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}
