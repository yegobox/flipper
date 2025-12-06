import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/whatsapp_message_sync_service.dart';
import 'package:flipper_services/proxy.dart';

/// Provider for WhatsApp message sync service
final whatsappMessageSyncProvider =
    StateNotifierProvider<
      WhatsAppMessageSyncNotifier,
      AsyncValue<WhatsAppSyncState>
    >((ref) {
      return WhatsAppMessageSyncNotifier();
    });

/// Notifier to manage WhatsApp message sync service lifecycle
class WhatsAppMessageSyncNotifier
    extends StateNotifier<AsyncValue<WhatsAppSyncState>> {
  WhatsAppMessageSyncService? _service;

  WhatsAppMessageSyncNotifier() : super(AsyncValue.loading()) {
    _initialize();
  }

  /// Initialize the sync service with the business's WhatsApp phone number ID
  Future<void> _initialize() async {
    try {
      // Get the current business
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        state = AsyncValue.error('Business ID not found', StackTrace.current);
        return;
      }

      // Get business to retrieve WhatsApp phoneNumberId
      final business = await ProxyService.strategy.getBusiness(
        businessId: businessId,
      );

      if (business == null) {
        state = AsyncValue.data(WhatsAppSyncState.idle());
        return;
      }

      final phoneNumberId = business.getWhatsAppPhoneNumberId();

      if (phoneNumberId == null || phoneNumberId.isEmpty) {
        // No WhatsApp configured, that's okay - just idle
        state = AsyncValue.data(WhatsAppSyncState.idle());
        return;
      }

      // Initialize the sync service
      _service = WhatsAppMessageSyncService();
      await _service!.initialize(phoneNumberId);

      // Listen to service state changes
      _service!.stateStream.listen((syncState) {
        state = AsyncValue.data(syncState);
      });

      state = AsyncValue.data(WhatsAppSyncState.idle());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Manually trigger a refresh of the sync service
  Future<void> refresh() async {
    await _initialize();
  }

  @override
  void dispose() {
    _service?.dispose();
    super.dispose();
  }
}
