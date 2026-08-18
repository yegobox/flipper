import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Answers "why was I denied?" for an RLS rejection.
///
/// A 42501 has two very different causes that look identical from the client:
/// the policy predicate genuinely excludes the row, or the request never carried
/// the user's JWT at all (an `anon` request reads empty and writes 403). This
/// reports both sides at once — the claims the browser is sending, and what
/// `public.hr_whoami()` resolves for them server-side.
///
/// Identifiers are masked before display, so the report can be pasted into a
/// ticket or a chat without carrying a phone number or an email address with it.

/// Decodes a JWT payload **without verifying it**. Diagnostics only: this says
/// what the browser is sending, never whether it is trustworthy.
Map<String, dynamic> decodeJwtClaims(String token) {
  final parts = token.split('.');
  if (parts.length < 2) return const {};
  try {
    var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
    // base64url in a JWT drops the padding; base64.decode requires it.
    final remainder = payload.length % 4;
    if (remainder != 0) payload = payload.padRight(payload.length + (4 - remainder), '=');
    final decoded = jsonDecode(utf8.decode(base64.decode(payload)));
    return decoded is Map<String, dynamic> ? decoded : const {};
  } catch (_) {
    // A malformed token is itself a finding; report it as no claims.
    return const {};
  }
}

/// `absent`, or `present (…4874)` — enough to confirm a claim carries the right
/// number without reproducing it.
String maskIdentifier(Object? value) {
  final raw = value?.toString().trim() ?? '';
  if (raw.isEmpty) return 'absent';

  if (raw.contains('@')) {
    final local = raw.split('@').first;
    final domain = raw.substring(raw.indexOf('@'));
    final tail = local.length <= 4 ? local : local.substring(local.length - 4);
    return 'present (…$tail$domain)';
  }

  final tail = raw.length <= 4 ? raw : raw.substring(raw.length - 4);
  return 'present (…$tail)';
}

/// Ids are shown truncated: enough to compare against a business id you already
/// have, not enough to be a copy of someone's identity.
String shortenId(Object? value) {
  final raw = value?.toString().trim() ?? '';
  if (raw.isEmpty) return '—';
  return raw.length <= 8 ? raw : '${raw.substring(0, 8)}…';
}

/// What the browser is sending, masked.
Map<String, String> describeSessionClaims(Map<String, dynamic> claims) => {
  'role': claims['role']?.toString() ?? 'MISSING',
  'sub': shortenId(claims['sub']),
  'phone': maskIdentifier(claims['phone']),
  'email': maskIdentifier(claims['email']),
};

class AccessReport {
  const AccessReport({
    required this.hasSession,
    required this.claims,
    this.whoami,
    this.error,
  });

  /// False means the client never established a Supabase session — every request
  /// goes out as `anon`, and no policy scoped `to authenticated` can pass.
  final bool hasSession;
  final Map<String, String> claims;

  /// `public.hr_whoami()` as the server sees this caller. Null when the call
  /// failed — see [error].
  final Map<String, dynamic>? whoami;
  final String? error;

  /// The two lists that decide every hr_employees policy.
  List<String> get identityKeys => _stringsAt('identity_keys');
  List<String> get businessIds => _stringsAt('business_ids');

  List<String> _stringsAt(String key) {
    final value = whoami?[key];
    if (value is! List) return const [];
    return [for (final v in value) v.toString()];
  }

  /// Plain text for pasting into a ticket. Contains no token and no unmasked
  /// phone or email.
  String toReport() {
    final lines = <String>[
      'session: ${hasSession ? 'present' : 'MISSING — requests are anonymous'}',
      for (final entry in claims.entries) '${entry.key}: ${entry.value}',
      'server identity_keys: ${identityKeys.isEmpty ? 'NONE' : identityKeys.join(', ')}',
      'server business_ids: ${businessIds.isEmpty ? 'NONE' : businessIds.join(', ')}',
    ];
    if (error != null) lines.add('hr_whoami() failed: $error');
    lines.add(_verdict());
    return lines.join('\n');
  }

  String _verdict() {
    if (!hasSession || claims['role'] != 'authenticated') {
      return 'Verdict: the request is not authenticated, so no policy can pass. '
          'Sign in again; if this persists the Supabase session is not reaching '
          'PostgREST.';
    }
    if (error != null) {
      return 'Verdict: hr_whoami() is missing or not executable — apply '
          'migration 0002.';
    }
    if (identityKeys.isEmpty) {
      return 'Verdict: the server cannot tie this session to a public.users '
          'row. Check the phone on that row against the phone claim above.';
    }
    if (businessIds.isEmpty) {
      // Two ways to hold a business now (migration 0006), so name both rather
      // than sending someone to check only half of it.
      return 'Verdict: identity resolves but reaches no business — you neither '
          'own one nor hold a live HR/admin grant. Check businesses.user_id and '
          'public.accesses against the identity keys above; '
          'hr_whoami_access() reports both halves.';
    }
    return 'Verdict: identity and business both resolve. If a write still '
        'fails, the policies on hr_employees are not the ones from migration '
        '0002 — check pg_policies.with_check.';
  }
}

class AccessDiagnostics {
  const AccessDiagnostics(this._client);

  final SupabaseClient _client;

  Future<AccessReport> load() async {
    final session = _client.auth.currentSession;
    final claims = session == null
        ? const <String, dynamic>{}
        : decodeJwtClaims(session.accessToken);

    Map<String, dynamic>? whoami;
    String? error;
    try {
      final raw = await _client.rpc('hr_whoami');
      if (raw is Map) whoami = Map<String, dynamic>.from(raw);
    } catch (e) {
      error = e.toString();
    }

    return AccessReport(
      hasSession: session != null,
      claims: describeSessionClaims(claims),
      whoami: whoami,
      error: error,
    );
  }
}

final accessDiagnosticsProvider = Provider<AccessDiagnostics>((ref) {
  return AccessDiagnostics(Supabase.instance.client);
});
