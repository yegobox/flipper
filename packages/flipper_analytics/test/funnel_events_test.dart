import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder implements ProductAnalytics {
  _Recorder({this.fail = false});

  final bool fail;
  final tracked = <(String, Map<String, Object?>)>[];

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (fail) throw StateError('offline');
    tracked.add((eventName, properties));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('trackSignupCompleted', () {
    test('names the new business as the event group', () async {
      final analytics = _Recorder();

      trackSignupCompleted(
        source: 'signup_view',
        businessId: 'biz-1',
        businessTypeId: 2,
        country: 'Rwanda',
        localMode: false,
        accountMode: 'business',
        analytics: analytics,
      );
      await Future<void>.delayed(Duration.zero);

      expect(analytics.tracked.single.$1, 'signup_completed');
      expect(analytics.tracked.single.$2, {
        'source': 'signup_view',
        'business_id': 'biz-1',
        r'$groups': {'business': 'biz-1'},
        'business_type_id': 2,
        'country': 'Rwanda',
        'local_mode': false,
        'account_mode': 'business',
      });
    });

    test('leaves out choices that were not made', () async {
      final analytics = _Recorder();

      trackSignupCompleted(
        source: 'signup_view',
        businessId: 'biz-1',
        country: '',
        analytics: analytics,
      );
      await Future<void>.delayed(Duration.zero);

      expect(analytics.tracked.single.$2, {
        'source': 'signup_view',
        'business_id': 'biz-1',
        r'$groups': {'business': 'biz-1'},
      });
    });

    test('a failing send never reaches the caller', () async {
      trackSignupCompleted(
        source: 'signup_view',
        businessId: 'biz-1',
        analytics: _Recorder(fail: true),
      );
      await Future<void>.delayed(Duration.zero);
    });

    test('does nothing before analytics has started', () {
      expect(FlipperAnalytics.maybeInstance, isNull);
      trackSignupCompleted(source: 'signup_view', businessId: 'biz-1');
    });
  });

  group('trackExpenseRecorded', () {
    test('sends the surface and category type, no amount', () async {
      final analytics = _Recorder();

      trackExpenseRecorded(
        surface: 'cashbook',
        categoryType: 'suggested',
        paymentMethod: 'CASH',
        analytics: analytics,
      );
      await Future<void>.delayed(Duration.zero);

      expect(analytics.tracked.single.$1, 'expense_recorded');
      expect(analytics.tracked.single.$2, {
        'source': 'cashbook',
        'surface': 'cashbook',
        'category_type': 'suggested',
        'payment_method': 'CASH',
      });
    });

    test('leaves out an unknown payment method', () async {
      final analytics = _Recorder();

      trackExpenseRecorded(
        surface: 'books',
        categoryType: 'vat',
        paymentMethod: '',
        analytics: analytics,
      );
      await Future<void>.delayed(Duration.zero);

      expect(analytics.tracked.single.$2, {
        'source': 'books',
        'surface': 'books',
        'category_type': 'vat',
      });
    });

    test('a failing send never reaches the caller', () async {
      trackExpenseRecorded(
        surface: 'books',
        categoryType: 'account',
        analytics: _Recorder(fail: true),
      );
      await Future<void>.delayed(Duration.zero);
    });
  });
}
