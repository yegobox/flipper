import 'package:isar/isar.dart';
part 'setting.g.dart';

@Collection()
class Setting {
  Setting({
    this.id = 0,
    required this.email,
    required this.hasPin,
    this.autoPrint,
    this.openReceiptFileOSaleComplete,
    this.sendDailyReport,
    this.defaultLanguage,
    this.googleSheetDocCreated,
    required this.userId,
    this.attendnaceDocCreated,
    this.isAttendanceEnabled,
  });
  late int id = Isar.autoIncrement;
  late String email;
  late String hasPin;
  late int userId;
  late bool? openReceiptFileOSaleComplete;
  late bool? autoPrint;
  late bool? sendDailyReport;
  late String? defaultLanguage;
  late bool? googleSheetDocCreated;
  late bool? attendnaceDocCreated;
  late bool? isAttendanceEnabled;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["id"],
        openReceiptFileOSaleComplete: json["openReceiptFileOSaleComplete"],
        autoPrint: json["autoPrint"],
        defaultLanguage: json["defaultLanguage"],
        email: json["email"],
        googleSheetDocCreated: json["googleSheetDocCreated"],
        hasPin: json["hasPin"],
        sendDailyReport: json["sendDailyReport"],
        userId: json["userId"],
        attendnaceDocCreated: json["attendnaceDocCreated"],
        isAttendanceEnabled: json["isAttendanceEnabled"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "openReceiptFileOSaleComplete": openReceiptFileOSaleComplete,
        "autoPrint": autoPrint,
        "defaultLanguage": defaultLanguage,
        "email": email,
        "googleSheetDocCreated": googleSheetDocCreated,
        "sendDailyReport": sendDailyReport,
        "hasPin": hasPin,
        "userId": userId,
        "attendnaceDocCreated": attendnaceDocCreated,
        "isAttendanceEnabled": isAttendanceEnabled,
      };
}
