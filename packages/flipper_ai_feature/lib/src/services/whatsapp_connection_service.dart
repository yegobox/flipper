import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/whatsapp_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

const Object _unset = Object();

/// State representing WhatsApp connection status
class WhatsAppConnectionState {
  final bool isConnected;
  final String? phoneNumberId;
  final bool isLoading;
  final String? error;

  const WhatsAppConnectionState({
    this.isConnected = false,
    this.phoneNumberId,
    this.isLoading = false,
    this.error,
  });

  WhatsAppConnectionState copyWith({
    bool? isConnected,
    Object? phoneNumberId = _unset,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return WhatsAppConnectionState(
      isConnected: isConnected ?? this.isConnected,
      phoneNumberId: identical(phoneNumberId, _unset)
          ? this.phoneNumberId
          : phoneNumberId as String?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

/// Service for managing WhatsApp connection business logic.
///
/// Source of truth is [Business.messagingChannels] on Supabase.
/// Local Brick + prefs mirror it for offline / this device.
class WhatsAppConnectionService {
  final WhatsAppService _whatsappService;
  final Repository _repository;

  WhatsAppConnectionService({
    WhatsAppService? whatsappService,
    Repository? repository,
  })  : _whatsappService = whatsappService ?? WhatsAppService(),
        _repository = repository ?? Repository();

  Future<Business?> _currentBusiness({bool hydrateRemote = false}) async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) return null;

    final query = Query(where: [Where('id').isExactly(businessId)]);
    final result = await _repository.get<Business>(
      query: query,
      policy: hydrateRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
    );
    return result.firstOrNull;
  }

  Future<WhatsAppConnectionState> getConnectionState() async {
    try {
      final business = await _currentBusiness(hydrateRemote: true);
      var phoneNumberId = business?.getWhatsAppPhoneNumberId();

      // Prefs fallback (older connects that never reached Supabase).
      if (phoneNumberId == null || phoneNumberId.isEmpty) {
        final fromPrefs = ProxyService.box.whatsAppPhoneNumberId();
        if (fromPrefs != null && fromPrefs.isNotEmpty) {
          phoneNumberId = fromPrefs;
          // Heal remote / local Business so next launch doesn't depend on prefs.
          try {
            await _updateBusinessMessagingChannels(phoneNumberId);
          } catch (_) {}
        }
      }

      if (phoneNumberId != null && phoneNumberId.isNotEmpty) {
        await ProxyService.box.writeString(
          key: 'whatsAppPhoneNumberId',
          value: phoneNumberId,
        );
        return WhatsAppConnectionState(
          isConnected: true,
          phoneNumberId: phoneNumberId,
        );
      }

      return const WhatsAppConnectionState(isConnected: false);
    } catch (e) {
      return WhatsAppConnectionState(isConnected: false, error: e.toString());
    }
  }

  Future<WhatsAppConnectionState> connect(String phoneNumberId) async {
    if (phoneNumberId.isEmpty) {
      return const WhatsAppConnectionState(
        isConnected: false,
        error: 'Please enter a phone number ID',
      );
    }

    try {
      final isValid = await _whatsappService.validatePhoneNumberId(
        phoneNumberId,
      );

      if (!isValid) {
        return const WhatsAppConnectionState(
          isConnected: false,
          error: 'Invalid phone number ID',
        );
      }

      await _updateBusinessMessagingChannels(phoneNumberId);

      await ProxyService.box.writeString(
        key: 'whatsAppPhoneNumberId',
        value: phoneNumberId,
      );

      return WhatsAppConnectionState(
        isConnected: true,
        phoneNumberId: phoneNumberId,
      );
    } catch (e) {
      await ProxyService.box.writeString(
        key: 'whatsAppPhoneNumberId',
        value: '',
      );

      return WhatsAppConnectionState(
        isConnected: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<WhatsAppConnectionState> disconnect() async {
    try {
      await _updateBusinessMessagingChannels(null);

      await ProxyService.box.writeString(
        key: 'whatsAppPhoneNumberId',
        value: '',
      );

      return const WhatsAppConnectionState(isConnected: false);
    } catch (e) {
      return WhatsAppConnectionState(
        isConnected: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Persist Phone Number ID on Business locally and on Supabase.
  Future<void> _updateBusinessMessagingChannels(String? phoneNumberId) async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) {
      throw Exception('No business selected — cannot save WhatsApp connection');
    }

    final business = await _currentBusiness(hydrateRemote: false);
    if (business == null) {
      throw Exception('Business not found — cannot save WhatsApp connection');
    }

    // Mutate in place (avoids broken Business.copyWith field drops).
    business.setWhatsAppPhoneNumberId(phoneNumberId);
    final channels = business.messagingChannelsMap();

    // Direct jsonb write — Brick serializes messaging_channels as a JSON string,
    // which PostgREST can reject / store incorrectly for jsonb columns.
    await Supabase.instance.client
        .from('businesses')
        .update({'messaging_channels': channels})
        .eq('id', businessId);

    // Keep local Brick / Turso in sync for offline reads.
    await _repository.upsert<Business>(
      business,
      policy: OfflineFirstUpsertPolicy.localOnly,
    );
  }
}
