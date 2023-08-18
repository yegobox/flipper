import 'package:intl/intl.dart';

String removeTrailingDash(String input) {
  RegExp regex = RegExp(r'-\d+$');
  return input.replaceAll(regex, '');
}

bool isGreaterThan(String? str1, String? str2) {
  if (str1 == null) {
    return false;
  } else if (str2 == null) {
    return true;
  }

  DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  String str1NoDash = removeTrailingDash(str1);
  String str2NoDash = removeTrailingDash(str2);
  DateTime date1 = format.parseUtc(str1NoDash);
  DateTime date2 = format.parseUtc(str2NoDash);
  return date1.isAfter(date2);
}
