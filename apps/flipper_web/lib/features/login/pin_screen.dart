import 'package:flipper_web/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/widgets/app_button.dart';

enum OtpType { sms, authenticator }

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key, this.isPinVerified = false});
  final bool isPinVerified;

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final _pinController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  late bool _isPinVerified;
  String? _errorMessage;
  OtpType _otpType = OtpType.sms;

  @override
  void initState() {
    super.initState();
    _isPinVerified = widget.isPinVerified;
  }

  Future<void> _handleSubmission() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final authRepository = ref.read(authRepositoryProvider);

      if (mounted) {
        setState(() => _errorMessage = null);
      }

      if (!_isPinVerified) {
        final pin = _pinController.text;
        final success = await authRepository.verifyPin(pin);

        if (mounted) {
          if (success) {
            setState(() => _isPinVerified = true);
          } else {
            setState(() => _errorMessage = 'Invalid PIN');
          }
        }
      } else {
        final pin = _pinController.text;
        final otp = _otpController.text;
        bool success;
        if (_otpType == OtpType.sms) {
          success = await authRepository.verifyOtp(pin, otp);
        } else {
          success = await authRepository.verifyTotp(pin, otp);
        }

        if (!success && mounted) {
          setState(() => _errorMessage = 'Invalid OTP');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height - 100,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left - auth illustration
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.05,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/auth.png',
                          fit: BoxFit.contain,
                          height: 300,
                        ),
                      ),
                    ),
                  ),

                  // Right - form cardlp-\[=.]
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _isPinVerified
                                  ? 'Enter ${_otpType == OtpType.sms ? 'SMS OTP' : 'Authenticator Code'}'
                                  : 'Enter PIN',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),

                            const SizedBox(height: 32),

                            if (_isPinVerified) ...[
                              SegmentedButton<OtpType>(
                                segments: const [
                                  ButtonSegment(
                                    value: OtpType.sms,
                                    label: Text('SMS'),
                                    icon: Icon(Icons.sms),
                                  ),
                                  ButtonSegment(
                                    value: OtpType.authenticator,
                                    label: Text('Authenticator'),
                                    icon: Icon(Icons.shield),
                                  ),
                                ],
                                selected: {_otpType},
                                onSelectionChanged: (newSelection) {
                                  if (mounted) {
                                    setState(() {
                                      _otpType = newSelection.first;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            TextFormField(
                              key: const Key('pinOrOtpInput'),
                              controller: _isPinVerified
                                  ? _otpController
                                  : _pinController,
                              decoration: InputDecoration(
                                labelText: _isPinVerified
                                    ? (_otpType == OtpType.sms
                                          ? 'SMS OTP'
                                          : 'Authenticator Code')
                                    : 'PIN',
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _errorMessage != null
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.outline,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _errorMessage != null
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.error,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                prefixIcon: Icon(
                                  _isPinVerified ? Icons.security : Icons.lock,
                                  color: _errorMessage != null
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary,
                                ),
                                errorText: _errorMessage,
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: !_isPinVerified,
                              obscuringCharacter: '•',
                              autofillHints: _isPinVerified
                                  ? [AutofillHints.oneTimeCode]
                                  : null,
                            ),

                            const SizedBox(height: 32),

                            // Action button
                            AppButton(
                              label: _isPinVerified ? 'Verify' : 'Submit',
                              onPressed: _handleSubmission,
                              variant: AppButtonVariant.primary,
                              isLoading: _isLoading,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              expanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
