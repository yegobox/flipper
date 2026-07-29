import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/whatsapp_connection_provider.dart';
import '../services/whatsapp_connection_service.dart';
import '../theme/flo_theme.dart';
import 'flo/flo_icons.dart';

/// Dialog for connecting/disconnecting WhatsApp account (Flo design language).
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

    if (phoneNumberId.isEmpty) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Phone Number ID cannot be empty',
          backgroundColor: FloTheme.loss,
        );
      }
      return;
    }

    if (!RegExp(r'^\d{5,15}$').hasMatch(phoneNumberId)) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Phone Number ID must contain only digits and be 5-15 characters long',
          backgroundColor: FloTheme.loss,
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
        backgroundColor: FloTheme.blue,
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
        backgroundColor: FloTheme.blue,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(whatsAppConnectionStateProvider);

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
      backgroundColor: FloTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
      ),
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: FloTheme.surface,
          borderRadius: BorderRadius.circular(FloTheme.radiusLg),
          border: Border.all(color: FloTheme.line),
          boxShadow: const [FloTheme.sh3],
        ),
        child: connectionState.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(48),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(FloTheme.blue),
              ),
            ),
          ),
          error: (error, _) => _buildErrorView(error.toString()),
          data: (state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state.isConnected),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: state.isConnected
                      ? _buildConnectedView(state)
                      : _buildDisconnectedView(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isConnected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 12, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: FloTheme.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FloTheme.blueTint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: FloIcons.whatsApp(size: 21, color: FloTheme.blueDeep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WhatsApp Business',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02,
                    color: FloTheme.ink1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isConnected ? 'Connected' : 'Not connected',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isConnected ? FloTheme.gainInk : FloTheme.ink3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            color: FloTheme.ink3,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedView(WhatsAppConnectionState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: FloTheme.gainTint,
            borderRadius: BorderRadius.circular(FloTheme.radiusMd),
            border: Border.all(color: FloTheme.line),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FloTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: FloTheme.line),
                ),
                child: FloIcons.check(size: 16, color: FloTheme.gainInk),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account active',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: FloTheme.ink1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      state.phoneNumberId ?? '',
                      style: FloTheme.mono(13).copyWith(color: FloTheme.ink2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: FloTheme.surface2,
            borderRadius: BorderRadius.circular(FloTheme.radiusSm),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: FloTheme.ink3),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Saved to your business account — it stays connected on other devices when you sign in.',
                  style: TextStyle(
                    fontSize: 12,
                    color: FloTheme.ink2,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: state.isLoading ? null : _handleDisconnect,
            icon: state.isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(FloTheme.loss),
                    ),
                  )
                : const Icon(Icons.link_off_rounded, size: 18),
            label: Text(state.isLoading ? 'Disconnecting...' : 'Disconnect'),
            style: OutlinedButton.styleFrom(
              foregroundColor: FloTheme.lossInk,
              side: const BorderSide(color: FloTheme.loss),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              ),
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
          'Connect your WhatsApp Business account to receive and reply to customer messages.',
          style: TextStyle(
            color: FloTheme.ink2,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        _buildSetupStep(
          number: '1',
          text: 'Go to your Meta Business Suite',
          icon: Icons.open_in_new_rounded,
        ),
        const SizedBox(height: 8),
        _buildSetupStep(
          number: '2',
          text: 'Find your Phone Number ID in WhatsApp settings',
          icon: Icons.search_rounded,
        ),
        const SizedBox(height: 8),
        _buildSetupStep(
          number: '3',
          text: 'Paste it below and connect',
          icon: Icons.content_paste_rounded,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _phoneNumberIdController,
          decoration: InputDecoration(
            labelText: 'Phone Number ID',
            labelStyle: const TextStyle(color: FloTheme.ink3),
            hintText: 'e.g., 101514826127381',
            hintStyle: TextStyle(
              color: FloTheme.ink4.withValues(alpha: 0.9),
            ),
            errorText: state.error,
            errorStyle: const TextStyle(color: FloTheme.lossInk, fontSize: 12),
            prefixIcon: const Icon(
              Icons.tag_rounded,
              color: FloTheme.ink3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              borderSide: const BorderSide(color: FloTheme.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              borderSide: const BorderSide(color: FloTheme.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              borderSide: const BorderSide(color: FloTheme.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              borderSide: const BorderSide(color: FloTheme.loss),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              borderSide: const BorderSide(color: FloTheme.loss, width: 1.5),
            ),
            filled: true,
            fillColor: FloTheme.surface2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          enabled: !state.isLoading,
          style: FloTheme.mono(14).copyWith(color: FloTheme.ink1),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: state.isLoading ? null : _handleConnect,
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: state.isLoading ? null : FloTheme.gradBtn,
                  color: state.isLoading ? FloTheme.lineStrong : null,
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  boxShadow: state.isLoading
                      ? null
                      : const [FloTheme.shBlue],
                ),
                child: Center(
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloIcons.link(size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'Connect WhatsApp',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.01,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetupStep({
    required String number,
    required String text,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: FloTheme.blueTint,
            shape: BoxShape.circle,
            border: Border.all(color: FloTheme.blueTint2),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: FloTheme.blueDeep,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: FloTheme.ink2,
              height: 1.3,
            ),
          ),
        ),
        Icon(icon, size: 16, color: FloTheme.ink4),
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FloTheme.lossTint,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: FloTheme.lossInk,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Connection Error',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: FloTheme.ink1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                color: FloTheme.ink3,
                splashRadius: 18,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: FloTheme.lossTint,
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              border: Border.all(color: FloTheme.loss.withValues(alpha: 0.35)),
            ),
            child: Text(
              error,
              style: const TextStyle(
                color: FloTheme.lossInk,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(whatsAppConnectionStateProvider.notifier).refresh();
                },
                borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: FloTheme.gradBtn,
                    borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  ),
                  child: const Center(
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
