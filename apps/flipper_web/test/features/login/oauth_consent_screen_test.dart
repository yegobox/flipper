import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/login/oauth_consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockOAuthApi extends Mock implements GoTrueOAuthApi {}

const _user = User(
  id: 'user-1',
  appMetadata: {},
  userMetadata: {},
  aud: 'authenticated',
  createdAt: '2026-01-01T00:00:00Z',
);

const _details = OAuthAuthorizationDetailsResponse(
  authorizationId: 'request-1',
  client: OAuthAuthorizedClient(clientId: 'client-1', clientName: 'Test AI'),
  redirectUri: 'https://client.test/callback',
  user: _user,
  scope: 'openid email profile',
);

const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockSupabaseClient supabaseClient;
  late _MockGoTrueClient auth;
  late _MockOAuthApi oauth;
  String? launchedUrl;

  setUp(() {
    supabaseClient = _MockSupabaseClient();
    auth = _MockGoTrueClient();
    oauth = _MockOAuthApi();
    when(() => supabaseClient.auth).thenReturn(auth);
    when(() => auth.oauth).thenReturn(oauth);
    when(() => auth.currentUser).thenReturn(_user);
    launchedUrl = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, (call) async {
          if (call.method == 'launch') {
            launchedUrl =
                (call.arguments as Map<Object?, Object?>)['url'] as String;
            return true;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, null);
  });

  Future<void> stubAuthorizationDetails() async {
    when(
      () => oauth.getAuthorizationDetails('request-1'),
    ).thenAnswer((_) async => _details);
  }

  Future<GoRouter> pumpConsent(
    WidgetTester tester, {
    String authorizationId = 'request-1',
  }) async {
    final encodedAuthorizationId = Uri.encodeQueryComponent(authorizationId);
    final router = GoRouter(
      initialLocation:
          '/oauth/consent?authorization_id=$encodedAuthorizationId',
      routes: [
        GoRoute(
          path: '/oauth/consent',
          builder: (_, state) => OAuthConsentScreen(
            authorizationId: state.uri.queryParameters['authorization_id']!,
            supabaseClient: supabaseClient,
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) =>
              Scaffold(body: Text(state.uri.queryParameters['continue'] ?? '')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('shows an unavailable message when the request ID is missing', (
    tester,
  ) async {
    when(() => auth.currentUser).thenReturn(null);

    await pumpConsent(tester, authorizationId: '');

    expect(find.text('Authorization unavailable'), findsOneWidget);
    expect(
      find.text('This authorization request is missing its request ID.'),
      findsOneWidget,
    );
    expect(find.text('Sign in to Flipper'), findsNothing);
  });

  testWidgets('sign-in keeps the authorization request as the continuation', (
    tester,
  ) async {
    when(() => auth.currentUser).thenReturn(null);

    await pumpConsent(tester);
    await tester.tap(find.text('Sign in to Flipper'));
    await tester.pumpAndSettle();

    expect(
      find.text('/oauth/consent?authorization_id=request-1'),
      findsOneWidget,
    );
  });

  testWidgets('shows the client, registered redirect, and requested scopes', (
    tester,
  ) async {
    await stubAuthorizationDetails();

    await pumpConsent(tester);

    expect(find.text('Test AI'), findsOneWidget);
    expect(find.text('https://client.test/callback'), findsOneWidget);
    expect(find.text('• openid'), findsOneWidget);
    expect(find.text('• email'), findsOneWidget);
    expect(find.text('• profile'), findsOneWidget);
    expect(find.text('Approve read-only access'), findsOneWidget);
  });

  testWidgets('approves consent and opens the registered client redirect', (
    tester,
  ) async {
    await stubAuthorizationDetails();
    when(() => oauth.approveAuthorization('request-1')).thenAnswer(
      (_) async => const OAuthConsentResponse(
        redirectUrl: 'https://client.test/callback?code=one-time-code',
      ),
    );

    await pumpConsent(tester);
    await tester.ensureVisible(find.text('Approve read-only access'));
    await tester.tap(find.text('Approve read-only access'));
    await tester.pumpAndSettle();

    expect(find.text('Access approved'), findsOneWidget);
    await tester.ensureVisible(find.text('Continue to AI client'));
    await tester.tap(find.text('Continue to AI client'));
    await tester.pumpAndSettle();

    expect(launchedUrl, 'https://client.test/callback?code=one-time-code');
  });

  testWidgets('denies consent and returns the client redirect', (tester) async {
    await stubAuthorizationDetails();
    when(() => oauth.denyAuthorization('request-1')).thenAnswer(
      (_) async => const OAuthConsentResponse(
        redirectUrl: 'https://client.test/callback?error=access_denied',
      ),
    );

    await pumpConsent(tester);
    await tester.ensureVisible(find.text('Deny'));
    await tester.tap(find.text('Deny'));
    await tester.pumpAndSettle();

    expect(find.text('Access denied'), findsOneWidget);
    await tester.ensureVisible(find.text('Continue to AI client'));
    await tester.tap(find.text('Continue to AI client'));
    await tester.pumpAndSettle();
    expect(launchedUrl, 'https://client.test/callback?error=access_denied');
  });

  testWidgets(
    'shows a fixed message when authorization loading fails and retries',
    (tester) async {
      var attempts = 0;
      when(() => oauth.getAuthorizationDetails('request-1')).thenAnswer((
        _,
      ) async {
        attempts++;
        if (attempts == 1) {
          throw const AuthException('sensitive provider response');
        }
        return _details;
      });

      await pumpConsent(tester);

      expect(
        find.text('We could not load this authorization request. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('sensitive provider response'), findsNothing);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(attempts, 2);
      expect(find.text('Test AI'), findsOneWidget);
    },
  );

  testWidgets('shows a fixed message when the consent decision fails', (
    tester,
  ) async {
    await stubAuthorizationDetails();
    when(
      () => oauth.approveAuthorization('request-1'),
    ).thenThrow(const AuthException('sensitive provider response'));

    await pumpConsent(tester);
    await tester.ensureVisible(find.text('Approve read-only access'));
    await tester.tap(find.text('Approve read-only access'));
    await tester.pumpAndSettle();

    expect(
      find.text('We could not submit your decision. Try again.'),
      findsOneWidget,
    );
    expect(find.textContaining('sensitive provider response'), findsNothing);
  });

  testWidgets('requires a returned redirect URL after a decision', (
    tester,
  ) async {
    await stubAuthorizationDetails();
    when(
      () => oauth.approveAuthorization('request-1'),
    ).thenAnswer((_) async => const OAuthConsentResponse());

    await pumpConsent(tester);
    await tester.ensureVisible(find.text('Approve read-only access'));
    await tester.tap(find.text('Approve read-only access'));
    await tester.pumpAndSettle();

    expect(
      find.text('Supabase returned no authorization redirect URL.'),
      findsOneWidget,
    );
  });

  testWidgets('rejects a callback that does not match the registered URI', (
    tester,
  ) async {
    await stubAuthorizationDetails();
    when(() => oauth.approveAuthorization('request-1')).thenAnswer(
      (_) async => const OAuthConsentResponse(
        redirectUrl: 'https://attacker.test/callback?code=one-time-code',
      ),
    );

    await pumpConsent(tester);
    await tester.ensureVisible(find.text('Approve read-only access'));
    await tester.tap(find.text('Approve read-only access'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue to AI client'));
    await tester.tap(find.text('Continue to AI client'));
    await tester.pumpAndSettle();

    expect(
      find.text('The authorization server returned an invalid redirect.'),
      findsOneWidget,
    );
    expect(launchedUrl, isNull);
  });

  testWidgets('uses the server-validated redirect for an existing grant', (
    tester,
  ) async {
    when(() => oauth.getAuthorizationDetails('request-1')).thenAnswer(
      (_) async => const OAuthAuthorizationRedirectResponse(
        redirectUrl: 'https://client.test/callback?code=one-time-code',
      ),
    );

    await pumpConsent(tester);

    expect(find.text('Access approved'), findsOneWidget);
    await tester.ensureVisible(find.text('Continue to AI client'));
    await tester.tap(find.text('Continue to AI client'));
    await tester.pumpAndSettle();

    expect(launchedUrl, 'https://client.test/callback?code=one-time-code');
  });
}
