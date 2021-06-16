import 'package:objectbox/objectbox.dart';

@Entity()
class Setting {
  Setting(
      {this.id = 0,
      required this.email,
      required this.hasPin,
      this.autoPrint,
      this.openReceiptFileOSaleComplete,
      this.defaultLanguage,
      required this.userId});
  int id;
  String email;
  String hasPin;
  int userId;
  bool? openReceiptFileOSaleComplete;
  bool? autoPrint;
  String? defaultLanguage;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
      id: json["id"],
      openReceiptFileOSaleComplete: json["openReceiptFileOSaleComplete"],
      autoPrint: json["autoPrint"],
      defaultLanguage: json["defaultLanguage"],
      email: json["email"],
      hasPin: json["hasPin"],
      userId: json["userId"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "openReceiptFileOSaleComplete": openReceiptFileOSaleComplete,
        "autoPrint": autoPrint,
        "defaultLanguage": defaultLanguage,
        "email": email,
        "hasPin": hasPin,
        "userId": userId,
      };
}
