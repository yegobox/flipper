import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder implements ProductAnalytics {
  final calls = <String>[];
  final props = <Map<String, Object?>>[];

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    calls.add('identify:$userId');
    props.add(properties);
  }

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {
    calls.add('group:$groupType:$groupKey');
    props.add(properties);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('identifies the user and groups by business and branch', () async {
    final analytics = _Recorder();

    await identifySession(
      analytics,
      source: 'login_choices',
      userId: '42',
      businessId: 'biz',
      branchId: 'br',
    );

    expect(analytics.calls, [
      'identify:42',
      'group:business:biz',
      'group:branch:br',
    ]);
    expect(analytics.props.first, {'source': 'login_choices'});
    expect(analytics.props.last, {
      'source': 'login_choices',
      'business_id': 'biz',
    });
  });

  test('no user, business or branch: nothing is merged', () async {
    final analytics = _Recorder();

    await identifySession(
      analytics,
      source: 'auth_repository',
      userId: '',
      businessId: null,
      branchId: '',
    );

    expect(analytics.calls, isEmpty);
  });

  test('names label the business and branch groups', () async {
    final analytics = _Recorder();

    await identifySession(
      analytics,
      source: 's',
      businessId: 'biz',
      branchId: 'br',
      businessName: 'Shop',
      branchName: 'Main',
    );

    expect(analytics.props, [
      {'source': 's', 'business_name': 'Shop'},
      {'source': 's', 'business_id': 'biz', 'branch_name': 'Main'},
    ]);
  });

  test('a branch without a business still groups', () async {
    final analytics = _Recorder();

    await identifySession(analytics, source: 's', branchId: 'br');

    expect(analytics.calls, ['group:branch:br']);
    expect(analytics.props.single, {'source': 's'});
  });
}
