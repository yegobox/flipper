import 'package:flipper_mfa/flipper_mfa.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flipper_auth/core/providers.dart';
import 'package:uuid/uuid.dart';

class MfaSetupView extends ConsumerStatefulWidget {
  const MfaSetupView({Key? key}) : super(key: key);

  @override
  ConsumerState<MfaSetupView> createState() => _MfaSetupViewState();
}

class _MfaSetupViewState extends ConsumerState<MfaSetupView>
    with TickerProviderStateMixin {
  String? _secret;
  bool _isLoading = true;
  String? _error;
  bool _secretCopied = false;
  late final AnimationController _scanController;

  static const _qrFrameSize = 240.0;
  static const _qrPadding = 18.0;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _loadMfaSecret();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _loadMfaSecret() async {
    try {
      final userId = ProxyService.box.getUserId();
      if (userId == null) {
        setState(() {
          _error = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      final userMfaSecretRepository = UserMfaSecretRepository(
        ref.read(supabaseProvider),
      );
      UserMfaSecret? existingSecret = await userMfaSecretRepository
          .getSecretByUserId(userId);

      if (existingSecret != null) {
        _secret = existingSecret.secret;
      } else {
        // Generate a new secret if one doesn't exist
        _secret = MfaService().generateSecret();
        // Save the new secret to the database
        await userMfaSecretRepository.addSecret(
          UserMfaSecret(
            userId: userId,
            id: const Uuid().v4(),
            secret: _secret!,
            issuer: 'Flipper',
            accountName: ProxyService.box.getUserPhone(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading/generating MFA secret: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _copySecret() async {
    if (_secret != null) {
      await Clipboard.setData(ClipboardData(text: _secret!));
      setState(() {
        _secretCopied = true;
      });
      // Reset the copied state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _secretCopied = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final phone = ProxyService.box.getUserPhone() ?? '';

    Widget leadingClose() {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.18),
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.close,
              size: 22,
              color: colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: leadingClose(),
          title: Text(
            'Setup authenticator',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Setting up your authenticator...',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: leadingClose(),
          title: Text(
            'Setup authenticator',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 32,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Setup failed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Go back',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final secret = _secret ?? '';
    final stepTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface.withValues(alpha: 0.75),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leadingClose(),
        title: Text(
          'Setup authenticator',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set up two-factor\nauthentication',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Scan the QR code below with your authenticator\napp to protect your Flipper account.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 22),

              // Stepper (Scan QR / Verify / Done)
              Row(
                children: [
                  _StepDot(
                    active: true,
                    index: 1,
                    label: 'Scan QR',
                    labelStyle: stepTextStyle,
                    colorScheme: colorScheme,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  _StepDot(
                    active: false,
                    index: 2,
                    label: 'Verify',
                    labelStyle: stepTextStyle,
                    colorScheme: colorScheme,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  _StepDot(
                    active: false,
                    index: 3,
                    label: 'Done',
                    labelStyle: stepTextStyle,
                    colorScheme: colorScheme,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // QR Code section
              Center(
                child: Column(
                  children: [
                    _QrFrame(
                      frameSize: _qrFrameSize,
                      padding: _qrPadding,
                      scanAnimation: _scanController,
                      child: QrImageView(
                        data:
                            'otpauth://totp/Flipper:$phone?secret=$secret&issuer=Flipper',
                        version: QrVersions.auto,
                        size: _qrFrameSize - (_qrPadding * 2),
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0D0E12),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF0D0E12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Secret key section
              _SetupKeyCard(
                secret: secret,
                secretCopied: _secretCopied,
                onCopy: _copySecret,
              ),

              const SizedBox(height: 48),

              // Action buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'I\'ve set up my authenticator',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Help section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Need help?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use apps like Microsoft Authenticator, Google Authenticator, or Authy to scan the QR code and generate verification codes.',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final int index;
  final String label;
  final TextStyle labelStyle;
  final ColorScheme colorScheme;

  const _StepDot({
    required this.active,
    required this.index,
    required this.label,
    required this.labelStyle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB);
    final fg = active ? Colors.white : const Color(0xFF6B7280);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: labelStyle.copyWith(
            color: active
                ? colorScheme.onSurface.withValues(alpha: 0.85)
                : colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _SetupKeyCard extends StatelessWidget {
  final String secret;
  final bool secretCopied;
  final VoidCallback onCopy;

  const _SetupKeyCard({
    required this.secret,
    required this.secretCopied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SETUP KEY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onCopy,
                icon: Icon(
                  secretCopied ? Icons.check : Icons.copy,
                  size: 16,
                  color: secretCopied
                      ? const Color(0xFF2563EB)
                      : cs.onSurface.withValues(alpha: 0.6),
                ),
                label: Text(
                  secretCopied ? 'Copied' : 'Copy',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: secretCopied
                        ? const Color(0xFF2563EB)
                        : cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            secret,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrFrame extends StatelessWidget {
  final Widget child;
  final double frameSize;
  final double padding;
  final Animation<double> scanAnimation;

  const _QrFrame({
    required this.child,
    required this.frameSize,
    required this.padding,
    required this.scanAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: frameSize,
      height: frameSize,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
          ),
          // Corner brackets
          Positioned(top: 0, left: 0, child: _Corner(top: true, left: true)),
          Positioned(top: 0, right: 0, child: _Corner(top: true, left: false)),
          Positioned(
            bottom: 0,
            left: 0,
            child: _Corner(top: false, left: true),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _Corner(top: false, left: false),
          ),
          // Scan line
          Positioned.fill(
            child: AnimatedBuilder(
              animation: scanAnimation,
              builder: (context, _) {
                // Keep a 20px margin from top/bottom, like mock.
                const edgePadding = 20.0;
                final usableHeight =
                    frameSize - (padding * 2) - (edgePadding * 2);
                final top = edgePadding + (scanAnimation.value * usableHeight);

                return IgnorePointer(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 12,
                        right: 12,
                        top: top,
                        child: Opacity(
                          opacity:
                              scanAnimation.value < 0.08 ||
                                  scanAnimation.value > 0.92
                              ? 0
                              : 1,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF2563EB),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Subtle overlay to make scan feel "active"
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                cs.primary.withValues(alpha: 0.00),
                                cs.primary.withValues(alpha: 0.03),
                                cs.primary.withValues(alpha: 0.00),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool top;
  final bool left;

  const _Corner({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    const c = Color(0xFF2563EB);
    final border = Border(
      top: top ? const BorderSide(color: c, width: 2.5) : BorderSide.none,
      bottom: !top ? const BorderSide(color: c, width: 2.5) : BorderSide.none,
      left: left ? const BorderSide(color: c, width: 2.5) : BorderSide.none,
      right: !left ? const BorderSide(color: c, width: 2.5) : BorderSide.none,
    );

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
          bottomLeft: const Radius.circular(2),
          bottomRight: const Radius.circular(2),
        ),
      ),
    );
  }
}
