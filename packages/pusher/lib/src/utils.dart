import 'package:crypto/crypto.dart';
import 'dart:convert';

String hmac256(String secret, String toSign) {
  List<int> secretBytes = utf8.encode(secret);
  List<int> messageBytes = utf8.encode(toSign);
  final hmac = new Hmac(sha256, secretBytes);
  return hmac.convert(messageBytes).toString();
}

String md5Hash(String data) => md5.convert(utf8.encode(data)).toString();
