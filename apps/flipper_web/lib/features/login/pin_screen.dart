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
    setState(() {
      _isLoading = true;
    });

    final authRepository = ref.read(authRepositoryProvider);

    try {
      if (!_isPinVerified) {
        final pin = _pinController.text;
        final success = await authRepository.verifyPin(pin);
        if (success) {
          setState(() {
            _isPinVerified = true;
          });
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

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/auth.png',
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _isPinVerified ? 'Enter OTP' : 'Enter PIN',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    if (!_isPinVerified)
                      TextField(
                        key: const Key('pinInput'),
                        controller: _pinController,
                        decoration: const InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      )
                    else
                      TextField(
                        key: const Key('otpInput'),
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSubmission,
                          child: Text(_isPinVerified ? 'Verify OTP' : 'Submit'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}