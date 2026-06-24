import 'package:flipper_models/sync/utils/rra_sar_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseSarNoValue', () {
    test('parses int, string, and null', () {
      expect(parseSarNoValue(4912), 4912);
      expect(parseSarNoValue('4907'), 4907);
      expect(parseSarNoValue(null), 0);
      expect(parseSarNoValue('bad'), 0);
    });
  });

  group('resolveSarForBranch', () {
    test('without Ditto returns zero counter', () async {
      final sar = await resolveSarForBranch(
        branchId: 'branch-1',
        ditto: null,
      );
      expect(sar.sarNo, 0);
      expect(sar.id, 'sar_branch-1');
    });
  });
}
