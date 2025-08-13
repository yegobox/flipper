import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

String formatNumber(double number) {
  if (number.abs() >= 1000000000000) {
    return '${(number / 1000000000000).toStringAsFixed(1)}T';
  } else if (number.abs() >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number.abs() >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number.abs() >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return NumberFormat('#,###').format(number);
  }
}
