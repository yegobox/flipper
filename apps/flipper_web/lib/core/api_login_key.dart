/// Normalizes the login key sent as `phoneNumber` to POST `/v2/api/user`.
///
/// Matches flipper desktop (`auth_mixin.sendLoginRequest`): E.164 phones get a
/// leading `+`; email / Ditto keys (e.g. `157307@flipper.rw`) are unchanged.
String normalizeApiUserLoginKey(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;
  if (trimmed.contains('@') || trimmed.startsWith('+')) return trimmed;
  return '+$trimmed';
}

/// Ditto/Flipper synthetic login keys (e.g. `157307@flipper.rw`) are not E.164
/// phones and must not be sent to POST `/v2/api/user` when [pins.user_id] is known.
bool isFlipperDittoLoginKey(String raw) {
  final trimmed = raw.trim().toLowerCase();
  return trimmed.endsWith('@flipper.rw');
}
