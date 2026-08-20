import 'dart:async';
import 'dart:convert';

import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/invite/data/hr_invite_repository.dart';
import 'package:flipper_hr/features/invite/data/hr_invite_wire.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// The real invite pipeline: apihub for the account and the PIN, Supabase for
/// the tenant membership.
///
/// The same three hops flipper_dashboard's `TenantOperationsMixin.addUserStatic`
/// makes, and the same ones `CapellaTenantMixin.createPin` fronts — HR just runs
/// them from the web app instead of the POS, so an HR-only hire never has to be
/// added through Flipper POS first.
///
///   1. `POST $apihub/v2/api/user`  → the login account (`auth.users.id`)
///   2. `create_agent` RPC          → `tenants` + `accesses` for this business
///   3. `POST $apihub/v2/api/pin`   → the PIN the person types in
///   4. read `tenants` back         → a half-finished invite must not look done
///
/// Step 4 is not ceremony: `create_agent` is `SECURITY DEFINER` and swallows its
/// own errors into a generic `RAISE`, and the account can already exist without a
/// tenant for this business. Reading the row back is the only way to tell a real
/// invite from one that will fail at sign-in.
class ApiHubHrInviteRepository implements HrInviteRepository {
  ApiHubHrInviteRepository({
    required SupabaseClient client,
    required String apihubBaseUrl,
    required String apiUsername,
    required String apiPassword,
    http.Client? httpClient,
    Duration? timeout,
  }) : _client = client,
       _apihub = apihubBaseUrl,
       _basicAuth =
           'Basic ${base64Encode(utf8.encode('$apiUsername:$apiPassword'))}',
       _http = httpClient ?? http.Client(),
       _timeout = timeout ?? const Duration(seconds: 30);

  final SupabaseClient _client;
  final String _apihub;
  final String _basicAuth;
  final http.Client _http;
  final Duration _timeout;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': _basicAuth,
  };

  @override
  Future<HrInvite> invite({
    required String contact,
    required String name,
    required String businessId,
    required String branchId,
    required HrRole role,
  }) async {
    final trimmedContact = contact.trim();
    if (trimmedContact.isEmpty) {
      throw HrInviteException(
        'A phone number or email is needed before this person can be invited.',
        step: HrInviteStep.resolveAccount,
      );
    }

    final account = await _resolveAccount(trimmedContact);
    final tenantId = await _grantMembership(
      userId: account.id,
      name: name,
      contact: trimmedContact,
      businessId: businessId,
      branchId: branchId,
      role: role,
    );
    final pin = await _issuePin(
      userId: account.id,
      // apihub's own record of the number wins: it is where the login OTP is
      // sent, and it may be normalised differently from what was typed here.
      phoneNumber: account.phone ?? trimmedContact,
      businessId: businessId,
      branchId: branchId,
      ownerName: name,
    );
    await _verifyTenant(userId: account.id, businessId: businessId);

    return HrInvite(
      userId: account.id,
      tenantId: tenantId,
      pin: pin,
      phoneNumber: account.phone ?? trimmedContact,
      role: role,
    );
  }

  Future<_Account> _resolveAccount(String contact) async {
    final response = await _post(
      '/v2/api/user',
      HrInviteWire.accountBody(contact: contact),
      HrInviteStep.resolveAccount,
      'Could not find or create a Flipper account for $contact.',
    );

    final decoded = _decode(response, HrInviteStep.resolveAccount);
    final id = HrInviteWire.accountIdOf(decoded);
    if (id == null) {
      throw HrInviteException(
        'Flipper answered without an account id for $contact. '
        '${_trim(response.body)}',
        step: HrInviteStep.resolveAccount,
      );
    }
    return _Account(id, HrInviteWire.accountPhoneOf(decoded));
  }

  Future<String> _grantMembership({
    required String userId,
    required String name,
    required String contact,
    required String businessId,
    required String branchId,
    required HrRole role,
  }) async {
    try {
      final data = await _client.rpc(
        'create_agent',
        params: HrInviteWire.membershipParams(
          userId: userId,
          name: name,
          contact: contact,
          businessId: businessId,
          branchId: branchId,
          role: role,
        ),
      );
      final tenantId = HrInviteWire.tenantIdOf(data);
      if (tenantId == null) {
        throw HrInviteException(
          'The membership was created but Flipper did not return its id.',
          step: HrInviteStep.grantMembership,
        );
      }
      return tenantId;
    } on HrInviteException {
      rethrow;
    } on PostgrestException catch (e) {
      throw HrInviteException(
        _membershipMessage(e, businessId: businessId, branchId: branchId),
        step: HrInviteStep.grantMembership,
        cause: e,
      );
    } catch (e) {
      throw HrInviteException(
        'Could not give $name access to this business: $e',
        step: HrInviteStep.grantMembership,
        cause: e,
      );
    }
  }

  Future<String> _issuePin({
    required String userId,
    required String phoneNumber,
    required String businessId,
    required String branchId,
    required String ownerName,
  }) async {
    final response = await _post(
      '/v2/api/pin',
      HrInviteWire.pinBody(
        userId: userId,
        phoneNumber: phoneNumber,
        businessId: businessId,
        branchId: branchId,
        ownerName: ownerName,
      ),
      HrInviteStep.issuePin,
      'Could not create a sign-in PIN for $ownerName.',
    );

    final pin = HrInviteWire.pinOf(_decode(response, HrInviteStep.issuePin));
    if (pin == null) {
      throw HrInviteException(
        'The PIN was requested but Flipper did not return one. '
        '${_trim(response.body)}',
        step: HrInviteStep.issuePin,
      );
    }
    return pin;
  }

  /// The account can already exist with no tenant for *this* business, in which
  /// case sign-in succeeds and then resolves to nothing. Catching it here means
  /// the person inviting hears about it now rather than the invitee hearing
  /// about it tomorrow.
  Future<void> _verifyTenant({
    required String userId,
    required String businessId,
  }) async {
    try {
      final row = await _client
          .from('tenants')
          .select('id')
          .eq('user_id', userId)
          .eq('business_id', businessId)
          .maybeSingle();
      if (row == null) {
        throw HrInviteException(
          'The account was created but has no membership for this business, so '
          'signing in would land nowhere. Try inviting this person again.',
          step: HrInviteStep.verify,
        );
      }
    } on HrInviteException {
      rethrow;
    } catch (e) {
      throw HrInviteException(
        'Could not confirm the new membership: $e',
        step: HrInviteStep.verify,
        cause: e,
      );
    }
  }

  Future<http.Response> _post(
    String path,
    Map<String, dynamic> body,
    HrInviteStep step,
    String friendly,
  ) async {
    final http.Response response;
    try {
      response = await _http
          .post(
            Uri.parse('$_apihub$path'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException catch (e) {
      throw HrInviteException(
        '$friendly Flipper did not answer in time — check the connection and '
        'try again.',
        step: step,
        cause: e,
      );
    } catch (e) {
      throw HrInviteException('$friendly $e', step: step, cause: e);
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw HrInviteException(
        '$friendly [${response.statusCode}] ${_trim(response.body)}',
        step: step,
      );
    }
    return response;
  }

  Object? _decode(http.Response response, HrInviteStep step) {
    if (response.body.trim().isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw HrInviteException(
        'Flipper answered with something that is not JSON: '
        '${_trim(response.body)}',
        step: step,
        cause: e,
      );
    }
  }

  /// Bodies from an error page can be a whole HTML document; a line of it is
  /// enough to recognise, and the rest only buries the message.
  static String _trim(String body) {
    final one = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (one.isEmpty) return '(empty response)';
    return one.length <= 160 ? one : '${one.substring(0, 160)}…';
  }

  static String _membershipMessage(
    PostgrestException e, {
    required String businessId,
    required String branchId,
  }) {
    final detail = e.message.isEmpty ? 'Supabase rejected the request.' : e.message;
    // PGRST202 means the function signature on the server is not the one this
    // client calls — i.e. the create_agent migration has not been applied here.
    if (e.code == 'PGRST202') {
      return 'This Supabase project is missing the current create_agent '
          'function. Apply supabase/migrations/'
          '20260518120000_agent_allow_business_login.sql and try again. $detail';
    }
    return '$detail (business $businessId, branch $branchId)';
  }
}

class _Account {
  const _Account(this.id, this.phone);
  final String id;
  final String? phone;
}
