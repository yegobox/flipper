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
    extends ConsumerState<WhatsAppConnectionDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneNumberIdController =
      TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _phoneNumberIdController.dispose();
    _pulseController.dispose();
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
        backgroundColor: AiTheme.whatsAppGreen,
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
        backgroundColor: AiTheme.whatsAppGreen,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: AiTheme.whatsAppGreen.withValues(alpha: 0.15),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        child: connectionState.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(48),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AiTheme.whatsAppGreen,
                ),
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
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AiTheme.whatsAppGreen.withValues(alpha: 0.08),
            AiTheme.whatsAppDarkGreen.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: AiTheme.whatsAppGreen.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AiTheme.whatsAppGreen, AiTheme.whatsAppDarkGreen],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AiTheme.whatsAppGreen.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WhatsApp Business',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AiTheme.textColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (isConnected) ...[
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AiTheme.whatsAppGreen.withValues(
                                alpha: _pulseAnimation.value,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AiTheme.whatsAppGreen.withValues(
                                    alpha: _pulseAnimation.value * 0.4,
                                  ),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      isConnected ? 'Connected' : 'Not connected',
                      style: TextStyle(
                        fontSize: 13,
                        color: isConnected
                            ? AiTheme.whatsAppGreen
                            : AiTheme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            color: AiTheme.secondaryColor,
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AiTheme.whatsAppGreen.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AiTheme.whatsAppGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AiTheme.whatsAppGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AiTheme.whatsAppGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Active',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AiTheme.whatsAppDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 14,
                          color: AiTheme.hintColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            state.phoneNumberId ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: AiTheme.secondaryColor,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Info text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AiTheme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AiTheme.hintColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'WhatsApp messages will appear in your conversations automatically.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AiTheme.secondaryColor,
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link_off_rounded, size: 18),
            label: Text(state.isLoading ? 'Disconnecting...' : 'Disconnect'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade400,
              side: BorderSide(color: Colors.red.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
        Text(
          'Connect your WhatsApp Business account to receive and reply to customer messages.',
          style: TextStyle(
            color: AiTheme.secondaryColor,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        // Setup steps
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
        const SizedBox(height: 20),
        TextField(
          controller: _phoneNumberIdController,
          decoration: InputDecoration(
            labelText: 'Phone Number ID',
            labelStyle: const TextStyle(color: AiTheme.hintColor),
            hintText: 'e.g., 101514826127381',
            hintStyle: TextStyle(
              color: AiTheme.hintColor.withValues(alpha: 0.6),
            ),
            errorText: state.error,
            prefixIcon: Icon(
              Icons.phone_rounded,
              color: AiTheme.whatsAppGreen.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AiTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AiTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AiTheme.whatsAppGreen,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AiTheme.inputBackgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          enabled: !state.isLoading,
          style: const TextStyle(fontSize: 15, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.isLoading ? null : _handleConnect,
            icon: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.link_rounded, size: 20),
            label: Text(
              state.isLoading ? 'Connecting...' : 'Connect WhatsApp',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AiTheme.whatsAppGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              shadowColor: AiTheme.whatsAppGreen.withValues(alpha: 0.3),
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
            color: AiTheme.whatsAppGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AiTheme.whatsAppDarkGreen,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AiTheme.secondaryColor,
              height: 1.3,
            ),
          ),
        ),
        Icon(icon, size: 16, color: AiTheme.hintColor.withValues(alpha: 0.5)),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Connection Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AiTheme.textColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                color: AiTheme.secondaryColor,
                splashRadius: 18,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red.shade400,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
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
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(whatsAppConnectionStateProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AiTheme.whatsAppGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
