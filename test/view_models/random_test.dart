import 'package:flipper_models/isar/random.dart';
import 'package:test/test.dart';

void main() {
  test('generateRandomString returns a string of length 15', () {
    final result = randomString();
    expect(result, isA<String>());
    expect(result.length, equals(15));
  });

  test('generateRandomInts returns a ints of length 15', () {
    final result = randomNumber();
    expect(result, isA<int>());
    expect(result.toString().length, equals(15));
  });

  test('generateRandomInt generates different ints each time', () {
    final result1 = randomNumber();
    final result2 = randomNumber();
    expect(result1, isNot(equals(result2)));
  });

  test('generateRandomString generates different strings each time', () {
    final result1 = randomString();
    final result2 = randomString();
    expect(result1, isNot(equals(result2)));
  });
}
