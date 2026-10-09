/// Pure helpers for [TenantNameSync]; no Flutter, Ditto or Brick imports so
/// they stay unit-testable without the app's service graph.
library;

/// Normalises a name received from Supabase. Returns null for values that
/// must never overwrite a local name (null, empty, whitespace-only).
String? usableTenantName(Object? raw) {
  if (raw == null) return null;
  final name = raw.toString().trim();
  return name.isEmpty ? null : name;
}

/// Rewrites the `name` of one business ([businessId]) or one branch
/// ([branchId]) inside a Ditto `user_access` document
/// (`businesses[].branches[]`), in place.
///
/// Returns true only if a name actually changed, so callers can skip the
/// write (and the Ditto sync it triggers) when the doc is already current.
bool patchUserAccessNames(
  Map<String, dynamic> doc, {
  String? businessId,
  String? branchId,
  required String? name,
}) {
  final newName = usableTenantName(name);
  if (newName == null) return false;
  if (businessId == null && branchId == null) return false;

  final businesses = doc['businesses'];
  if (businesses is! List) return false;

  var changed = false;
  for (final business in businesses) {
    if (business is! Map) continue;
    if (businessId != null &&
        business['id']?.toString() == businessId &&
        business['name'] != newName) {
      business['name'] = newName;
      changed = true;
    }
    if (branchId == null) continue;
    final branches = business['branches'];
    if (branches is! List) continue;
    for (final branch in branches) {
      if (branch is! Map) continue;
      if (branch['id']?.toString() == branchId && branch['name'] != newName) {
        branch['name'] = newName;
        changed = true;
      }
    }
  }
  return changed;
}

/// Normalises `businesses.email` received from Supabase. Returns null for
/// values that must never overwrite the local email: missing, blank, or not
/// an address at all.
String? usableBusinessEmail(Object? raw) {
  final email = raw?.toString().trim() ?? '';
  return email.contains('@') ? email : null;
}

/// Normalises `businesses.business_type_id` received from Supabase (an int,
/// or its string form). Returns null for anything that must never overwrite
/// the local value: missing, unparseable, zero or negative.
int? usableBusinessTypeId(Object? raw) {
  final id = raw is int ? raw : int.tryParse(raw?.toString().trim() ?? '');
  return id != null && id > 0 ? id : null;
}
