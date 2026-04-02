import 'dart:convert';

import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ServiceGigProviderSaveResult { synced, localOnly }

/// Persists provider registration to Supabase when available, with local JSON fallback.
class ServiceGigProviderRepository {
  ServiceGigProviderRepository();

  static const _table = 'service_gig_providers';

  String _localKey(String userId) => 'service_gig_provider_profile_$userId';

  Future<ServiceGigProvider?> load(String? userId) async {
    if (userId == null || userId.isEmpty) return null;

    try {
      final row = await Supabase.instance.client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (row != null) {
        final map = Map<String, dynamic>.from(row);
        final profile = ServiceGigProvider.fromJson(map);
        await _writeLocal(profile);
        return profile;
      }
    } catch (_) {
      // Table missing, offline, or RLS — fall back to local cache.
    }

    return _readLocal(userId);
  }

  /// Public display name for a provider [userId] (for customer-facing labels).
  Future<String?> getDisplayNameForUserId(String userId) async {
    if (userId.isEmpty) return null;
    try {
      final row = await Supabase.instance.client
          .from(_table)
          .select('display_name')
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      final map = Map<String, dynamic>.from(row);
      final name = map['display_name']?.toString();
      if (name == null || name.isEmpty) return null;
      return name;
    } catch (_) {
      return null;
    }
  }

  /// All registered providers from Supabase, optionally excluding the signed-in user.
  Future<List<ServiceGigProvider>> listProviders({
    String? excludeUserId,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from(_table)
          .select()
          .order('display_name', ascending: true) as List<dynamic>;

      final list = response
          .map(
            (e) => ServiceGigProvider.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
      var out = list;

      if (excludeUserId != null && excludeUserId.isNotEmpty) {
        out = out.where((p) => p.userId != excludeUserId).toList();
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  Future<ServiceGigProviderSaveResult> save(ServiceGigProvider profile) async {
    await _writeLocal(profile);

    final now = DateTime.now().toUtc().toIso8601String();
    final payload = Map<String, dynamic>.from(profile.toJson())
      ..remove('created_at')
      ..['updated_at'] = now;

    try {
      await Supabase.instance.client.from(_table).upsert(
            payload,
            onConflict: 'user_id',
          );
      return ServiceGigProviderSaveResult.synced;
    } catch (_) {
      return ServiceGigProviderSaveResult.localOnly;
    }
  }

  ServiceGigProvider? _readLocal(String userId) {
    final raw = ProxyService.box.readString(key: _localKey(userId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ServiceGigProvider.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeLocal(ServiceGigProvider profile) async {
    await ProxyService.box.writeString(
      key: _localKey(profile.userId),
      value: jsonEncode(profile.toJson()),
    );
  }

  /// Updates [is_available] on Supabase (browse filter). Returns false if sync failed.
  Future<bool> updateAvailability({
    required String userId,
    required bool isAvailable,
  }) async {
    if (userId.isEmpty) return false;
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      await Supabase.instance.client.from(_table).update({
        'is_available': isAvailable,
        'updated_at': now,
      }).eq('user_id', userId);
      final cached = _readLocal(userId);
      if (cached != null) {
        await _writeLocal(cached.copyWith(isAvailable: isAvailable, updatedAt: DateTime.now().toUtc()));
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
