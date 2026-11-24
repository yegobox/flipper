import 'dart:convert';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_web/core/analytics/analytics_provider.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/auth_repository.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// flutter test test/repositories/auth_repository_analytics_test.dart
//
// Books identifies a signed-in person by the Flipper user id, the same id
// the POS app uses, so one person spans both apps. The login key (a phone
// number or email) must never reach PostHog.

class _MockSupabase extends Mock implements SupabaseClient {}

class _MockAuth extends Mock implements GoTrueClient {}

class _MockSession extends Mock implements Session {}

class _MockUserRepository extends Mock implements UserRepository {}

class _FakeSession extends Fake implements Session {}

class _RecordingAnalytics implements ProductAnalytics {
  final identified = <(String, Map<String, Object?>)>[];
  final tracked = <String>[];

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async => identified.add((userId, properties));

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async => tracked.add(eventName);

  @override
  Future<void> reloadFeatureFlags() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() => registerFallbackValue(_FakeSession()));

  late _RecordingAnalytics analytics;
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final supabase = _MockSupabase();
    final auth = _MockAuth();
    when(() => supabase.auth).thenReturn(auth);
    when(() => auth.setSession(any())).thenAnswer((_) async => AuthResponse());
    when(() => auth.currentSession).thenReturn(_MockSession());

    final users = _MockUserRepository();
    when(
      () => users.fetchAndSaveUserProfile(
        any(),
        loginKey: any(named: 'loginKey'),
        pinUserId: any(named: 'pinUserId'),
      ),
    ).thenAnswer(
      (_) async =>
          UserProfile(id: '', phoneNumber: '', token: 't', tenants: []),
    );
    when(() => users.lastFetchedApiPayload).thenReturn(null);

    analytics = _RecordingAnalytics();
    container = ProviderContainer(
      overrides: [
        supabaseProvider.overrideWithValue(supabase),
        userRepositoryProvider.overrideWithValue(users),
        productAnalyticsProvider.overrideWithValue(analytics),
      ],
    );
    addTearDown(container.dispose);
  });

  AuthRepository repositoryAnswering(Map<String, Object?> body) =>
      http.runWithClient(
        () => container.read(authRepositoryProvider),
        () => MockClient((_) async => http.Response(jsonEncode(body), 200)),
      );

  test('a sign-in identifies the Flipper user, never the login key', () async {
    final repo = repositoryAnswering({
      'refreshToken': 'refresh',
      'userId': ' 42 ',
      'phoneNumber': '+250788000000',
    });

    expect(await repo.verifyOtp('1234', '5678'), isTrue);

    final (userId, properties) = analytics.identified.single;
    expect(userId, '42');
    expect(properties, {'source': 'auth_repository'});
    expect(analytics.tracked, [AnalyticsEvents.loginSuccess]);
  });

  test('without a user id nobody is identified', () async {
    final repo = repositoryAnswering({'refreshToken': 'refresh'});

    expect(await repo.verifyTotp('1234', '5678'), isTrue);

    expect(analytics.identified, isEmpty);
    expect(analytics.tracked, [AnalyticsEvents.loginSuccess]);
  });
}
