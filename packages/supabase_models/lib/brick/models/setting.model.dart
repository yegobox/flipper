import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'settings'),
)
class Setting extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? email;

  int? userId;
  bool? openReceiptFileOSaleComplete;
  bool? autoPrint;
  bool? sendDailyReport;
  String? defaultLanguage;
  bool? attendnaceDocCreated;
  bool? isAttendanceEnabled;
  String? type;
  bool? enrolledInBot;
  String? deviceToken;
  String? businessPhoneNumber;
  bool? autoRespond;
  String? token;
  bool? hasPin = false;
  int? businessId;
  String? createdAt;

  DateTime? lastTouched;

  DateTime? deletedAt;
  Setting({
    required this.id,
    this.email,
    this.userId,
    this.openReceiptFileOSaleComplete,
    this.autoPrint,
    this.sendDailyReport,
    this.defaultLanguage,
    this.attendnaceDocCreated,
    this.isAttendanceEnabled,
    this.type,
    this.enrolledInBot,
    this.deviceToken,
    this.businessPhoneNumber,
    this.autoRespond,
    this.token,
    this.hasPin,
    this.businessId,
    this.createdAt,
    this.lastTouched,
    this.deletedAt,
  });
}
