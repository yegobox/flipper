import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/whatsapp_connection_service.dart';

/// Provider for WhatsAppConnectionService instance
final whatsAppConnectionServiceProvider = Provider<WhatsAppConnectionService>((
  ref,
) {
  return WhatsAppConnectionService();
});

/// Provider for WhatsApp connection state
final whatsAppConnectionStateProvider =
    StateNotifierProvider<
      WhatsAppConnectionNotifier,
      AsyncValue<WhatsAppConnectionState>
    >((ref) {
      final service = ref.watch(whatsAppConnectionServiceProvider);
      return WhatsAppConnectionNotifier(service);
    });

/// Notifier for managing WhatsApp connection state
class WhatsAppConnectionNotifier
    extends StateNotifier<AsyncValue<WhatsAppConnectionState>> {
  final WhatsAppConnectionService _service;

  WhatsAppConnectionNotifier(this._service)
    : super(const AsyncValue.loading()) {
    _initialize();
  }

  /// Initialize connection state from Business model
  Future<void> _initialize() async {
    state = const AsyncValue.loading();
    try {
      final connectionState = await _service.getConnectionState();
      state = AsyncValue.data(connectionState);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh connection state
  Future<void> refresh() async {
    await _initialize();
  }

  /// Connect WhatsApp account
  Future<bool> connect(String phoneNumberId) async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true) ??
          const WhatsAppConnectionState(isLoading: true),
    );

    try {
      final connectionState = await _service.connect(phoneNumberId);
      state = AsyncValue.data(connectionState);
      return connectionState.isConnected;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Disconnect WhatsApp account
  Future<bool> disconnect() async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true) ??
          const WhatsAppConnectionState(isLoading: true),
    );

    try {
      final connectionState = await _service.disconnect();
      state = AsyncValue.data(connectionState);
      return !connectionState.isConnected;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
