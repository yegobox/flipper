import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('describeBackendError', () {
    test('appends the Postgres code and message for an RLS rejection', () {
      final message = describeBackendError(
        'Could not add Aline Uwase.',
        PostgrestException(
          message: 'new row violates row-level security policy for table '
              '"hr_employees"',
          code: '42501',
        ),
      );

      expect(message, startsWith('Could not add Aline Uwase. [42501]'));
      expect(message, contains('row-level security'));
    });

    test('omits the bracket when there is no code', () {
      final message = describeBackendError(
        'Could not add Aline Uwase.',
        PostgrestException(message: 'connection closed'),
      );

      expect(message, 'Could not add Aline Uwase. connection closed');
    });

    test('names the rejected business scope for an RLS violation', () {
      final message = describeBackendError(
        'Could not add Aline Uwase.',
        PostgrestException(message: 'violates policy', code: rlsViolationCode),
        scope: 'business biz-1, branch branch-1',
      );

      expect(message, endsWith('(business biz-1, branch branch-1)'));
    });

    test('withholds the scope for failures that are not about permission', () {
      final message = describeBackendError(
        'Could not add Aline Uwase.',
        PostgrestException(message: 'connection closed', code: '08006'),
        scope: 'business biz-1, branch branch-1',
      );

      expect(message, isNot(contains('business biz-1')));
    });

    test('leaves a non-Postgrest error as the friendly message alone', () {
      expect(
        describeBackendError('Could not add Aline Uwase.', Exception('socket')),
        'Could not add Aline Uwase.',
      );
      expect(
        describeBackendError('Could not add Aline Uwase.', null),
        'Could not add Aline Uwase.',
      );
    });
  });
}
