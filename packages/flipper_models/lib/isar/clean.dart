String removeNegativeNumber(String input) {
  RegExp regex = RegExp(r'-\d+$');
  return input.replaceAll(regex, '');
}
