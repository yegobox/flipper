import 'package:test/test.dart';
import 'package:flipper_models/isar/utils.dart';
import 'package:flipper_models/isar/extensions.dart';

void main() {
  group('StringExtensions', () {
    test(
        'isFutureDateCompareTo should return true when current date is greater',
        () {
      const currentDate = '2023-06-15';
      const futureDate = '2023-06-12';

      expect(currentDate.isFutureDateCompareTo(futureDate), isTrue);
    });

    test('isFutureDateCompareTo should return true when current date is equal',
        () {
      const currentDate = '2023-06-12';

      expect(currentDate.isFutureDateCompareTo(currentDate), isFalse);
    });

    test(
        'isFutureDateCompareTo should return false when current date is smaller',
        () {
      const currentDate = '2023-06-10';
      const pastDate = '2023-06-12';

      expect(currentDate.isFutureDateCompareTo(pastDate), isFalse);
    });

    test('isFutureDateCompareTo should return false when comparing with null',
        () {
      const currentDate = '2023-06-12';

      expect(currentDate.isFutureDateCompareTo(null), isFalse);
    });
  });
  test('Removes negative number from end of string', () {
    expect(removeTrailingDash('2023-03-18T04:57:00.526Z-0001-1'),
        '2023-03-18T04:57:00.526Z-0001');
    expect(removeTrailingDash('2023-03-18T04:57:00.526Z-0001-134'),
        '2023-03-18T04:57:00.526Z-0001');
    expect(removeTrailingDash('2023-03-18T04:57:00.526Z-0001-299'),
        '2023-03-18T04:57:00.526Z-0001');
  });

  test('isGreaterThan should return true when str1 is greater than str2', () {
    String str1 = "2023-03-22T10:38:37.423Z-0000";
    String str2 = "2023-03-22T10:38:37.057Z-0000";
    expect(isGreaterThan(str1, str2), true);
  });
  test(
      'isGreaterThan should return true when str1 is not null and str2 is null',
      () {
    String str1 = "2023-03-22T10:38:37.423Z-0000";
    String? str2;
    expect(isGreaterThan(str1, str2), true);
  });

  test(
      'isGreaterThan should return false when str1 is null and str2 is not null',
      () {
    String? str1;
    String str2 = "2023-03-22T10:38:37.423Z-0000";
    expect(isGreaterThan(str1, str2), false);
  });

  test('isGreaterThan should return false when str1 and str2 are null', () {
    String? str1;
    String? str2;
    expect(isGreaterThan(str1, str2), false);
  });
  test('isGreaterThan should return false when str1 is less than str2', () {
    String str1 = "2023-03-22T10:38:37.057Z-0000";
    String str2 = "2023-03-22T10:38:37.423Z-0000";
    expect(isGreaterThan(str1, str2), false);
  });

  test('isGreaterThan should return false when str1 and str2 are equal', () {
    String str1 = "2023-03-22T10:38:37.057Z-0000";
    String str2 = "2023-03-22T10:38:37.057Z-0000";
    expect(isGreaterThan(str1, str2), false);
  });
}
