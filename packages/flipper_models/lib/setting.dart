import 'package:objectbox/objectbox.dart';

@Entity()
class Setting {
  Setting(
      {this.id = 0,
      required this.email,
      required this.hasPin,
      this.autoPrint,
      this.openReceiptFileOSaleComplete,
      this.sendDailyReport,
      this.defaultLanguage,
      this.googleSheetDocCreated,
      required this.userId});
  int id;
  String email;
  String hasPin;
  int userId;
  bool? openReceiptFileOSaleComplete;
  bool? autoPrint;
  bool? sendDailyReport;
  String? defaultLanguage;
  bool? googleSheetDocCreated;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
      id: json["id"],
      openReceiptFileOSaleComplete: json["openReceiptFileOSaleComplete"],
      autoPrint: json["autoPrint"],
      defaultLanguage: json["defaultLanguage"],
      email: json["email"],
      googleSheetDocCreated: json["googleSheetDocCreated"],
      hasPin: json["hasPin"],
      sendDailyReport: json["sendDailyReport"],
      userId: json["userId"]);
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
      };
}
