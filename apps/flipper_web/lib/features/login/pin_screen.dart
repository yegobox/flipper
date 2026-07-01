import 'dart:async';

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _OtpType { sms, authenticator }

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key, this.isPinVerified = false});
  final bool isPinVerified;

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen>
    with TickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _otpController = TextEditingController();
  final _pinFocus      = FocusNode();
  final _otpFocus      = FocusNode();

  bool _isLoading   = false;
  bool _isDone      = false;
  bool _showPin     = false;
  bool _hasError    = false;
  String _errorMsg  = '';
  late bool _isPinVerified;
  _OtpType _otpType = _OtpType.authenticator;

  late AnimationController _fadeCtrl;
  late AnimationController _shakeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<double>   _shakeOffset;

  @override
  void initState() {
    super.initState();
    _isPinVerified = widget.isPinVerified;

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _shakeCtrl = AnimationController(vsync: this, duration: SIMotion.shake);

    _fadeAnim    = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _shakeOffset = SIMotion.pinShake(_shakeCtrl);

    _pinFocus.addListener(() { if (mounted) setState(() {}); });
    _pinController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    if (_hasError) {
      setState(() { _hasError = false; _errorMsg = ''; });
    } else {
      if (mounted) setState(() {});
    }
    // Auto-submit when all 6 cells are filled.
    if (!_isPinVerified &&
        !_isLoading &&
        !_isDone &&
        _pinController.text.length == SITokens.pinCellCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pinController.text.length == SITokens.pinCellCount) {
          unawaited(_handleSubmission());
        }
      });
    }
  }

  void _playShake() {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    _shakeCtrl.forward(from: 0);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _shakeCtrl.dispose();
    _pinFocus.removeListener(() {});
    _pinFocus.dispose();
    _otpFocus.dispose();
    _pinController.removeListener(_onPinChanged);
    _pinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission() async {
    if (_isLoading || _isDone) return;

    setState(() { _isLoading = true; _hasError = false; _errorMsg = ''; });
    HapticFeedback.lightImpact();

    try {
      final auth = ref.read(authRepositoryProvider);

      if (!_isPinVerified) {
        final pin = _pinController.text;
        if (pin.length < 4) {
          setState(() {
            _hasError = true;
            _errorMsg = 'PIN must be at least 4 digits';
          });
          _playShake();
          return;
        }
        final success = await auth.verifyPin(pin);
        if (mounted) {
          if (success) {
            setState(() => _isPinVerified = true);
            _otpFocus.requestFocus();
          } else {
            setState(() {
              _hasError = true;
              _errorMsg = 'Invalid PIN. Please try again.';
            });
            _pinController.clear();
            _playShake();
          }
        }
      } else {
        final pin = _pinController.text;
        final otp = _otpController.text.trim();
        if (otp.isEmpty) {
          setState(() {
            _hasError = true;
            _errorMsg = _otpType == _OtpType.sms
                ? 'OTP is required'
                : 'Authenticator code is required';
          });
          return;
        }
        bool success;
        if (_otpType == _OtpType.sms) {
          success = await auth.verifyOtp(pin, otp);
        } else {
          success = await auth.verifyTotp(pin, otp);
        }
        if (mounted) {
          if (success) {
            setState(() => _isDone = true);
            context.go('/business-selection');
          } else {
            setState(() {
              _hasError = true;
              _errorMsg = _otpType == _OtpType.sms
                  ? 'Invalid OTP. Please try again.'
                  : 'Invalid authenticator code. Please try again.';
            });
            _playShake();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMsg = e.toString().replaceFirst('Exception: ', '');
          if (!_isPinVerified) _pinController.clear();
        });
        _playShake();
      }
    } finally {
      if (mounted && !_isDone) setState(() => _isLoading = false);
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Trouble signing in?'),
        content: const Text(
          'If you have forgotten your PIN, contact your account administrator or reach out to Flipper support.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SITokens.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= SITokens.desktopBreakpoint) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildFormColumn(compact: false)),
                  const Expanded(child: WebBrandPanel()),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: _buildFormColumn(compact: true),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormColumn({required bool compact}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : 48,
        vertical: compact ? 0 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SIBrandHeader(),
          if (compact)
            Expanded(
              child: LayoutBuilder(
                builder: (_, sc) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: sc.maxHeight),
                    child: Center(child: _buildForm(compact: true)),
                  ),
                ),
              ),
            )
          else
            Expanded(child: Center(child: _buildForm(compact: false))),
          if (!compact) const SIBottomBar(),
        ],
      ),
    );
  }

  Widget _buildForm({required bool compact}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: SITokens.formMaxWidth),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isPinVerified ? 'Verify your identity' : 'Welcome back',
              style: context.siText(
                fontSize: compact ? 32 : 40,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isPinVerified
                  ? 'Enter the code from your ${_otpType == _OtpType.sms ? 'SMS message' : 'authenticator app'} to continue.'
                  : 'Enter your PIN to manage your business securely.',
              style: context.siText(
                fontSize: compact ? 15 : 16,
                height: 1.5,
                color: SITokens.ink2,
              ),
            ),
            SizedBox(height: compact ? 28 : 36),
            if (!_isPinVerified) _buildPinSection(compact: compact),
            if (_isPinVerified) _buildOtpSection(compact: compact),
            const SizedBox(height: 26),
            FlipperGradientButton(
              text: _isDone
                  ? 'Signed in ✓'
                  : (_isLoading
                      ? 'Verifying…'
                      : (_isPinVerified ? 'Verify' : 'Sign in')),
              icon: _isDone ? null : Icons.arrow_outward_rounded,
              isLoading: _isLoading,
              onPressed: (_isLoading || _isDone) ? null : _handleSubmission,
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: _showHelp,
                child: Text(
                  'Trouble signing in?',
                  style: context.siText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SITokens.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go('/signup'),
                child: Text(
                  "Don't have an account? Sign up",
                  style: context.siText(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SITokens.ink3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinSection({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'PIN',
              style: context.siText(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SITokens.ink2,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _showPin = !_showPin),
              icon: Icon(
                _showPin
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 15,
                color: SITokens.ink3,
              ),
              label: Text(
                _showPin ? 'Hide' : 'Show',
                style: context.siText(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: SITokens.ink3,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildHiddenPinField(),
        AnimatedBuilder(
          animation: _shakeOffset,
          builder: (_, child) => Transform.translate(
            offset: Offset(_shakeOffset.value, 0),
            child: child,
          ),
          child: SIPinCells(
            pin: _pinController.text,
            showDigits: _showPin,
            hasError: _hasError,
            focused: _pinFocus.hasFocus,
            onTap: () {
              if (!_pinFocus.hasFocus) _pinFocus.requestFocus();
            },
          ),
        ),
        const SizedBox(height: 12),
        SIStatusLine(
          hasError: _hasError,
          isSuccess: _isDone,
          message: _errorMsg,
        ),
      ],
    );
  }

  Widget _buildHiddenPinField() {
    return Opacity(
      opacity: 0,
      child: SizedBox(
        height: 0,
        child: TextFormField(
          key: const Key('pin_hidden_input'),
          controller: _pinController,
          focusNode: _pinFocus,
          autofocus: true,
          enabled: !_isLoading && !_isDone,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(SITokens.pinCellCount),
          ],
          onFieldSubmitted: (_) => _handleSubmission(),
          style: const TextStyle(fontSize: 1, height: 0),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSection({required bool compact}) {
    final isAuthenticator = _otpType == _OtpType.authenticator;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: SITokens.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SITokens.line),
          ),
          child: Row(
            children: [
              Expanded(
                child: _toggleItem('Authenticator', _OtpType.authenticator, compact),
              ),
              Expanded(
                child: _toggleItem('SMS', _OtpType.sms, compact),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isAuthenticator ? 'Authenticator Code' : 'SMS Code',
          style: context.siText(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: SITokens.ink2,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          key: const Key('otp_input'),
          controller: _otpController,
          focusNode: _otpFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleSubmission(),
          style: context.siPinDigit(fontSize: compact ? 16 : 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: SITokens.surface2,
            hintText: '000000',
            hintStyle: context
                .siPinDigit(fontSize: compact ? 16 : 18)
                .copyWith(color: SITokens.ink3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SITokens.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SITokens.radiusMd),
              borderSide: BorderSide(
                color: _hasError ? SITokens.danger : SITokens.blue,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: compact ? 14 : 18,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SIStatusLine(
          hasError: _hasError,
          isSuccess: _isDone,
          message: _errorMsg,
        ),
      ],
    );
  }

  Widget _toggleItem(String label, _OtpType type, bool compact) {
    final isSelected = _otpType == type;
    return GestureDetector(
      onTap: () {
        if (_otpType != type) {
          setState(() {
            _otpType = type;
            _hasError = false;
            _errorMsg = '';
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SITokens.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF102040).withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.siText(
            fontSize: compact ? 12 : 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? SITokens.ink1 : SITokens.ink3,
          ),
        ),
      ),
    );
  }
}
