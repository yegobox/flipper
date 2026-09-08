import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/core/signup_contact.dart';

void main() {
  group('normalizeSignupContact', () {
    test('prepends the country dial code to a local number', () {
      expect(
        normalizeSignupContact('783054874', country: 'Rwanda'),
        '+250783054874',
      );
    });

    test('drops a leading zero before prepending', () {
      expect(
        normalizeSignupContact('0783054874', country: 'Rwanda'),
        '+250783054874',
      );
    });

    test('leaves a number that already has the country dial code', () {
      expect(
        normalizeSignupContact('+250783054874', country: 'Rwanda'),
        '+250783054874',
      );
    });

    test('re-applies the dial code when the country changed', () {
      expect(
        normalizeSignupContact('+250783054874', country: 'Kenya'),
        '+254783054874',
      );
    });

    test('strips separators the user typed into the number', () {
      expect(
        normalizeSignupContact('078-305 4874', country: 'Rwanda'),
        '+250783054874',
      );
      expect(
        normalizeSignupContact('+250 783 054 874', country: 'Rwanda'),
        '+250783054874',
      );
    });

    test('passes an email through untouched', () {
      expect(
        normalizeSignupContact('user@example.com', country: 'Rwanda'),
        'user@example.com',
      );
    });

    test('keeps empty input empty so the field does not count as filled', () {
      expect(normalizeSignupContact('  ', country: 'Rwanda'), '');
    });
  });

  group('email detection', () {
    test('looksLikeEmailContact is true from the first @', () {
      expect(looksLikeEmailContact('user@'), isTrue);
      expect(looksLikeEmailContact('783054874'), isFalse);
    });

    test('isEmailContact requires a complete address', () {
      expect(isEmailContact('user@example.com'), isTrue);
      expect(isEmailContact('user@example'), isFalse);
      expect(isEmailContact('157307@flipper.rw'), isTrue);
    });
  });

  group('localPhonePart', () {
    test('strips a known dial code for display', () {
      expect(localPhonePart('+250783054874'), '783054874');
    });

    test('strips separators along with the dial code', () {
      expect(localPhonePart('+250 783-054-874'), '783054874');
    });

    test('leaves an email alone', () {
      expect(localPhonePart('user@example.com'), 'user@example.com');
    });
  });
}
