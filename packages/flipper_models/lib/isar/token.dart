library flipper_models;

import 'package:isar/isar.dart';

part 'token.g.dart';

@Collection()
class Token {
  Token({this.type, this.token, this.userId});
  Id id = Isar.autoIncrement;
  String? type;
  String? token;
  @Index()
  String? userId;

  factory Token.fromJson(Map<String, dynamic> json) =>
      Token(type: json["type"], token: json["token"], userId: json["userId"]);
}
