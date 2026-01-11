import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/whatsapp_connection_provider.dart';
import '../services/whatsapp_connection_service.dart';
import '../theme/ai_theme.dart';

/// Dialog for connecting/disconnecting WhatsApp account
class WhatsAppConnectionDialog extends ConsumerStatefulWidget {
  final VoidCallback? onConnectionChanged;

  const WhatsAppConnectionDialog({Key? key, this.onConnectionChanged})
    : super(key: key);

  @override
  ConsumerState<WhatsAppConnectionDialog> createState() =>
      _WhatsAppConnectionDialogState();
}

class _WhatsAppConnectionDialogState
    extends ConsumerState<WhatsAppConnectionDialog> {
  final TextEditingController _phoneNumberIdController =
      TextEditingController();

  @override
  void dispose() {
    _phoneNumberIdController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final phoneNumberId = _phoneNumberIdController.text.trim();

    // Validate phone number ID is non-empty and matches expected format
    if (phoneNumberId.isEmpty) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Phone Number ID cannot be empty',
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    // Check that phone number ID contains only digits and has expected length
    if (!RegExp(r'^\d{5,15}$').hasMatch(phoneNumberId)) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Phone Number ID must contain only digits and be 5-15 characters long',
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    final notifier = ref.read(whatsAppConnectionStateProvider.notifier);

    final success = await notifier.connect(phoneNumberId);

    if (success && mounted) {
      widget.onConnectionChanged?.call();

      showCustomSnackBarUtil(
        context,
        'WhatsApp account connected successfully',
        backgroundColor: Colors.green,
      );

      Navigator.of(context).pop();
    }
  }

  Future<void> _handleDisconnect() async {
    final notifier = ref.read(whatsAppConnectionStateProvider.notifier);

    final success = await notifier.disconnect();

    if (success && mounted) {
      widget.onConnectionChanged?.call();

      showCustomSnackBarUtil(
        context,
        'WhatsApp account disconnected successfully',
        backgroundColor: Colors.green,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(whatsAppConnectionStateProvider);

    // Listen to provider changes to update controller text when needed
    ref.listen<AsyncValue<WhatsAppConnectionState>>(
      whatsAppConnectionStateProvider,
      (previous, next) {
        final previousData = previous?.asData?.value;
        final nextData = next.asData?.value;

        if (nextData != null &&
            nextData.phoneNumberId != null &&
            nextData.phoneNumberId != previousData?.phoneNumberId &&
            _phoneNumberIdController.text != nextData.phoneNumberId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _phoneNumberIdController.text = nextData.phoneNumberId!;
            }
          });
        }
      },
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: connectionState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildErrorView(error.toString()),
          data: (state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (state.isConnected)
                  _buildConnectedView(state)
                else
                  _buildDisconnectedView(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.chat_rounded,
            color: Color(0xFF25D366),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'WhatsApp Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AiTheme.textColor,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: AiTheme.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildConnectedView(WhatsAppConnectionState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connected',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Phone Number ID: ${state.phoneNumberId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: state.isLoading ? null : _handleDisconnect,
            icon: const Icon(Icons.link_off_rounded),
            label: state.isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Disconnect'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisconnectedView(WhatsAppConnectionState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your WhatsApp Business phone number ID to connect your account.',
          style: TextStyle(color: AiTheme.secondaryColor, height: 1.5),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _phoneNumberIdController,
          decoration: InputDecoration(
            labelText: 'Phone Number ID',
            hintText: 'e.g., 101514826127381',
            errorText: state.error,
            prefixIcon: const Icon(Icons.phone_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AiTheme.inputBackgroundColor,
          ),
          enabled: !state.isLoading,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _handleConnect,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Connect WhatsApp',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(whatsAppConnectionStateProvider.notifier).refresh();
            },
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}
