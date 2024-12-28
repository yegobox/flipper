import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'receipts'),
)
class Receipt extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

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
  int? branchId;

  int? transactionId;

  DateTime? lastTouched;

  int? invcNo;
  DateTime? whenCreated;
  int? invoiceNumber;

  Receipt({
    String? id,
    this.resultCd,
    this.resultMsg,
    this.resultDt,
    this.rcptNo,
    this.intrlData,
    this.rcptSign,
    this.totRcptNo,
    this.vsdcRcptPbctDate,
    this.sdcId,
    this.mrcNo,
    this.qrCode,
    this.receiptType,
    this.branchId,
    this.transactionId,
    this.lastTouched,
    this.invcNo,
    this.whenCreated,
    this.invoiceNumber,
  }) : id = id ?? const Uuid().v4();
}
