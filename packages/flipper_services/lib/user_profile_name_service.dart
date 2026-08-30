import 'dart:convert';

import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists the `users.name` display name shown on the Admin profile card.
///
/// A direct client UPDATE on `users` usually affects 0 rows under RLS, so the
/// write is attempted in the order the Admin profile card uses:
/// Supabase RPC (login-key check) → flipper-turbo PATCH → flipper-turbo POST.
class UserProfileNameService {
  const UserProfileNameService._();

  /// Expands the supplied login keys into every shape the RPC may accept:
  /// trimmed, de-duplicated, plus a `+`-stripped variant of each phone.
  static List<String> candidateLoginKeys(Iterable<String?> loginKeys) {
    final keys = <String>[];
    void add(String? value) {
      final key = value?.trim();
      if (key == null || key.isEmpty) return;
      if (!keys.contains(key)) keys.add(key);
    }

    for (final key in loginKeys) {
      add(key);
      final trimmed = key?.trim();
      if (trimmed != null && trimmed.startsWith('+')) {
        add(trimmed.substring(1));
      }
    }
    return keys;
  }

  /// Calls `update_user_profile_name` for each candidate key until one sticks.
  /// Returns false (never throws) when the RPC is missing or rejects every key.
  static Future<bool> saveViaRpc({
    required String userId,
    required String name,
    required Iterable<String?> loginKeys,
  }) async {
    for (final key in candidateLoginKeys(loginKeys)) {
      try {
        final result = await Supabase.instance.client.rpc(
          'update_user_profile_name',
          params: {'p_user_id': userId, 'p_name': name, 'p_login_key': key},
        );
        if (result == true) return true;
      } catch (_) {
        // Try next key shape (RPC may not be deployed yet).
      }
    }
    return false;
  }

  /// PATCH `/v2/api/user`. Throws when the server rejects the write.
  static Future<void> saveViaUserPatch({
    required String userId,
    required String name,
  }) async {
    final response = await ProxyService.http.patch(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/user'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'id': userId, 'user_id': userId, 'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Profile update failed (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// POST `/v2/api/user`. Throws when the server rejects the write.
  static Future<void> saveViaUserPost({
    required String loginKey,
    required String name,
  }) async {
    final apiPhone = loginKey.startsWith('+') || loginKey.contains('@')
        ? loginKey
        : '+$loginKey';
    final response = await ProxyService.http.post(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/user'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': apiPhone, 'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Profile update failed (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Best-effort save used by signup: walks RPC → PATCH → POST and swallows
  /// failures so a naming hiccup can never fail an otherwise good signup.
  ///
  /// When the name lands, `user_access` is refreshed so the Ditto document the
  /// app reads after login carries the new name instead of the server default.
  static Future<bool> saveNameBestEffort({
    required String userId,
    required String name,
    required Iterable<String?> loginKeys,
    bool refreshUserAccess = true,
  }) async {
    final trimmedName = name.trim();
    final keys = candidateLoginKeys(loginKeys);
    if (userId.trim().isEmpty || trimmedName.isEmpty || keys.isEmpty) {
      return false;
    }

    var saved = await saveViaRpc(
      userId: userId,
      name: trimmedName,
      loginKeys: keys,
    );

    if (!saved) {
      try {
        await saveViaUserPatch(userId: userId, name: trimmedName);
        saved = true;
      } catch (_) {
        try {
          await saveViaUserPost(loginKey: keys.first, name: trimmedName);
          saved = true;
        } catch (_) {
          saved = false;
        }
      }
    }

    if (saved && refreshUserAccess) {
      try {
        await ProxyService.strategy.sendLoginRequest(
          keys.first,
          ProxyService.http,
          AppSecrets.apihubProd,
          expectedPinUserId: userId,
          refreshUserAccessOnly: true,
        );
      } catch (_) {
        // Best-effort; the next login re-fetches /v2/api/user anyway.
      }
    }

    return saved;
  }
}
