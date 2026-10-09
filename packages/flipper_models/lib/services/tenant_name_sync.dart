import 'dart:async';
import 'dart:convert';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/tenant_name_patch.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// Brings business/branch names renamed in Supabase into this device, plus
/// the business type (`business_type_id`), email and TIN (`tin_number`), which
/// are server-owned too.
///
/// Names are read from three local copies, none of which refreshes on its own:
/// Brick SQLite (`getBusiness`/`activeBusiness` are `localOnly`), the Ditto
/// `businesses`/`branches` docs (`sendOnly`, so the server never writes them
/// back), and the nested Ditto `user_access` doc (rewritten only at login).
///
/// Only `name` (and, on the Brick business row, `businessTypeId`, `email` and
/// `tinNumber`) is patched,
/// and only when it differs. Whole server rows are never upserted: that could
/// overwrite device-owned fields such as `isDefault`, and `Business.copyWith`
/// drops fields. Every step is best-effort; failures are logged, never thrown.
class TenantNameSync {
  TenantNameSync._();

  static const Duration _catchUpInterval = Duration(seconds: 60);
  static DateTime? _lastCatchUp;
  static String? _lastCatchUpBusinessId;

  /// Applies [name] to business [id]. Returns true if any local copy changed.
  static Future<bool> applyBusinessName(String? id, Object? name) async {
    final newName = usableTenantName(name);
    if (id == null || id.isEmpty || newName == null) return false;

    final brick = await _patchBrickBusiness(id, newName);
    final ditto = await _patchDittoDoc('businesses', id, newName);
    final access = await _patchUserAccess(businessId: id, name: newName);
    return brick || ditto || access;
  }

  /// Applies a server `business_type_id` to business [id]'s Brick row.
  ///
  /// A business created as Personal (2) and switched to Business (1) in
  /// Supabase keeps 2 in its local row forever otherwise: the row is only
  /// written at signup, and the login payload carries no type. Only the Brick
  /// row stores it; the Ditto docs and `user_access` have no type field.
  static Future<bool> applyBusinessType(String? id, Object? rawType) async {
    final typeId = usableBusinessTypeId(rawType);
    if (id == null || id.isEmpty || typeId == null) return false;
    return _patchBrickBusinessRow(id, 'type', (row) {
      if (row.businessTypeId == typeId) return false;
      row.businessTypeId = typeId;
      return true;
    });
  }

  /// Applies a server `email` to business [id]'s Brick row.
  ///
  /// Like the type, the email is written locally only at signup, so one added
  /// in Supabase later never reached the letterhead of quotations and
  /// receipts. A blank server email never clears the local one.
  static Future<bool> applyBusinessEmail(String? id, Object? rawEmail) async {
    final email = usableBusinessEmail(rawEmail);
    if (id == null || id.isEmpty || email == null) return false;
    return _patchBrickBusinessRow(id, 'email', (row) {
      if (row.email == email) return false;
      row.email = email;
      return true;
    });
  }

  /// Applies a server `tin_number` to business [id]'s Brick row. A missing or
  /// zero server TIN never clears the local one.
  static Future<bool> applyBusinessTin(String? id, Object? rawTin) async {
    final tin = usableTinNumber(rawTin);
    if (id == null || id.isEmpty || tin == null) return false;
    return _patchBrickBusinessRow(id, 'TIN', (row) {
      if (row.tinNumber == tin) return false;
      row.tinNumber = tin;
      return true;
    });
  }

  /// Applies a Realtime `businesses` row (name, type, email and TIN). Returns
  /// true if any local copy changed.
  static Future<bool> applyBusinessRow(Map<String, dynamic> record) async {
    final id = record['id']?.toString();
    final name = await applyBusinessName(id, record['name']);
    final type = await applyBusinessType(id, record['business_type_id']);
    final email = await applyBusinessEmail(id, record['email']);
    final tin = await applyBusinessTin(id, record['tin_number']);
    return name || type || email || tin;
  }

  /// Applies [name] to branch [id]. Returns true if any local copy changed.
  static Future<bool> applyBranchName(String? id, Object? name) async {
    final newName = usableTenantName(name);
    if (id == null || id.isEmpty || newName == null) return false;

    final brick = await _patchBrickBranch(id, newName);
    final ditto = await _patchDittoDoc('branches', id, newName);
    final access = await _patchUserAccess(branchId: id, name: newName);
    return brick || ditto || access;
  }

  /// Pulls current names for [businessId] and its branches from Supabase, for
  /// renames made while this device was offline or the app was closed.
  ///
  /// Throttled to once per [_catchUpInterval] per business; pass [force] to
  /// skip the throttle. Returns true if any local copy changed.
  static Future<bool> catchUp({String? businessId, bool force = false}) async {
    final id = businessId ?? ProxyService.box.getBusinessId();
    if (id == null || id.isEmpty) return false;

    final now = DateTime.now();
    if (!force &&
        _lastCatchUpBusinessId == id &&
        _lastCatchUp != null &&
        now.difference(_lastCatchUp!) < _catchUpInterval) {
      return false;
    }
    _lastCatchUp = now;
    _lastCatchUpBusinessId = id;

    try {
      return await applyNames(await fetchNames(businessId: id));
    } catch (e) {
      // Offline or Supabase unavailable: keep cached names, retry next time.
      _lastCatchUp = null;
      talker.warning('TenantNameSync.catchUp skipped: $e');
      return false;
    }
  }

  /// Current names for [businessId] and its branches, straight from
  /// Supabase. Network only: nothing local is read or written, so a caller
  /// that needs a name now (a document letterhead) is never held up by a busy
  /// Ditto store. Throws when offline; callers keep their cached names.
  static Future<TenantNames> fetchNames({required String businessId}) async {
    final client = Supabase.instance.client;
    final (business, branches) = await (
      client
          .from('businesses')
          .select('id, name, business_type_id, email, tin_number')
          .eq('id', businessId)
          .maybeSingle(),
      client.from('branches').select('id, name').eq('business_id', businessId),
    ).wait;

    final branchNames = <String, String>{};
    for (final branch in branches) {
      final id = branch['id']?.toString();
      final name = usableTenantName(branch['name']);
      if (id != null && id.isNotEmpty && name != null) branchNames[id] = name;
    }
    return TenantNames(
      businessId: businessId,
      businessName: usableTenantName(business?['name']),
      businessTypeId: usableBusinessTypeId(business?['business_type_id']),
      businessEmail: usableBusinessEmail(business?['email']),
      tinNumber: usableTinNumber(business?['tin_number']),
      branchNames: branchNames,
    );
  }

  /// Writes [names] into every local copy. Returns true if any changed.
  static Future<bool> applyNames(TenantNames names) async {
    var changed = false;
    if (names.businessName != null) {
      changed =
          await applyBusinessName(names.businessId, names.businessName) ||
          changed;
    }
    if (names.businessTypeId != null) {
      changed =
          await applyBusinessType(names.businessId, names.businessTypeId) ||
          changed;
    }
    if (names.businessEmail != null) {
      changed =
          await applyBusinessEmail(names.businessId, names.businessEmail) ||
          changed;
    }
    if (names.tinNumber != null) {
      changed =
          await applyBusinessTin(names.businessId, names.tinNumber) || changed;
    }
    for (final entry in names.branchNames.entries) {
      changed = await applyBranchName(entry.key, entry.value) || changed;
    }
    return changed;
  }

  static Future<bool> _patchBrickBusiness(String id, String name) async {
    try {
      final repository = Repository();
      final rows = await repository.get<Business>(
        query: Query(where: [Where('id').isExactly(id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final row = rows.firstOrNull;
      if (row == null || row.name == name) return false;
      // In place: copyWith drops Business fields (see setWhatsAppPhoneNumberId).
      row.name = name;
      await repository.upsert<Business>(
        row,
        policy: OfflineFirstUpsertPolicy.localOnly,
        skipDittoSync: true,
      );
      return true;
    } catch (e) {
      talker.warning('TenantNameSync: Brick business $id not patched: $e');
      return false;
    }
  }

  /// Runs [apply] on business [id]'s Brick row and saves it if [apply]
  /// reports a change. [field] names the patch in the log.
  static Future<bool> _patchBrickBusinessRow(
    String id,
    String field,
    bool Function(Business row) apply,
  ) async {
    try {
      final repository = Repository();
      final rows = await repository.get<Business>(
        query: Query(where: [Where('id').isExactly(id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final row = rows.firstOrNull;
      if (row == null || !apply(row)) return false;
      // In place and localOnly, like the name: never push the row back up.
      await repository.upsert<Business>(
        row,
        policy: OfflineFirstUpsertPolicy.localOnly,
        skipDittoSync: true,
      );
      return true;
    } catch (e) {
      talker.warning(
        'TenantNameSync: Brick business $id $field not patched: $e',
      );
      return false;
    }
  }

  static Future<bool> _patchBrickBranch(String id, String name) async {
    try {
      final repository = Repository();
      final rows = await repository.get<Branch>(
        query: Query(where: [Where('id').isExactly(id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final row = rows.firstOrNull;
      if (row == null || row.name == name) return false;
      row.name = name;
      await repository.upsert<Branch>(
        row,
        policy: OfflineFirstUpsertPolicy.localOnly,
        skipDittoSync: true,
      );
      return true;
    } catch (e) {
      talker.warning('TenantNameSync: Brick branch $id not patched: $e');
      return false;
    }
  }

  /// Sets `name` on the Ditto doc in [collection] whose `id` is [id]. Missing
  /// docs are left alone (readers fall back to Brick, patched above).
  static Future<bool> _patchDittoDoc(
    String collection,
    String id,
    String name,
  ) async {
    final ditto = ProxyService.ditto;
    if (!ditto.isReady()) return false;
    try {
      final store = ditto.dittoInstance!.store;
      final result = await store.execute(
        'SELECT * FROM $collection WHERE id = :id',
        arguments: {'id': id},
      );
      final stale = result.items.any((item) => item.value['name'] != name);
      if (!stale) return false;
      await store.execute(
        'UPDATE $collection SET name = :name WHERE id = :id',
        arguments: {'id': id, 'name': name},
      );
      return true;
    } catch (e) {
      talker.warning('TenantNameSync: Ditto $collection/$id not patched: $e');
      return false;
    }
  }

  static Future<bool> _patchUserAccess({
    String? businessId,
    String? branchId,
    required String name,
  }) async {
    final ditto = ProxyService.ditto;
    final userId = ProxyService.box.getUserId();
    if (userId == null || userId.isEmpty || !ditto.isReady()) return false;
    try {
      final current = await ditto.getUserAccess(userId);
      if (current == null) return false;
      // Deep copy: the doc's nested lists/maps come straight from Ditto.
      final doc = Map<String, dynamic>.from(
        jsonDecode(jsonEncode(current)) as Map,
      );
      final changed = patchUserAccessNames(
        doc,
        businessId: businessId,
        branchId: branchId,
        name: name,
      );
      if (!changed) return false;
      doc.remove('_id');
      doc['id'] ??= userId;
      return await ditto.saveUserAccess(doc, localOnly: true);
    } catch (e) {
      talker.warning('TenantNameSync: user_access not patched: $e');
      return false;
    }
  }
}

/// Business and branch names, and the business type, as Supabase has them,
/// from [TenantNameSync.fetchNames].
class TenantNames {
  const TenantNames({
    required this.businessId,
    required this.businessName,
    this.businessTypeId,
    this.businessEmail,
    this.tinNumber,
    required this.branchNames,
  });

  final String businessId;
  final String? businessName;

  /// `business_type_id`, or null if Supabase had no usable value.
  final int? businessTypeId;

  /// `email`, or null if Supabase had no usable address.
  final String? businessEmail;

  /// `tin_number`, or null if Supabase had no usable TIN.
  final int? tinNumber;

  /// Branch id → name.
  final Map<String, String> branchNames;
}
