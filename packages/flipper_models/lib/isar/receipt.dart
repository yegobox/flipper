import 'package:isar/isar.dart';

part 'receipt.g.dart';

@Collection()
class Receipt {
  Id id = Isar.autoIncrement;
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
  late int transactionId;
}
