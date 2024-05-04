import 'package:flipper_models/helperModels/random.dart';
import 'package:test/test.dart';

void main() {
  test('generateRandomString returns a string of length 15', () {
    final result = randomString();
    expect(result, isA<String>());
    expect(result.toString().length, equals(15));
  });

  test('randomNumber() generates unique 15-digit integers', () {
    Set<int> generatedNumbers = {};

    for (int i = 0; i < 1000; i++) {
      final result = randomNumber();

      // Check if the result is an integer
      expect(result, isA<int>());

      // Check if the result has 15 digits
      expect(result.toString().length, equals(15));

      // Check if the result is unique
      expect(generatedNumbers.contains(result), isFalse);

      generatedNumbers.add(result);
    }
  });

  test('generateRandomInt generates different ints each time', () {
    final result1 = randomNumber();
    final result2 = randomNumber();
    expect(result1, isNot(equals(result2)));
  });

  test('generateRandomString generates different strings each time', () {
    final result1 = randomNumber();
    final result2 = randomNumber();
    expect(result1, isNot(equals(result2)));
  });
}
