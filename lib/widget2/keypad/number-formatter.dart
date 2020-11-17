class NumberFormatter {
  static String format(String text) {
    try {
      final double parsedNumber = double.parse(text);

      if ((parsedNumber != double.infinity) &&
          (parsedNumber == parsedNumber.floor())) {
        return parsedNumber.truncate().toString();
      }

      return text;
    } catch (err) {
      return text;
    }
  }
}
