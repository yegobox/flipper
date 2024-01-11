import 'dart:math';
import 'package:uuid/uuid.dart';

///In this case, the function generates a string of length 15 using
///letters and digits, which means there are a total of 36 possible
///characters for each position in the string. Therefore, the total
///number of possible outcomes for a single call of generateRandomString
///is 36^15, which is a very large number (approximately 3.5 x 10^23).

/// If the function is called multiple times, the probability of generating
/// the same string twice is very low. In fact, the probability can be calculated
///  using the Birthday Problem, which calculates the probability of two people
/// sharing the same birthday in a group. Using this formula, the probability of
/// generating the same string twice in a group of n calls can be calculated as:

/// p = 1 - (36^15! / (36^15)^n)

/// where n is the number of times the function is called. For example,
/// if the function is called 100,000 times, the probability of generating
/// the same string twice is approximately 1 in 10^12, which is a very low probability.

//  final hexString = FlipperId().hexString;
//   return hexString.substring(0, 14) + Random().nextInt(10).toString();
String randomString() {
  final random = Random();
  final uuid = Uuid();
  final chars = uuid.v4().replaceAll("-", "") +
      DateTime.now().microsecondsSinceEpoch.toString() +
      DateTime.now()
          .subtract(const Duration(milliseconds: 100))
          .microsecondsSinceEpoch
          .toString() +
      DateTime.now()
          .subtract(const Duration(milliseconds: 200))
          .microsecondsSinceEpoch
          .toString();
  String s = String.fromCharCodes(Iterable.generate(
      15, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  print('Generated string: $s');
  return s;
}

int randomNumber() {
  var rng = Random();
  var number = "";
  for (var i = 0; i < 15; i++) {
    var digit = rng.nextInt(10);
    if (i == 0 && digit == 0) {
      digit = rng.nextInt(9) + 1;
    }
    number = number + digit.toString();
  }
  print('Generated number: $number');
  return int.parse(number);
}
