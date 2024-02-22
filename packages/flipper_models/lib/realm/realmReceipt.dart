import 'package:realm/realm.dart';

part 'realmReceipt.g.dart'; // Generated by Realm

@RealmModel()
class _RealmReceipt {
  String? id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  String? resultCd;
  String? resultMsg;
  String? resultDt;
  int? rcptNo;
  String? intrlData;
  String? rcptSign;
  int? totRcptNo;
  String? vsdcRcptPbctDate;
  String? sdcId;
  String? mrcNo;
  String? qrCode;
  String? receiptType;
  String? transactionId;
  void updateProperties(RealmReceipt other) {
    id = other.id;
    resultCd = other.resultCd;
    resultMsg = other.resultMsg;
    resultDt = other.resultDt;
    rcptNo = other.rcptNo;
    intrlData = other.intrlData;
    rcptSign = other.rcptSign;
    totRcptNo = other.totRcptNo;
    vsdcRcptPbctDate = other.vsdcRcptPbctDate;
    sdcId = other.sdcId;
    mrcNo = other.mrcNo;
    qrCode = other.qrCode;
    receiptType = other.receiptType;
    transactionId = other.transactionId;
  }
}
