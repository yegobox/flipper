/// Whether a tenant type string may collect POS payment (Owner / Admin / Manager).
///
/// Aligns with Bar Mode’s manager check: type contains owner, admin, or manager.
/// Cashiers, Agents, Drivers, and unknown/empty types cannot collect — they
/// must Send to Till.
bool tenantTypeCanCollectPosPayment(String? type) {
  final normalized = type?.toLowerCase() ?? '';
  if (normalized.isEmpty) return false;
  return normalized.contains('admin') ||
      normalized.contains('owner') ||
      normalized.contains('manager');
}

/// Signed-in user owns the active business (`businesses.user_id`).
///
/// Owners are often stored with null/`Agent` [Tenant.type] in Supabase; User
/// Management infers Owner from business ownership instead. Till collection
/// must do the same.
bool userOwnsBusinessForPosPayment({
  required String? userId,
  required String? businessOwnerUserId,
}) {
  final uid = userId?.trim() ?? '';
  final owner = businessOwnerUserId?.trim() ?? '';
  if (uid.isEmpty || owner.isEmpty) return false;
  return uid == owner;
}
