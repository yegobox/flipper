import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/whatsapp_service.dart';
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
      phoneNumberId: identical(phoneNumberId, _unset) ? this.phoneNumberId : phoneNumberId as String?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

/// Service for managing WhatsApp connection business logic
class WhatsAppConnectionService {
  final WhatsAppService _whatsappService;
  final Repository _repository;

  WhatsAppConnectionService({
    WhatsAppService? whatsappService,
    Repository? repository,
  }) : _whatsappService = whatsappService ?? WhatsAppService(),
       _repository = repository ?? Repository();

  /// Get current connection state from Business model (single source of truth)
  Future<WhatsAppConnectionState> getConnectionState() async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        return const WhatsAppConnectionState(isConnected: false);
      }

      final query = Query(where: [Where('serverId').isExactly(businessId)]);
      final result = await _repository.get<Business>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final business = result.firstOrNull;

      if (business != null) {
        final phoneNumberId = business.getWhatsAppPhoneNumberId();
        if (phoneNumberId != null && phoneNumberId.isNotEmpty) {
          // Sync to local storage for backward compatibility
          await ProxyService.box.writeString(
            key: 'whatsAppPhoneNumberId',
            value: phoneNumberId,
          );

          return WhatsAppConnectionState(
            isConnected: true,
            phoneNumberId: phoneNumberId,
          );
        }
      }

      return const WhatsAppConnectionState(isConnected: false);
    } catch (e) {
      return WhatsAppConnectionState(isConnected: false, error: e.toString());
    }
  }

  /// Validate and connect WhatsApp account
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

      // Save to local storage
      await ProxyService.box.writeString(
        key: 'whatsAppPhoneNumberId',
        value: phoneNumberId,
      );

      // Save to Business model in Supabase
      await _updateBusinessMessagingChannels(phoneNumberId);

      return WhatsAppConnectionState(
        isConnected: true,
        phoneNumberId: phoneNumberId,
      );
    } catch (e) {
      return WhatsAppConnectionState(
        isConnected: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Disconnect WhatsApp account
  Future<WhatsAppConnectionState> disconnect() async {
    try {
      // Clear from local storage
      await ProxyService.box.writeString(
        key: 'whatsAppPhoneNumberId',
        value: '',
      );

      // Clear from Business model
      await _updateBusinessMessagingChannels(null);

      return const WhatsAppConnectionState(isConnected: false);
    } catch (e) {
      return WhatsAppConnectionState(isConnected: false, error: e.toString());
    }
  }

  /// Update Business model with WhatsApp phone number ID
  Future<void> _updateBusinessMessagingChannels(String? phoneNumberId) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) return;

      final query = Query(where: [Where('serverId').isExactly(businessId)]);
      final result = await _repository.get<Business>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final business = result.firstOrNull;

      if (business != null) {
        final updatedBusiness = business.setWhatsAppPhoneNumberId(
          phoneNumberId,
        );
        await _repository.upsert<Business>(
          updatedBusiness,
          policy: OfflineFirstUpsertPolicy.optimisticLocal,
        );
      }
    } catch (e) {
      // Log error but don't fail the connection
      print('Error updating business messaging channels: $e');
    }
  }
}
