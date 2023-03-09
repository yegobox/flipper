import 'package:flipper_models/isar/random.dart';
import 'package:test/test.dart';

void main() {
  test('generateRandomString returns a string of length 15', () {
    final result = syncId();
    expect(result, isA<String>());
    expect(result.length, equals(15));
  });

  test('generateRandomString generates different strings each time', () {
    final result1 = syncId();
    final result2 = syncId();
    expect(result1, isNot(equals(result2)));
  });
}
