String removeTrailingDash(String input) {
  RegExp regex = RegExp(r'-\d+$');
  return input.replaceAll(regex, '');
}

bool isGreaterThan(String str1, String str2) {
  int result = str1.compareTo(str2);
  return result > 0;
}
