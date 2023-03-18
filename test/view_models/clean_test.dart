import 'package:test/test.dart';
import 'package:flipper_models/isar/clean.dart';

void main() {
  test('Removes negative number from end of string', () {
    expect(removeNegativeNumber('2023-03-18T04:57:00.526Z-0001-1'),
        '2023-03-18T04:57:00.526Z-0001');
    expect(removeNegativeNumber('2023-03-18T04:57:00.526Z-0001-134'),
        '2023-03-18T04:57:00.526Z-0001');
    expect(removeNegativeNumber('2023-03-18T04:57:00.526Z-0001-299'),
        '2023-03-18T04:57:00.526Z-0001');
  });
}
