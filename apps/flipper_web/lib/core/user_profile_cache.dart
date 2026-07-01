import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter_riverpod/legacy.dart';

/// In-memory cache for the authenticated user's profile.
/// Populated immediately after login so business selection doesn't
/// depend on Ditto being available.
final userProfileCacheProvider = StateProvider<UserProfile?>((ref) => null);

/// Login key returned by verify-otp / verify-totp (`phoneNumber` field).
/// Supabase sessions are often email-based, so [Session.user.phone] is empty.
final sessionLoginKeyProvider = StateProvider<String?>((ref) => null);

/// Canonical `public.users.id` from `pins.user_id` (verify-otp / verify-totp).
/// Used with `get_user_with_nested_data` — same as desktop [sendLoginRequest].
final sessionApiUserIdProvider = StateProvider<String?>((ref) => null);

/// Raw POST `/v2/api/user` payload for Ditto `user_access` replay after init.
final userProfileApiPayloadCacheProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
