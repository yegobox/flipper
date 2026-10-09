import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists canonical login identity across page reloads.
///
/// Supabase auth sessions survive reloads, but [sessionApiUserIdProvider] and
/// [sessionLoginKeyProvider] are in-memory only. Without persistence, reloads
/// fall back to the Supabase auth UUID / `@flipper.rw` email and POST
/// `/v2/api/user` returns the wrong user with `businesses: []`.
abstract final class SessionPersistence {
  static const _apiUserIdKey = 'flipper_web_api_user_id';
  static const _loginKeyKey = 'flipper_web_login_key';

  static Future<void> save({String? apiUserId, String? loginKey}) async {
    final prefs = await openPreferencesOrNull();
    if (prefs == null) return;
    final id = apiUserId?.trim();
    if (id != null && id.isNotEmpty) {
      await prefs.setString(_apiUserIdKey, id);
    }
    final key = loginKey?.trim();
    if (key != null && key.isNotEmpty) {
      await prefs.setString(_loginKeyKey, key);
    }
  }

  static Future<String?> readApiUserId() async {
    final prefs = await openPreferencesOrNull();
    final value = prefs?.getString(_apiUserIdKey)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static Future<String?> readLoginKey() async {
    final prefs = await openPreferencesOrNull();
    final value = prefs?.getString(_loginKeyKey)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static Future<void> clear() async {
    final prefs = await openPreferencesOrNull();
    if (prefs == null) return;
    await prefs.remove(_apiUserIdKey);
    await prefs.remove(_loginKeyKey);
  }
}

/// [SharedPreferences.getInstance], or null when the store cannot load.
///
/// On Windows/Linux the plugin decodes a JSON file without a try/catch; a till
/// that lost power mid-write leaves it NUL-filled and every call throws
/// `FormatException`. These keys are caches, so callers treat a broken store
/// as an empty one and fall back to the user profile.
Future<SharedPreferences?> openPreferencesOrNull() async {
  try {
    return await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint('[prefs] unavailable, continuing without: $e');
    return null;
  }
}
