import 'package:flipper_services/supabase_session_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupabaseSessionService.emailFromPhone', () {
    test('maps phone digits to @flipper.rw', () {
      expect(
        SupabaseSessionService.emailFromPhone('+250783054874'),
        '250783054874@flipper.rw',
      );
      expect(
        SupabaseSessionService.emailFromPhone('250783054874'),
        '250783054874@flipper.rw',
      );
    });

    test('passes through real email login keys unchanged', () {
      expect(
        SupabaseSessionService.emailFromPhone(
          'murag.richard+cashier@gmail.com',
        ),
        'murag.richard+cashier@gmail.com',
      );
    });

    test('passes through @flipper.rw keys unchanged', () {
      expect(
        SupabaseSessionService.emailFromPhone('157307@flipper.rw'),
        '157307@flipper.rw',
      );
    });

    test('throws when non-email has no digits', () {
      expect(
        () => SupabaseSessionService.emailFromPhone('cashier'),
        throwsArgumentError,
      );
    });
  });
}
