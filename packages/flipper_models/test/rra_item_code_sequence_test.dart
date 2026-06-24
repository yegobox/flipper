import 'package:flipper_models/sync/utils/rra_item_code_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseRraItemCodeSequenceSuffix', () {
    test('uses last seven digits globally', () {
      expect(parseRraItemCodeSequenceSuffix('RW2CTCT0001385'), 1385);
      expect(parseRraItemCodeSequenceSuffix('RW2CTBJ0002981'), 2981);
      expect(parseRraItemCodeSequenceSuffix('short'), 0);
    });
  });

  group('maxRraItemCodeSequenceFromCodes', () {
    test('picks highest suffix across prefixes', () {
      expect(
        maxRraItemCodeSequenceFromCodes([
          'RW2CTCT0001385',
          'RW2CTBJ0001393',
          'RW2CTCT0001380',
        ]),
        1393,
      );
    });
  });
}
