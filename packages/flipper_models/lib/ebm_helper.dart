import 'package:flipper_services/proxy.dart';

/// Resolve the effective TIN number for the current context.
/// Priority:
/// 1. Ebm.tinNumber for the current branch (if available)
/// 2. Provided Business.tinNumber (if provided)
/// 3. ProxyService.box.tin() (local fallback)
/// `business` may be either a `Business` model or a lightweight `IBusiness`/map
/// coming from other app packages; we accept `dynamic` and read `tinNumber`.
Future<int?> effectiveTin({dynamic business, String? branchId}) async {
  try {
    final resolvedBranchId = branchId ?? ProxyService.box.getBranchId();
    if (resolvedBranchId != null) {
      final ebm = await ProxyService.strategy.ebm(branchId: resolvedBranchId);
      if (ebm?.tinNumber != null) return ebm!.tinNumber;
    }
  } catch (_) {
    // ignore errors and fall back to other sources
  }

  // Helper: try several sensible ways to extract a TIN from a dynamic input.
  int? extractTin(dynamic b) {
    if (b == null) return null;

    // If the value itself is an int (caller accidentally passed tin directly)
    if (b is int) return b;

    // Map-like structures (JSON payloads or loose maps)
    try {
      if (b is Map) {
        final v = b['tinNumber'] ?? b['tin'] ?? b['tin_number'];
        if (v is int) return v;
        if (v is String) return int.tryParse(v);
      }
    } catch (_) {}

    // Try dynamic property access (works for Business, IBusiness, or other objects
    // that expose a `tinNumber`/`tin` field/getter). Accessing a missing
    // property on `dynamic` throws NoSuchMethodError — guard with try/catch.
    try {
      final dyn = b as dynamic;
      var val = dyn.tinNumber;
      if (val == null) val = dyn.tin;
      if (val is int) return val;
      if (val is String) return int.tryParse(val);
    } catch (_) {}

    return null;
  }

  final bizTin = extractTin(business);
  if (bizTin != null) return bizTin;

  return ProxyService.box.tin();
}
