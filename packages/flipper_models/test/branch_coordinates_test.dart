import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasRealBranchCoordinates', () {
    test('rejects missing values', () {
      expect(hasRealBranchCoordinates(null, null), isFalse);
      expect(hasRealBranchCoordinates(-1.9441, null), isFalse);
      expect(hasRealBranchCoordinates(null, 30.0619), isFalse);
    });

    test('rejects the placeholders older code wrote', () {
      expect(hasRealBranchCoordinates(0, 0), isFalse);
      expect(hasRealBranchCoordinates(1, 1), isFalse);
      expect(hasRealBranchCoordinates(1.0, 1.0), isFalse);
      expect(hasRealBranchCoordinates(1.1, 1.1), isFalse);
      expect(hasRealBranchCoordinates(11, 11), isFalse);
    });

    test('rejects out-of-range values', () {
      expect(hasRealBranchCoordinates(91, 30), isFalse);
      expect(hasRealBranchCoordinates(-1.9, 181), isFalse);
      expect(hasRealBranchCoordinates(double.nan, 30), isFalse);
    });

    test('accepts a real location', () {
      expect(hasRealBranchCoordinates(-1.9441, 30.0619), isTrue);
      // Only equal pairs are placeholders; a lone 0 or 1 is a real axis value.
      expect(hasRealBranchCoordinates(0, 30.0619), isTrue);
      expect(hasRealBranchCoordinates(1, 32.58), isTrue);
    });
  });
}
