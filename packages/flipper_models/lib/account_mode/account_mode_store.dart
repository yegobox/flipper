import 'dart:async';

import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_client.dart';
import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:supabase_models/brick/repository/storage.dart';

/// What this device knows about the active business's [AccountMode], and the
/// one place that changes it.
///
/// Callers that must not wait on the network (routing, the login waiver, the
/// first frame) use [localMode]. Only the paywall paths call [resolve], which
/// may ask the connector once per business per session when nothing local
/// knows yet — a business account on its way to the paywall pays that, an
/// account with a working plan never does.
class AccountModeStore {
  AccountModeStore({
    required LocalStorage Function() box,
    required Future<Map<String, dynamic>?> Function(String businessId)
    readDittoDoc,
    required AccountModeClient client,
  }) : _box = box,
       _readDittoDoc = readDittoDoc,
       _client = client;

  factory AccountModeStore.live() => AccountModeStore(
    box: () => getIt<LocalStorage>(),
    readDittoDoc: _readLiveDittoDoc,
    client: AccountModeClient(
      baseUrl: () async => resolveDataConnectorBaseUrl(
        dataConnectorUrl: await resolveEbmDataConnectorUrl(),
      ),
    ),
  );

  static AccountModeStore? _instance;
  static AccountModeStore get instance => _instance ??= AccountModeStore.live();

  @visibleForTesting
  static set instance(AccountModeStore? store) => _instance = store;

  final LocalStorage Function() _box;
  final Future<Map<String, dynamic>?> Function(String businessId) _readDittoDoc;
  final AccountModeClient _client;

  /// Businesses already asked over the network this session, answered or not.
  final Set<String> _asked = {};

  static Future<Map<String, dynamic>?> _readLiveDittoDoc(
    String businessId,
  ) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return null;
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM $kAccountModesCollection WHERE _id = :id',
        arguments: {'id': businessId},
      );
      if (result.items.isEmpty) return null;
      return Map<String, dynamic>.from(result.items.first.value);
    } catch (_) {
      return null;
    }
  }

  String? activeBusinessId() {
    try {
      final id = _box().getBusinessId()?.trim();
      return id == null || id.isEmpty ? null : id;
    } catch (_) {
      return null;
    }
  }

  String? _read(String key) {
    try {
      return _box().readString(key: key);
    } catch (_) {
      return null;
    }
  }

  /// The cached mode only: synchronous, for a first frame.
  AccountMode? cachedMode({String? businessId}) {
    final pending = _read(kPendingAccountModeKey);
    final id = businessId ?? activeBusinessId();
    return localAccountMode(
      dittoDoc: null,
      pending: pending,
      cached: id == null ? null : cachedEntry(id),
    );
  }

  /// The cached entry (mode and server `changedAt`) of [businessId].
  CachedAccountMode? cachedEntry(String businessId) =>
      cachedAccountModeEntry(_read(kAccountModeCacheKey), businessId);

  /// What this device knows without the network; `null` when nothing does.
  Future<AccountMode?> localMode({String? businessId}) async {
    final id = businessId ?? activeBusinessId();
    if (id == null) return null;
    final doc = await _readDittoDoc(id);
    final mode = localAccountMode(
      dittoDoc: doc,
      pending: _read(kPendingAccountModeKey),
      cached: cachedEntry(id),
    );
    if (doc != null) {
      unawaited(
        remember(
          id,
          parseAccountMode(doc['mode']),
          changedAt: accountModeDocChangedAt(doc),
        ),
      );
    }
    return mode;
  }

  Future<bool> isPersonalLocal() async =>
      (await localMode())?.isPersonal ?? false;

  /// [localMode], else the connector (at most once per business per
  /// session, bounded by [timeout]), else business.
  Future<AccountMode> resolve({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final id = activeBusinessId();
    if (id == null) return AccountMode.business;
    final local = await localMode(businessId: id);
    if (local != null) return local;
    if (!_asked.add(id)) return AccountMode.business;
    try {
      final result = await _client.read(timeout: timeout);
      await remember(id, result.mode, changedAt: result.changedAt);
      return result.mode;
    } catch (e) {
      talker.warning('Account mode lookup failed (treating as business): $e');
      return AccountMode.business;
    }
  }

  /// Caches [mode]. Never replaces a newer entry with an older one: a stale
  /// Ditto doc read right after a switch must not undo it.
  Future<void> remember(
    String businessId,
    AccountMode mode, {
    DateTime? changedAt,
  }) async {
    try {
      final box = _box();
      final raw = box.readString(key: kAccountModeCacheKey);
      final current = cachedAccountModeEntry(raw, businessId);
      final currentAt = current?.changedAt;
      if (currentAt != null &&
          (changedAt == null || changedAt.isBefore(currentAt))) {
        return;
      }
      if (current?.mode == mode && current?.changedAt == changedAt) return;
      await _write(businessId, mode, changedAt: changedAt);
    } catch (_) {
      // A cache only.
    }
  }

  Future<void> _write(
    String businessId,
    AccountMode mode, {
    DateTime? changedAt,
  }) async {
    final box = _box();
    await box.writeString(
      key: kAccountModeCacheKey,
      value: withCachedAccountMode(
        box.readString(key: kAccountModeCacheKey),
        businessId,
        mode,
        changedAt: changedAt,
      ),
    );
  }

  /// After a personal signup: personal from now on, until [confirmPending]
  /// gets the server to agree.
  Future<void> markPendingPersonal() async {
    try {
      await _box().writeString(
        key: kPendingAccountModeKey,
        value: AccountMode.personal.value,
      );
    } catch (_) {}
  }

  bool get hasPending =>
      parseAccountMode(_read(kPendingAccountModeKey)).isPersonal;

  /// Sends a pending personal signup to the server. Safe to call often; a
  /// failure keeps it pending for the next try.
  Future<void> confirmPending() async {
    if (!hasPending || activeBusinessId() == null) return;
    try {
      await switchTo(AccountMode.personal);
    } catch (e) {
      talker.warning('Personal signup not confirmed yet (will retry): $e');
    }
  }

  /// Switches the active business. Throws [AccountModeException] when the
  /// server did not take it; the local state is then unchanged.
  Future<AccountModeResult> switchTo(AccountMode mode) async {
    final id = activeBusinessId();
    if (id == null) {
      throw const AccountModeException('No business is selected.');
    }
    final result = await _client.switchTo(mode);
    // The server just took this switch, so it replaces whatever was cached,
    // however new. With the server's time it also beats the old Ditto doc
    // until the new one syncs back. Never the device clock: a clock running
    // ahead would let this entry outrank later switches made elsewhere.
    // An answer without a time that only repeats the cached mode keeps the
    // cached server time, so a stale doc cannot outrank it afterwards.
    try {
      final cached = cachedEntry(id);
      final repeatsTimedEntry =
          result.changedAt == null &&
          cached?.mode == result.mode &&
          cached?.changedAt != null;
      if (!repeatsTimedEntry) {
        await _write(id, result.mode, changedAt: result.changedAt);
      }
    } catch (_) {
      // A cache only.
    }
    try {
      await _box().remove(key: kPendingAccountModeKey);
    } catch (_) {}
    return result;
  }
}
