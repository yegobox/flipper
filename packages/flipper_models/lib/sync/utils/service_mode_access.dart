import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/sync/utils/staff_roster_cache.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// Who may run Bar Mode and Hotel Mode in a business.
///
/// Bar and Hotel are device surfaces, and their lock screens sign in *other*
/// staff on a shared register, whose access rows are not on this device. So
/// the grants for the whole business are read in one go and kept offline,
/// next to the staff roster.
///
/// Rollout rule (grandfathering): a mode nobody in the business has been
/// granted yet stays open to every staff member, exactly as before these
/// modules existed. The first grant restricts it to the granted staff, the
/// business owner and Admin-type users.
class ServiceModeGrants {
  const ServiceModeGrants({
    this.admins = const {},
    this.byFeature = const {},
    this.nextExpiry,
  });

  /// Owner plus every user whose access rows carry the Admin user type.
  final Set<String> admins;

  /// Active, unexpired grants per mode ([AppFeature.BarMode] /
  /// [AppFeature.HotelMode]), as user ids.
  final Map<String, Set<String>> byFeature;

  /// When the first row counted here expires, so the holder can re-read the
  /// grants then. Null when none of them expires.
  final DateTime? nextExpiry;

  /// Whether [feature] has been granted to anyone, i.e. is no longer open to
  /// all staff.
  bool isRestricted(String feature) => byFeature[feature]?.isNotEmpty ?? false;

  /// Whether [userId] may run [feature]. [isAdminOrOwner] lets a caller add
  /// what it knows locally (e.g. the tenant's own type) to [admins].
  bool allows(String feature, String? userId, {bool isAdminOrOwner = false}) =>
      canUseServiceMode(
        userId: userId,
        isAdminOrOwner:
            isAdminOrOwner || (userId != null && admins.contains(userId)),
        grantedUserIds: byFeature[feature] ?? const {},
      );
}

/// Bar Mode and Hotel Mode, the modules [ServiceModeGrants] covers.
const List<String> serviceModeFeatures = [
  AppFeature.BarMode,
  AppFeature.HotelMode,
];

/// Whether [userId] may run a service mode whose grants are [grantedUserIds].
bool canUseServiceMode({
  required String? userId,
  required bool isAdminOrOwner,
  required Set<String> grantedUserIds,
}) =>
    isAdminOrOwner ||
    // Grandfathered: nobody holds the grant yet, so the mode is open.
    grantedUserIds.isEmpty ||
    (userId != null && grantedUserIds.contains(userId));

/// [staff] who may sign in to [feature]. [isAdminOrOwner] decides from the
/// tenant's own type, so an admin is never hidden from the lock screen.
List<Tenant> staffForServiceMode(
  List<Tenant> staff,
  ServiceModeGrants grants,
  String feature, {
  required bool Function(Tenant tenant) isAdminOrOwner,
}) {
  if (!grants.isRestricted(feature)) return staff;
  return staff
      .where(
        (t) => grants.allows(
          feature,
          t.userId?.trim(),
          isAdminOrOwner: isAdminOrOwner(t),
        ),
      )
      .toList();
}

/// Builds [ServiceModeGrants] from `accesses` rows and the owner's user id.
ServiceModeGrants serviceModeGrantsFromRows(
  Iterable<dynamic> rows, {
  String? ownerUserId,
  required DateTime now,
}) {
  final admins = <String>{};
  final byFeature = <String, Set<String>>{};
  DateTime? nextExpiry;
  final owner = ownerUserId?.trim();
  if (owner != null && owner.isNotEmpty) admins.add(owner);

  for (final raw in rows) {
    if (raw is! Map) continue;
    final userId = raw['user_id']?.toString().trim();
    if (userId == null || userId.isEmpty) continue;
    if ((raw['status']?.toString() ?? 'active') != 'active') continue;
    final expiresAt = DateTime.tryParse(raw['expires_at']?.toString() ?? '');
    if (expiresAt != null && !expiresAt.isAfter(now)) continue;

    final isAdmin =
        raw['user_type']?.toString().toLowerCase() == AccessLevel.ADMIN;
    final feature = raw['feature_name']?.toString();
    final isGrant = serviceModeFeatures.contains(feature);
    if (isAdmin) admins.add(userId);
    if (isGrant) byFeature.putIfAbsent(feature!, () => <String>{}).add(userId);
    if ((isAdmin || isGrant) &&
        expiresAt != null &&
        (nextExpiry == null || expiresAt.isBefore(nextExpiry))) {
      nextExpiry = expiresAt;
    }
  }
  return ServiceModeGrants(
    admins: admins,
    byFeature: byFeature,
    nextExpiry: nextExpiry,
  );
}

/// Box key for the offline copy. Shares the roster prefix, so it is already
/// allowed by LocalStorage and never mirrored to Ditto.
String serviceModeGrantsCacheKey(String businessId) =>
    '${staffRosterCacheKeyPrefix}grants_$businessId';

const int _grantsCacheVersion = 1;

/// The cache keeps the raw rows, so expiry is checked again when it is read.
String encodeServiceModeGrantRows(
  List<Map<String, dynamic>> rows, {
  String? ownerUserId,
}) =>
    jsonEncode({'v': _grantsCacheVersion, 'owner': ownerUserId, 'rows': rows});

/// Restores [encodeServiceModeGrantRows]; null when missing or unreadable.
ServiceModeGrants? decodeServiceModeGrants(
  String? raw, {
  required DateTime now,
}) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map || decoded['v'] != _grantsCacheVersion) return null;
    final rows = decoded['rows'];
    if (rows is! List) return null;
    return serviceModeGrantsFromRows(
      rows,
      ownerUserId: decoded['owner']?.toString(),
      now: now,
    );
  } catch (_) {
    return null;
  }
}

/// The last grants [fetchServiceModeGrants] saved for [businessId], or null.
/// Synchronous, for a screen that cannot wait on the network to draw.
ServiceModeGrants? cachedServiceModeGrants({
  required String businessId,
  required LocalStorage box,
  DateTime Function() now = DateTime.now,
}) => decodeServiceModeGrants(
  box.readString(key: serviceModeGrantsCacheKey(businessId)),
  now: now(),
);

/// The rows and owner [fetchServiceModeGrants] needs for [businessId].
typedef ServiceModeGrantRowsLoader =
    Future<({List<Map<String, dynamic>> rows, String? ownerUserId})> Function(
      String businessId,
    );

/// Rows per `accesses` page; PostgREST caps an unranged read at 1,000.
@visibleForTesting
const int serviceModeGrantsPageSize = 1000;

/// Every page of [fetchPage] (offset, limit), until a short page.
@visibleForTesting
Future<List<Map<String, dynamic>>> readAllServiceModeGrantPages(
  Future<List<Map<String, dynamic>>> Function(int from, int to) fetchPage, {
  int pageSize = serviceModeGrantsPageSize,
}) async {
  final rows = <Map<String, dynamic>>[];
  for (var from = 0; ; from += pageSize) {
    final page = await fetchPage(from, from + pageSize - 1);
    rows.addAll(page);
    if (page.length < pageSize) return rows;
  }
}

Future<({List<Map<String, dynamic>> rows, String? ownerUserId})>
loadServiceModeGrantRows(String businessId) async {
  final client = Supabase.instance.client;
  final features = serviceModeFeatures.map((f) => '"$f"').join(',');
  // The owner only adds an admin: a failed lookup must not cost the grants,
  // which would leave both modes open.
  final ownerQuery = client
      .from('businesses')
      .select('user_id')
      .eq('id', businessId)
      .maybeSingle()
      .then<String?>((row) => row?['user_id']?.toString())
      .catchError((Object e) {
        debugPrint('loadServiceModeGrantRows: owner lookup failed: $e');
        return null;
      });
  final rows = await readAllServiceModeGrantPages(
    (from, to) => client
        .from('accesses')
        .select('user_id, feature_name, user_type, status, expires_at')
        .eq('business_id', businessId)
        .or('feature_name.in.($features),user_type.ilike.admin')
        .order('id')
        .range(from, to),
  );
  return (rows: rows, ownerUserId: await ownerQuery);
}

/// Bar/Hotel grants for [businessId]: Supabase first, the offline copy when
/// that fails or is slower than [timeout].
///
/// With neither, every mode is treated as not granted yet (open), so a desk
/// that has never been online keeps working as it did before these grants
/// existed, rather than locking everyone out.
Future<ServiceModeGrants> fetchServiceModeGrants({
  required String businessId,
  required LocalStorage box,
  ServiceModeGrantRowsLoader load = loadServiceModeGrantRows,
  Duration timeout = const Duration(seconds: 10),
  DateTime Function() now = DateTime.now,
}) async {
  final key = serviceModeGrantsCacheKey(businessId);
  try {
    final fetched = await load(businessId).timeout(timeout);
    await box.writeString(
      key: key,
      value: encodeServiceModeGrantRows(
        fetched.rows,
        ownerUserId: fetched.ownerUserId,
      ),
    );
    return serviceModeGrantsFromRows(
      fetched.rows,
      ownerUserId: fetched.ownerUserId,
      now: now(),
    );
  } catch (e) {
    debugPrint('fetchServiceModeGrants: $e — using cached grants');
    return cachedServiceModeGrants(
          businessId: businessId,
          box: box,
          now: now,
        ) ??
        const ServiceModeGrants();
  }
}
