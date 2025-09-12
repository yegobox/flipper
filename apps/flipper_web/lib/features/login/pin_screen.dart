import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flipper_web/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      setState(() => _errorMessage = null);

      if (!_isPinVerified) {
        final pin = _pinController.text;
        final success = await authRepository.verifyPin(pin);

        if (success) {
          setState(() => _isPinVerified = true);
        } else {
          setState(() => _errorMessage = 'Invalid PIN');
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

        if (success) {
          ref.read(authStateProvider.notifier).state = AuthState.authenticated;
        } else {
          setState(() => _errorMessage = 'Invalid OTP');
        }
      }
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Get current theme for consistent styling
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height - 100,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left side - Authentication image
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(
                          0.05,
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

                  // Right side - Form container
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
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
                                  setState(() {
                                    _otpType = newSelection.first;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Input field
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
                            _buildActionButton(theme),
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

  Widget _buildActionButton(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FilledButton.tonal(
      onPressed: _handleSubmission,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
      ),
      child: Text(
        _isPinVerified
            ? 'Verify ${_otpType == OtpType.sms ? 'OTP' : 'Code'}'
            : 'Submit',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
