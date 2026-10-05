import 'dart:typed_data';

/// Indicator lamps under the digits of an LED customer display.
enum CustomerDisplayLamp { off, price, total, collect, change }

/// Byte frames for the 8-digit LED / VFD customer ("pole") display fitted to
/// the back of all-in-one Windows tills such as the P70E.
///
/// These displays sit on an internal COM port and speak the de-facto command
/// set shared by most of them (CD5220 / "ESC Q A"):
///   ESC @          initialise
///   FF             clear
///   ESC s n        light lamp n ('0' all off, '1' price, '2' total,
///                  '3' collect, '4' change)
///   ESC Q A … CR   show a number ('.' does not take up a digit)
abstract final class CustomerDisplayProtocol {
  static const int maxDigits = 8;

  static const int _esc = 0x1B;

  static Uint8List init() => Uint8List.fromList(const [_esc, 0x40]);

  static Uint8List clear() => Uint8List.fromList(const [0x0C]);

  static Uint8List lamp(CustomerDisplayLamp lamp) =>
      Uint8List.fromList([_esc, 0x73, 0x30 + lamp.index]);

  /// Shows [text] (digits, '.' and '-' only; anything else is dropped).
  static Uint8List show(String text) {
    final kept = text.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return Uint8List.fromList([_esc, 0x51, 0x41, ...kept.codeUnits, 0x0D]);
  }

  /// One complete update: lamp, then the amount.
  static Uint8List frame(num amount, CustomerDisplayLamp lamp) =>
      Uint8List.fromList([
        ...CustomerDisplayProtocol.lamp(lamp),
        ...show(formatAmount(amount)),
      ]);

  /// [amount] as the display shows it: no decimals for a whole amount (RWF),
  /// two otherwise. Cents are dropped first when the digits do not fit, and an
  /// amount that still does not fit shows as all nines rather than a
  /// truncated, wrong number.
  static String formatAmount(num amount) {
    final negative = amount < 0;
    final abs = amount.abs();
    final whole = abs.roundToDouble() == abs;
    var digits = whole ? abs.round().toString() : abs.toStringAsFixed(2);
    if (_digitCount(digits) > maxDigits) digits = abs.round().toString();
    final room = negative ? maxDigits - 1 : maxDigits;
    if (_digitCount(digits) > room) digits = '9' * room;
    return negative ? '-$digits' : digits;
  }

  static int _digitCount(String s) =>
      s.replaceAll(RegExp(r'[^0-9]'), '').length;
}
