import 'package:isar/isar.dart';

part 'receipt.g.dart';

@Collection()
class Receipt {
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
  @Index()
  late String transactionId;
}
