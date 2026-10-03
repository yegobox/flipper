import 'package:intl/intl.dart';

final _editFormat = NumberFormat('0.######');
final _thousands = RegExp(r'^\d{1,3}(,\d{3})+$');

/// Reads an amount or quantity typed by the owner. A comma is a thousands
/// separator when it groups digits in threes ("2,500", "12,500,000"),
/// otherwise a decimal comma ("2,5"). Unreadable input is 0.
double parseAmount(String raw) {
  var s = raw.trim().replaceAll(RegExp(r'\s'), '');
  if (s.isEmpty) return 0;
  if (s.contains('.') || _thousands.hasMatch(s)) {
    s = s.replaceAll(',', '');
  } else if (','.allMatches(s).length == 1) {
    s = s.replaceAll(',', '.');
  }
  return double.tryParse(s) ?? 0;
}

/// [value] for an edit field: full precision, no grouping, so saving it
/// again does not round it.
String formatAmountForEdit(num value) => _editFormat.format(value);
