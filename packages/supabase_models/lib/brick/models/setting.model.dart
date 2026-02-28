import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'settings'),
)
class Setting extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? email;

  String? userId;
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
  String? adminPin;
  bool? isAdminPinEnabled;
  String? businessId;
  String? createdAt;
  bool? enablePriceQuantityAdjustment;

  DateTime? lastTouched;

  DateTime? deletedAt;
  Setting({
    String? id,
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
    this.adminPin,
    this.isAdminPinEnabled,
    this.businessId,
    this.createdAt,
    this.enablePriceQuantityAdjustment,
    this.lastTouched,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'] as String?,
      email: json['email'] as String?,
      userId: json['userId'] as String?,
      openReceiptFileOSaleComplete:
          json['openReceiptFileOSaleComplete'] as bool?,
      autoPrint: json['autoPrint'] as bool?,
      sendDailyReport: json['sendDailyReport'] as bool?,
      defaultLanguage: json['defaultLanguage'] as String?,
      attendnaceDocCreated: json['attendnaceDocCreated'] as bool?,
      isAttendanceEnabled: json['isAttendanceEnabled'] as bool?,
      type: json['type'] as String?,
      enrolledInBot: json['enrolledInBot'] as bool?,
      deviceToken: json['deviceToken'] as String?,
      businessPhoneNumber: json['businessPhoneNumber'] as String?,
      autoRespond: json['autoRespond'] as bool?,
      token: json['token'] as String?,
      hasPin: json['hasPin'] as bool?,
      adminPin: json['adminPin'] as String?,
      isAdminPinEnabled: json['isAdminPinEnabled'] as bool?,
      businessId: json['businessId'] as String?,
      createdAt: json['createdAt'] as String?,
      enablePriceQuantityAdjustment:
          json['enablePriceQuantityAdjustment'] as bool?,
      lastTouched: json['lastTouched'] != null
          ? DateTime.tryParse(json['lastTouched'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userId': userId,
      'openReceiptFileOSaleComplete': openReceiptFileOSaleComplete,
      'autoPrint': autoPrint,
      'sendDailyReport': sendDailyReport,
      'defaultLanguage': defaultLanguage,
      'attendnaceDocCreated': attendnaceDocCreated,
      'isAttendanceEnabled': isAttendanceEnabled,
      'type': type,
      'enrolledInBot': enrolledInBot,
      'deviceToken': deviceToken,
      'businessPhoneNumber': businessPhoneNumber,
      'autoRespond': autoRespond,
      'token': token,
      'hasPin': hasPin,
      'adminPin': adminPin,
      'isAdminPinEnabled': isAdminPinEnabled,
      'businessId': businessId,
      'createdAt': createdAt,
      'enablePriceQuantityAdjustment': enablePriceQuantityAdjustment,
      'lastTouched': lastTouched?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
