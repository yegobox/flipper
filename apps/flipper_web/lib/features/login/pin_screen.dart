import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flipper_web/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final _pinController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isPinVerified = false;

  Future<void> _handleSubmission() async {
    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      if (!_isPinVerified) {
        final pin = _pinController.text;
        final success = await authRepository.verifyPin(pin);

        if (success) {
          setState(() => _isPinVerified = true);
        } else {
          _showError('Invalid PIN');
        }
      } else {
        final otp = _otpController.text;
        final success = await authRepository.verifyOtp(otp);

        if (success) {
          ref.read(authStateProvider.notifier).state = AuthState.authenticated;
        } else {
          _showError('Invalid OTP');
        }
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                              _isPinVerified ? 'Enter OTP' : 'Enter PIN',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Input field
                            TextFormField(
                              key: const Key('pinOrOtpInput'),
                              controller: _isPinVerified
                                  ? _otpController
                                  : _pinController,
                              decoration: InputDecoration(
                                labelText: _isPinVerified ? 'OTP' : 'PIN',
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                prefixIcon: Icon(
                                  _isPinVerified ? Icons.security : Icons.lock,
                                  color: theme.colorScheme.primary,
                                ),
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
        _isPinVerified ? 'Verify OTP' : 'Submit',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
