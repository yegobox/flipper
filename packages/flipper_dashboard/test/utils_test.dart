import 'package:test/test.dart';
import 'package:flipper_models/helperModels/utils.dart';
import 'package:flipper_models/helperModels/extensions.dart';

//  flutter test test/utils_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('String to Int List Extension Tests', () {
    test('Converts string to int list', () {
      String numbersString =
          "181,47,136,193,249,163,43,178,217,160,106,37,195,197,222,10,208,172,199,252,9,61,227,135,49,185,82,247,164,230,187,79,200,147,87,203,51,146,16,56,142,119,141,106,169,60,93,67,248,82,64,122,86,122,118,219,87,74,120,253,137,116,22,93";

      List<int> expectedList = [
        181,
        47,
        136,
        193,
        249,
        163,
        43,
        178,
        217,
        160,
        106,
        37,
        195,
        197,
        222,
        10,
        208,
        172,
        199,
        252,
        9,
        61,
        227,
        135,
        49,
        185,
        82,
        247,
        164,
        230,
        187,
        79,
        200,
        147,
        87,
        203,
        51,
        146,
        16,
        56,
        142,
        119,
        141,
        106,
        169,
        60,
        93,
        67,
        248,
        82,
        64,
        122,
        86,
        122,
        118,
        219,
        87,
        74,
        120,
        253,
        137,
        116,
        22,
        93
      ];

      expect(numbersString.toIntList(), equals(expectedList));
    });

    // Add more test cases if needed
  });
  group('StringExtensions', () {
    test(
        'isFutureDateCompareTo should return true when current date is greater',
        () {
      final currentDate = DateTime.now();
      final futureDate = currentDate.add(const Duration(seconds: 1));

      expect(futureDate.isNewDateCompareTo(currentDate), isTrue);
    });

    test('isFutureDateCompareTo should return true when current date is equal',
        () {
      final currentDate = DateTime.now();

      expect(currentDate.isNewDateCompareTo(currentDate), isFalse);
    });

    test(
        'isNewDateCompareTo should return false when current date is not greater',
        () {
      final pastDate = DateTime.now();
      final currentDate = pastDate.subtract(const Duration(seconds: 1));

      expect(pastDate.compareTo(currentDate) < 0, isFalse);
    });

    test('isFutureDateCompareTo should return false when comparing with null',
        () {
      final currentDate = DateTime.now();

      expect(currentDate.isNewDateCompareTo(null), isFalse);
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
  group('RealmEJsonConverterExtension', () {
    test('convertRealmValues handles basic types correctly', () {
      final testMap = {
        'string': 'test',
        'int': {'\$numberInt': '42'},
        'double': {'\$numberDouble': '3.14'},
        'date': {
          '\$date': {'\$numberLong': '1625097600000'}
        },
        'objectId': {'\$oid': '60e1f1f1f1f1f1f1f1f1f1f1'},
      };

      final result = testMap.toFlipperJson();

      expect(result['string'], equals('test'));
      expect(result['int'], equals(42));
      expect(result['double'], equals(3.14));
      expect(result['date'], isA<String>());
      expect(result['objectId'], equals('60e1f1f1f1f1f1f1f1f1f1f1'));
    });

    test('convertRealmValues swaps id and serverId correctly', () {
      final testMap = {
        'id': 'originalId',
        'serverId': 'originalServerId',
        'otherField': 'value',
      };

      final result = testMap.toFlipperJson();

      expect(result['id'], equals('originalServerId'));
      expect(result['serverId'], equals('originalId'));
      expect(result['otherField'], equals('value'));
    });
    group('CurrencyFormatExtension tests', () {
      test('should format a positive number correctly', () {
        expect((123.45).toRwf(), equals('RWF 123.45'));
      });

      test('should format a negative number correctly', () {
        expect((-123.45).toRwf(), equals('-RWF 123.45'));
      });

      test('should format zero correctly', () {
        expect(0.toRwf(), equals('RWF'));
      });

      test('should format 0.0 correctly', () {
        expect(0.0.toRwf(), equals('RWF'));
      });

      test('should format a large number correctly', () {
        expect(123456789.12.toRwf(), equals('RWF 123,456,789.12'));
      });

      test('should handle a custom symbol', () {
        expect(123.45.toRwf(symbol: 'FRW '), equals('FRW 123.45'));
      });
    });
    // test('convertRealmValues handles nested structures', () {
    //   final testMap = {
    //     'nested': {
    //       'array': [
    //         {'\$numberInt': '1'},
    //         {'\$numberDouble': '2.5'},
    //         {
    //           'nestedObject': {
    //             '\$date': {'\$numberLong': '1625097600000'}
    //           }
    //         },
    //       ],
    //     },
    //   };

    //   final result = testMap.convertRealmValues();

    //   expect(result['nested']['array'][0], equals(1));
    //   expect(result['nested']['array'][1], equals(2.5));
    //   expect(result['nested']['array'][2]['nestedObject'], isA<String>());
    //   expect(result['nested']['array'][2]['nestedObject'],
    //       equals('2021-07-01T00:00:00.000Z'));
    // });
  });
}
