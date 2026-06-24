import 'package:flipper_web/core/api_login_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeApiUserLoginKey', () {
    test('adds + to bare phone numbers', () {
      expect(normalizeApiUserLoginKey('250783054874'), '+250783054874');
    });

    test('keeps phone numbers that already have +', () {
      expect(normalizeApiUserLoginKey('+250783054874'), '+250783054874');
    });

    test('keeps email and Ditto login keys unchanged', () {
      expect(
        normalizeApiUserLoginKey('157307@flipper.rw'),
        '157307@flipper.rw',
      );
      expect(
        normalizeApiUserLoginKey('user@example.com'),
        'user@example.com',
      );
    });

    test('trims whitespace before normalizing', () {
      expect(normalizeApiUserLoginKey(' 250783054874 '), '+250783054874');
    });

    test('detects Ditto flipper.rw login keys', () {
      expect(isFlipperDittoLoginKey('157307@flipper.rw'), isTrue);
      expect(isFlipperDittoLoginKey('user@example.com'), isFalse);
      expect(isFlipperDittoLoginKey('+250783054874'), isFalse);
    });
  });
}
