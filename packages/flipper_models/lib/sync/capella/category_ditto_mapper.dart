import 'package:supabase_models/brick/models/all_models.dart';

/// Parses a Ditto `categories` row into [Category].
/// Handles `_id` vs `id` and common bool/date encodings from Ditto.
Category categoryFromDittoMap(Map<String, dynamic> data) {
  DateTime? parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  bool? parseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  final rawId = data['id']?.toString() ?? data['_id']?.toString();

  return Category(
    id: (rawId != null && rawId.isNotEmpty) ? rawId : null,
    name: data['name'] as String?,
    branchId: data['branchId'] as String?,
    active: parseBool(data['active']),
    focused: parseBool(data['focused']) ?? false,
    deletedAt: parseDt(data['deletedAt']),
    lastTouched: parseDt(data['lastTouched']),
  );
}
