import 'package:objectbox/objectbox.dart';

@Entity()
class Setting {
  Setting(
      {this.id = 0,
      required this.email,
      required this.hasPin,
      required this.userId});
  int id;
  String email;
  String hasPin;
  int userId;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
      id: json["id"],
      email: json["email"],
      hasPin: json["hasPin"],
      userId: json["userId"]);
  Map<String, dynamic> toJson() =>
      {"id": id, "email": email, "hasPin": hasPin, "userId": userId};
}
