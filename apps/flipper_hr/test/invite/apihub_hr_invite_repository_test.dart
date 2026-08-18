import 'dart:convert';

import 'package:flipper_hr/features/invite/data/apihub_hr_invite_repository.dart';
import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The whole three-hop pipeline against a stubbed transport.
///
/// A real [SupabaseClient] over a [MockClient] rather than a hand-written fake:
/// the `create_agent` RPC and the `tenants` read-back are PostgREST calls, and a
/// fake of the client would only prove that the fake behaves as expected. This
/// way the request PostgREST actually builds is what gets asserted.
const _apihub = 'https://apihub.test';
const _supabaseUrl = 'https://project.supabase.test';

/// Every request the repository made, so a test can assert what was sent as well
/// as what came back.
class _Recorder {
  final requests = <http.BaseRequest>[];
  final bodies = <String>[];

  void add(http.BaseRequest request, String body) {
    requests.add(request);
    bodies.add(body);
  }

  Iterable<http.BaseRequest> to(String pathFragment) =>
      requests.where((r) => r.url.path.contains(pathFragment));

  Map<String, dynamic> bodyOf(int index) =>
      jsonDecode(bodies[index]) as Map<String, dynamic>;
}

({ApiHubHrInviteRepository repository, _Recorder recorder}) _build({
  Object? accountResponse = const {'id': 'user-1', 'phone_number': '+250788123456'},
  int accountStatus = 200,
  Object? createAgentResponse = 'tenant-1',
  int createAgentStatus = 200,
  Object? pinResponse = const {'pin': 246810},
  int pinStatus = 201,
  Object? tenantsResponse = const [{'id': 'tenant-1'}],
  int tenantsStatus = 200,
}) {
  final recorder = _Recorder();

  final mock = MockClient((request) async {
    recorder.add(request, request.body);
    final url = request.url;

    // `request:` is not optional decoration: postgrest reads
    // `response.request!.method` while parsing, so a response without it throws
    // a null-check error that looks like a create_agent failure.
    http.Response json(Object? body, int status) => http.Response(
      jsonEncode(body),
      status,
      request: request,
      headers: const {'content-type': 'application/json'},
    );

    if (url.host == Uri.parse(_apihub).host) {
      if (url.path.endsWith('/v2/api/user')) {
        return json(accountResponse, accountStatus);
      }
      if (url.path.endsWith('/v2/api/pin')) {
        return json(pinResponse, pinStatus);
      }
      return http.Response(
        'unexpected apihub path ${url.path}',
        404,
        request: request,
      );
    }

    // PostgREST.
    if (url.path.contains('/rpc/create_agent')) {
      return json(createAgentResponse, createAgentStatus);
    }
    if (url.path.contains('/tenants')) {
      return json(tenantsResponse, tenantsStatus);
    }
    return http.Response(
      'unexpected supabase path ${url.path}',
      404,
      request: request,
    );
  });

  final client = SupabaseClient(
    _supabaseUrl,
    'anon-key',
    httpClient: mock,
  );
  addTearDown(() => client.dispose());

  return (
    repository: ApiHubHrInviteRepository(
      client: client,
      apihubBaseUrl: _apihub,
      apiUsername: 'admin',
      apiPassword: 'admin',
      httpClient: mock,
      timeout: const Duration(seconds: 5),
    ),
    recorder: recorder,
  );
}

Future<HrInvite> _invite(
  ApiHubHrInviteRepository repository, {
  String contact = '0788123456',
  HrRole role = HrRole.staff,
}) => repository.invite(
  contact: contact,
  name: 'Aline Uwase',
  businessId: 'biz-1',
  branchId: 'branch-1',
  role: role,
);

void main() {
  group('the happy path', () {
    test('returns the account, tenant and PIN', () async {
      final built = _build();

      final invite = await _invite(built.repository);

      expect(invite.userId, 'user-1');
      expect(invite.tenantId, 'tenant-1');
      expect(invite.pin, '246810');
      expect(invite.role, HrRole.staff);
    });

    test('runs the three hops, plus the verify read', () async {
      final built = _build();

      await _invite(built.repository);

      expect(built.recorder.to('/v2/api/user'), hasLength(1));
      expect(built.recorder.to('/rpc/create_agent'), hasLength(1));
      expect(built.recorder.to('/v2/api/pin'), hasLength(1));
      expect(built.recorder.to('/tenants'), hasLength(1));
    });

    test('sends Basic auth to apihub', () async {
      final built = _build();

      await _invite(built.repository);

      final expected = 'Basic ${base64Encode(utf8.encode('admin:admin'))}';
      for (final request in built.recorder.to('/v2/api/')) {
        expect(request.headers['Authorization'], expected);
      }
    });

    test('the PIN is issued against the phone apihub has on file', () async {
      // Not the loosely-typed one from the roster: the login OTP goes to
      // apihub's copy, so that is the number the invitee must be told about.
      final built = _build();

      final invite = await _invite(built.repository, contact: '0788123456');

      final pinBody = jsonDecode(
        (built.recorder.requests
                .firstWhere((r) => r.url.path.endsWith('/v2/api/pin'))
            as http.Request)
            .body,
      ) as Map<String, dynamic>;

      expect(pinBody['phoneNumber'], '+250788123456');
      expect(invite.phoneNumber, '+250788123456');
    });

    test('falls back to the typed contact when apihub reports no phone',
        () async {
      final built = _build(accountResponse: const {'id': 'user-1'});

      final invite = await _invite(built.repository, contact: '0788123456');

      expect(invite.phoneNumber, '0788123456');
    });

    test('a manager invite asks create_agent for admin on HR', () async {
      final built = _build();

      await _invite(built.repository, role: HrRole.manager);

      final rpc = built.recorder.requests
          .firstWhere((r) => r.url.path.contains('/rpc/create_agent'));
      final body =
          jsonDecode((rpc as http.Request).body) as Map<String, dynamic>;

      expect(body['p_user_type'], 'Admin');
      expect((body['p_accesses'] as List).single, {
        'feature_name': 'HR',
        'access_level': 'admin',
        'status': 'active',
      });
    });

    test('accepts a tenant id wrapped in a one-row list', () async {
      final built = _build(createAgentResponse: const ['tenant-9']);

      final invite = await _invite(built.repository);

      expect(invite.tenantId, 'tenant-9');
    });
  });

  group('failures name the step that broke', () {
    test('a blank contact never reaches the network', () async {
      final built = _build();

      await expectLater(
        _invite(built.repository, contact: '   '),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.step,
            'step',
            HrInviteStep.resolveAccount,
          ),
        ),
      );
      expect(built.recorder.requests, isEmpty);
    });

    test('a failed account lookup includes the status and body', () async {
      final built = _build(
        accountResponse: const {'error': 'no such user'},
        accountStatus: 500,
      );

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.resolveAccount)
              .having((e) => e.message, 'message', contains('500'))
              .having((e) => e.message, 'message', contains('no such user')),
        ),
      );
    });

    test('an account response with no id is reported, not silently used',
        () async {
      final built = _build(accountResponse: const {'ok': true});

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.step,
            'step',
            HrInviteStep.resolveAccount,
          ),
        ),
      );
      // Nothing downstream should have run.
      expect(built.recorder.to('/rpc/create_agent'), isEmpty);
    });

    test('a create_agent failure stops before the PIN is issued', () async {
      final built = _build(
        createAgentResponse: const {
          'message': 'Branch does not belong to business',
          'code': 'P0001',
        },
        createAgentStatus: 400,
      );

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.grantMembership)
              .having(
                (e) => e.message,
                'message',
                contains('does not belong'),
              ),
        ),
      );
      expect(built.recorder.to('/v2/api/pin'), isEmpty);
    });

    test('a missing create_agent function points at the migration', () async {
      final built = _build(
        createAgentResponse: const {
          'code': 'PGRST202',
          'message': 'Could not find the function public.create_agent',
        },
        createAgentStatus: 404,
      );

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.message,
            'message',
            contains('20260518120000_agent_allow_business_login.sql'),
          ),
        ),
      );
    });

    test('a failed PIN issue is reported at that step', () async {
      final built = _build(
        pinResponse: const {'error': 'pin service down'},
        pinStatus: 502,
      );

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.issuePin)
              .having((e) => e.message, 'message', contains('502')),
        ),
      );
    });

    test('a PIN response with no pin is reported', () async {
      final built = _build(pinResponse: const {'created': true});

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.step,
            'step',
            HrInviteStep.issuePin,
          ),
        ),
      );
    });

    test('a non-JSON body is reported rather than crashing the parse', () async {
      final recorder = _Recorder();
      final mock = MockClient((request) async {
        recorder.add(request, request.body);
        return http.Response(
          '<html>502 Bad Gateway</html>',
          200,
          request: request,
        );
      });
      final client = SupabaseClient(_supabaseUrl, 'anon-key', httpClient: mock);
      addTearDown(() => client.dispose());
      final repository = ApiHubHrInviteRepository(
        client: client,
        apihubBaseUrl: _apihub,
        apiUsername: 'admin',
        apiPassword: 'admin',
        httpClient: mock,
      );

      await expectLater(
        _invite(repository),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.resolveAccount)
              .having((e) => e.message, 'message', contains('not JSON')),
        ),
      );
    });

    test('an account with no tenant for this business is not a success',
        () async {
      // The case flipper_dashboard's addUserStatic warns about: sign-in works and
      // then resolves to nothing.
      final built = _build(tenantsResponse: const <Map<String, dynamic>>[]);

      await expectLater(
        _invite(built.repository),
        throwsA(
          isA<HrInviteException>()
              .having((e) => e.step, 'step', HrInviteStep.verify)
              .having(
                (e) => e.message,
                'message',
                contains('no membership for this business'),
              ),
        ),
      );
    });

    test('a timeout says so, rather than surfacing as a parse failure',
        () async {
      final mock = MockClient((request) async {
        // Longer than the repository's timeout.
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return http.Response('{}', 200, request: request);
      });
      final client = SupabaseClient(_supabaseUrl, 'anon-key', httpClient: mock);
      addTearDown(() => client.dispose());
      final repository = ApiHubHrInviteRepository(
        client: client,
        apihubBaseUrl: _apihub,
        apiUsername: 'admin',
        apiPassword: 'admin',
        httpClient: mock,
        timeout: const Duration(milliseconds: 20),
      );

      await expectLater(
        _invite(repository),
        throwsA(
          isA<HrInviteException>().having(
            (e) => e.message,
            'message',
            contains('did not answer in time'),
          ),
        ),
      );
    });
  });
}
