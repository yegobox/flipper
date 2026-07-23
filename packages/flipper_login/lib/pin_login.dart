import 'dart:async';

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_login/login_semantics.dart';
import 'package:flipper_login/mfa_provider.dart';
import 'package:flipper_login/pin_login_brand_panel.dart';
import 'package:flipper_login/pin_login_signin_motion.dart';
import 'package:flipper_login/pin_login_signin_widgets.dart';
import 'package:flipper_login/signin_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_login/pin_login_signin_text.dart';
import 'package:stacked/stacked.dart';

enum AuthMethod { authenticator, sms }

/// Cold Ditto init + Firebase + business setup can exceed 3 minutes on desktop.
const Duration _kLoginPipelineTimeout = Duration(seconds: 300);

class PinLogin extends StatefulWidget {
  PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin>
    with CoreMiscellaneous, TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();

  bool _isProcessing = false;
  bool _isDone = false;
  bool _showPinDigits = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showOtpField = false;
  Pin? _localPin;

  AuthMethod _authMethod = AuthMethod.authenticator;
  final MfaProvider _mfa = const MfaProvider();
  Future<void>? _qrLoginTeardown;

  late AnimationController _fadeController;
  late AnimationController _shakeController;
  late AnimationController _errorBlinkController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeOffset;
  late Animation<double> _errorBlinkOpacity;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _pinFocusNode.addListener(_onFocusChange);
    _pinController.addListener(_onPinTextChanged);
    // Paint PIN UI first; join any in-flight QR teardown after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _qrLoginTeardown = locator<AppService>().beginQrLoginTeardown();
    });
    unawaited(_loadLocalAccount());
  }

  Future<void> _ensureQrLoginTeardownComplete() async {
    final pending =
        _qrLoginTeardown ?? locator<AppService>().beginQrLoginTeardown();
    try {
      await pending.timeout(const Duration(seconds: 2));
    } on TimeoutException {
      // PIN login can still dispose stale login-* identity during API auth.
    }
  }

  Never _loginPipelineTimedOut() => throw TimeoutException(
        'Sign-in timed out. Check your connection and try again.',
      );

  Future<T> _withLoginPipelineTimeout<T>(Future<T> future) => future.timeout(
        _kLoginPipelineTimeout,
        onTimeout: _loginPipelineTimedOut,
      );

  Future<void> _loadLocalAccount() async {
    try {
      final pin = await ProxyService.strategy.getPinLocal(
        alwaysHydrate: false,
      );
      if (mounted) setState(() => _localPin = pin);
    } catch (_) {
      // Account chip is optional when no local pin exists.
    }
  }

  void _onPinTextChanged() {
    _clearErrorOnKeypress();
    if (mounted) setState(() {});
    if (!_showOtpField &&
        !_isProcessing &&
        !_isDone &&
        _pinController.text.length == SignInTokens.pinCellCount) {
      // Wait for the hidden field / controller to settle before validating.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pinController.text.length == SignInTokens.pinCellCount) {
          unawaited(_handleLogin());
        }
      });
    }
  }

  void _clearErrorOnKeypress() {
    if (!_hasError) return;
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
  }

  int get _pinActiveIndex {
    final len = _pinController.text.length;
    if (len >= SignInTokens.pinCellCount) return -1;
    return len;
  }

  String get _successBusinessLabel {
    final owner = _localPin?.ownerName?.trim();
    if (owner != null && owner.isNotEmpty) return owner;
    return 'your business';
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _shakeController = AnimationController(
      duration: SignInMotion.shake,
      vsync: this,
    );

    _errorBlinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _shakeOffset = SignInMotion.pinShake(_shakeController);

    _errorBlinkOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.45), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.45, end: 1), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _errorBlinkController, curve: Curves.easeInOut),
    );
  }

  /// ANIMATIONS.md §1 — shake on PIN auth failure; blink only when reduced motion.
  void _playPinShake() {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    if (MediaQuery.disableAnimationsOf(context)) {
      _errorBlinkController.forward(from: 0);
      return;
    }
    _shakeController.forward(from: 0);
  }

  void _markSignInSuccess() {
    if (!mounted) return;
    setState(() => _isDone = true);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shakeController.dispose();
    _errorBlinkController.dispose();
    _pinFocusNode.dispose();
    _otpFocusNode.dispose();
    _pinController.removeListener(_onPinTextChanged);
    _pinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _focusPinEntry() {
    if (!_pinFocusNode.hasFocus) {
      _pinFocusNode.requestFocus();
    }
  }

  void _appendPinDigit(String digit) {
    if (_isProcessing || _isDone) return;
    if (_pinController.text.length >= SignInTokens.pinCellCount) return;
    _pinController.text = '${_pinController.text}$digit';
  }

  void _backspacePin() {
    if (_isProcessing || _isDone) return;
    final text = _pinController.text;
    if (text.isEmpty) return;
    _pinController.text = text.substring(0, text.length - 1);
  }

  /// PIN rules for the 6-cell UI (supports 4–6 digit PINs used in the field).
  String? _pinInputError(String pin) {
    if (pin.isEmpty) return 'PIN is required';
    if (pin.length < 4) return 'PIN must be at least 4 digits';
    if (pin.length > SignInTokens.pinCellCount) {
      return 'PIN must be at most ${SignInTokens.pinCellCount} digits';
    }
    return null;
  }

  String? _otpInputError(String otp, {required bool isAuthenticator}) {
    if (otp.isEmpty) {
      return isAuthenticator
          ? 'Authenticator code is required'
          : 'OTP is required';
    }
    if (otp.length != 6 || int.tryParse(otp) == null) {
      return isAuthenticator
          ? 'Authenticator code must be a 6-digit number.'
          : 'OTP must be a 6-digit number.';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_isProcessing || _isDone) return;

    final pin = _pinController.text;
    final pinError = _pinInputError(pin);
    if (pinError != null) {
      setState(() {
        _hasError = true;
        _errorMessage = pinError;
      });
      return;
    }

    if (_showOtpField) {
      final otpError = _otpInputError(
        _otpController.text,
        isAuthenticator: _authMethod == AuthMethod.authenticator,
      );
      if (otpError != null) {
        setState(() {
          _hasError = true;
          _errorMessage = otpError;
        });
        return;
      }
    }

    setState(() {
      _isProcessing = true;
      _hasError = false;
      _errorMessage = '';
    });

    HapticFeedback.lightImpact();

    try {
      await _ensureQrLoginTeardownComplete();

      if (_showOtpField) {
        final pinRecord = await _getPin();
        if (_authMethod == AuthMethod.authenticator) {
          final otpCode = _otpController.text;

          if (pinRecord == null) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Invalid PIN. Please re-enter and try again.';
            });
            _pinController.clear();
            _playPinShake();
            return;
          }

          final forceOffline = await _shouldForceOfflineLogin(pinRecord);
          final ok = await _withLoginPipelineTimeout(
            _mfa.validateTotpThenLogin(
              pin: pinRecord,
              code: otpCode,
              forceOffline: forceOffline,
            ),
          );
          if (!ok) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Invalid authenticator code. Please try again.';
            });
          } else {
            _markSignInSuccess();
          }
        } else {
          if (_otpController.text.isEmpty) {
            await _requestSmsOtp();
            return;
          }
          if (pinRecord == null) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Invalid PIN. Please re-enter and try again.';
            });
            _pinController.clear();
            _playPinShake();
            return;
          }
          await _withLoginPipelineTimeout(
            _mfa.verifySmsOtpThenLogin(
              otp: _otpController.text,
              pin: pinRecord,
            ),
          );
          _markSignInSuccess();
        }
      } else {
        if (_authMethod == AuthMethod.sms) {
          final pinRecord = await _getPin();
          if (pinRecord != null && await _shouldForceOfflineLogin(pinRecord)) {
            await _loginWithCachedPin(pinRecord, forceOffline: true);
            return;
          }
          final response =
              await _mfa.requestSmsOtp(pinString: _pinController.text);
          if (response['requiresOtp']) {
            setState(() {
              _showOtpField = true;
              _otpFocusNode.requestFocus();
            });
          } else if (pinRecord != null) {
            await _loginWithCachedPin(pinRecord, forceOffline: false);
          } else {
            setState(() {
              _hasError = true;
              _errorMessage = 'Invalid PIN. Please re-enter and try again.';
            });
            _pinController.clear();
            _playPinShake();
          }
        } else {
          final pinRecord = await _getPin();
          if (pinRecord == null) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Invalid PIN. Please re-enter and try again.';
            });
            _pinController.clear();
            _playPinShake();
            return;
          }
          // Cached PIN + offline: skip MFA (TOTP needs network) and force
          // offline auth from local Brick/Ditto tenant data.
          if (await _shouldForceOfflineLogin(pinRecord)) {
            await _loginWithCachedPin(pinRecord, forceOffline: true);
            return;
          }
          setState(() {
            _showOtpField = true;
            _otpFocusNode.requestFocus();
          });
        }
      }
    } catch (e, s) {
      if (e is LoginChoicesException) {
        await ProxyService.strategy.handleLoginError(e, s);
        return;
      }
      await _handleLoginError(e, s);
    } finally {
      if (mounted && !_isDone) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<IPin?> _getPin() async {
    return await ProxyService.strategy.getPin(
      pinString: _pinController.text,
      flipperHttpClient: ProxyService.http,
    );
  }

  /// True when there is no network and the entered PIN matches a local cache.
  Future<bool> _shouldForceOfflineLogin(IPin pinRecord) async {
    final online = await ProxyService.status.isInternetAvailable();
    if (online) return false;
    final entered = int.tryParse(_pinController.text);
    if (entered == null) return false;
    return pinRecord.pin == entered;
  }

  Future<void> _loginWithCachedPin(
    IPin pinRecord, {
    required bool forceOffline,
  }) async {
    _markSignInSuccess();
    await _withLoginPipelineTimeout(
      ProxyService.strategy.login(
        userPhone: pinRecord.phoneNumber,
        isInSignUpProgress: false,
        skipDefaultAppSetup: false,
        forceOffline: forceOffline,
        pin: Pin(
          userId: pinRecord.userId,
          pin: pinRecord.pin,
          businessId: pinRecord.businessId,
          branchId: pinRecord.branchId,
          ownerName: pinRecord.ownerName ?? '',
          phoneNumber: pinRecord.phoneNumber,
          tokenUid: pinRecord.tokenUid,
        ),
        flipperHttpClient: ProxyService.http,
      ),
    );
  }

  Future<void> _handleLoginError(dynamic e, StackTrace s) async {
    if (e is LoginChoicesException) {
      await ProxyService.strategy.handleLoginError(e, s);
      return;
    }

    String errorMessage;
    if (e is TimeoutException) {
      errorMessage = e.message?.isNotEmpty == true
          ? e.message!
          : 'Sign-in timed out. Check your connection and try again.';
    } else if (e is NeedSignUpException) {
      errorMessage = 'Account not found';
    } else {
      final errorDetails = await ProxyService.strategy.handleLoginError(e, s);
      errorMessage = (errorDetails['errorMessage'] as String?) ??
          'An unexpected error occurred.';
    }

    GlobalErrorHandler.logError(
      e,
      stackTrace: s,
      type: 'Pin Login Error',
      extra: {'error_type': e.runtimeType.toString()},
    );

    if (!mounted) return;

    setState(() {
      _hasError = true;
      _errorMessage = errorMessage.isNotEmpty
          ? errorMessage
          : 'That PIN doesn’t match. Try again.';
      _pinController.clear();
    });
    _playPinShake();
  }

  void _setAuthMethod(AuthMethod method) {
    if (_authMethod == method) return;
    setState(() {
      _authMethod = method;
      _hasError = false;
      _errorMessage = '';
      _otpController.clear();
    });
    if (method == AuthMethod.sms && _showOtpField) {
      _requestSmsOtp();
    }
  }

  Future<void> _requestSmsOtp() async {
    try {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
      final response = await _mfa.requestSmsOtp(pinString: _pinController.text);

      if (!mounted) return;

      if (response['requiresOtp'] == true) {
        setState(() => _showOtpField = true);
        _otpFocusNode.requestFocus();
      }
    } catch (e, s) {
      if (mounted) await _handleLoginError(e, s);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FLocalization.of(context).troubleSigningIn),
          content: Text(FLocalization.of(context).troubleSigningInHelp),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(FLocalization.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  bool _useSignInDesktopLayout(BoxConstraints constraints) {
    return constraints.maxWidth >= SignInTokens.desktopSplitBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Semantics(
          key: const Key(LoginMaestroIds.pinScreen),
          identifier: LoginMaestroIds.pinScreen,
          label: 'PIN login',
          child: Scaffold(
            key: const Key('PinLogin'),
            backgroundColor: SignInTokens.surface,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_useSignInDesktopLayout(constraints)) {
                    return _buildDesktopSignInLayout(constraints);
                  }
                  return _buildCompactSignInLayout(constraints);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopSignInLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildSignInLeftColumn(constraints, compact: false)),
        const Expanded(child: PinLoginBrandPanel()),
      ],
    );
  }

  Widget _buildCompactSignInLayout(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      child: _buildSignInLeftColumn(constraints, compact: true),
    );
  }

  Widget _buildSignInFormContent({required bool compact}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: SignInTokens.formMaxWidth,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome back',
                style: context.signInText(
                  fontSize: compact ? 32 : 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your PIN to manage your business securely.',
                style: context.signInText(
                  fontSize: compact ? 15 : 16,
                  height: 1.5,
                  color: SignInTokens.ink2,
                ),
              ),
              SizedBox(height: compact ? 28 : 36),
              _buildPinEntrySection(compact: compact),
              if (_showOtpField) ...[
                const SizedBox(height: 24),
                _buildMethodToggle(compact),
                const SizedBox(height: 16),
                _buildOtpField(compact),
              ],
              const SizedBox(height: 26),
              Semantics(
                key: const Key(LoginMaestroIds.pinSubmit),
                identifier: LoginMaestroIds.pinSubmit,
                label: _isDone
                    ? 'Signed in'
                    : (_isProcessing ? 'Verifying' : 'Sign in'),
                button: true,
                enabled: !_isProcessing && !_isDone,
                child: FlipperGradientButton(
                  key: const Key('pinLoginButton'),
                  text: _isDone
                      ? 'Signed in ✓'
                      : (_isProcessing ? 'Verifying…' : 'Sign in'),
                  icon: _isDone ? null : Icons.arrow_outward_rounded,
                  isLoading: false,
                  onPressed: (_isProcessing || _isDone) ? null : _handleLogin,
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Semantics(
                  key: const Key(LoginMaestroIds.pinHelp),
                  identifier: LoginMaestroIds.pinHelp,
                  label: 'Trouble signing in',
                  button: true,
                  enabled: true,
                  child: TextButton(
                    onPressed: _showHelpDialog,
                    child: Text(
                      'Trouble signing in?',
                      style: context.signInText(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SignInTokens.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLeftColumn(
    BoxConstraints constraints, {
    required bool compact,
  }) {
    final formContent = Center(
      child: _buildSignInFormContent(compact: compact),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : 48,
        vertical: compact ? 0 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SignInBrandHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, scrollConstraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: scrollConstraints.maxHeight,
                    ),
                    child: formContent,
                  ),
                );
              },
            ),
          ),
          if (!compact) const SignInBottomBar(),
        ],
      ),
    );
  }

  Widget _buildPinEntrySection({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'PIN',
              style: context.signInText(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SignInTokens.ink2,
              ),
            ),
            const Spacer(),
            Semantics(
              key: const Key(LoginMaestroIds.pinShowToggle),
              identifier: LoginMaestroIds.pinShowToggle,
              label: _showPinDigits ? 'Hide PIN' : 'Show PIN',
              button: true,
              enabled: true,
              child: TextButton.icon(
                onPressed: () {
                  setState(() => _showPinDigits = !_showPinDigits);
                  HapticFeedback.selectionClick();
                },
                icon: Icon(
                  _showPinDigits
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 15,
                  color: SignInTokens.ink3,
                ),
                label: Text(
                  _showPinDigits ? 'Hide' : 'Show',
                  style: context.signInText(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: SignInTokens.ink3,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildHiddenPinField(),
        AnimatedBuilder(
          animation: Listenable.merge([_shakeOffset, _errorBlinkOpacity]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeOffset.value, 0),
              child: child,
            );
          },
          child: SignInPinCells(
            pin: _pinController.text,
            showDigits: _showPinDigits,
            hasError: _hasError,
            activeIndex: _pinActiveIndex,
            pinFocused: _pinFocusNode.hasFocus,
            compact: compact,
            onTap: _focusPinEntry,
          ),
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: _hasError && MediaQuery.disableAnimationsOf(context)
              ? _errorBlinkOpacity
              : const AlwaysStoppedAnimation(1),
          child: SignInPinStatusLine(
            hasError: _hasError,
            isSuccess: _isDone,
            message: _errorMessage,
            successBusinessName: _successBusinessLabel,
          ),
        ),
        if (compact) ...[
          const SizedBox(height: 22),
          SignInPinKeypad(
            enabled: !_isProcessing && !_isDone,
            onDigit: _appendPinDigit,
            onBackspace: _backspacePin,
            onToggleShow: () =>
                setState(() => _showPinDigits = !_showPinDigits),
          ),
        ],
      ],
    );
  }

  Widget _buildHiddenPinField() {
    return Opacity(
      opacity: 0,
      child: SizedBox(
        height: 0,
        child: Semantics(
          key: const Key(LoginMaestroIds.pinField),
          identifier: LoginMaestroIds.pinField,
          label: 'PIN',
          textField: true,
          enabled: !_isProcessing && !_isDone,
          value: '${_pinController.text.length} digits entered',
          child: TextFormField(
            key: const Key('pinField'),
            controller: _pinController,
            focusNode: _pinFocusNode,
            autofocus: true,
            enabled: !_isProcessing && !_isDone,
            keyboardType: TextInputType.number,
            textInputAction:
                _showOtpField ? TextInputAction.next : TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(SignInTokens.pinCellCount),
            ],
            onFieldSubmitted: (_) =>
                _showOtpField ? _otpFocusNode.requestFocus() : _handleLogin(),
            style: const TextStyle(fontSize: 1, height: 0),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            validator: (text) => _pinInputError(text ?? ''),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodToggle(bool compact) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SignInTokens.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SignInTokens.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleItem(
              'Authenticator',
              AuthMethod.authenticator,
              compact,
            ),
          ),
          Expanded(
            child: _buildToggleItem('SMS', AuthMethod.sms, compact),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, AuthMethod method, bool compact) {
    final isSelected = _authMethod == method;
    final semanticId = method == AuthMethod.authenticator
        ? LoginMaestroIds.authAuthenticator
        : LoginMaestroIds.authSms;

    return Semantics(
      key: Key(semanticId),
      identifier: semanticId,
      label: label,
      button: true,
      selected: isSelected,
      enabled: true,
      child: GestureDetector(
        onTap: () => _setAuthMethod(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? SignInTokens.surface : Colors.transparent,
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
            style: context.signInText(
              fontSize: compact ? 12 : 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? SignInTokens.ink1 : SignInTokens.ink3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(bool compact) {
    final isAuthenticator = _authMethod == AuthMethod.authenticator;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAuthenticator ? 'Authenticator Code' : 'SMS Code',
          style: context.signInText(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: SignInTokens.ink2,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          key: const Key(LoginMaestroIds.otpField),
          identifier: LoginMaestroIds.otpField,
          label: isAuthenticator ? 'Authenticator code' : 'SMS code',
          textField: true,
          enabled: true,
          child: TextFormField(
            key: const Key('otpField'),
            controller: _otpController,
            focusNode: _otpFocusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            style: context.signInPinDigit(fontSize: compact ? 16 : 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: SignInTokens.surface2,
              hintText: '000000',
              hintStyle: context
                  .signInPinDigit(fontSize: compact ? 16 : 18)
                  .copyWith(color: SignInTokens.ink3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
                borderSide: BorderSide(
                  color: _hasError ? SignInTokens.danger : SignInTokens.blue,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: compact ? 14 : 18,
              ),
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return isAuthenticator
                    ? 'Authenticator code is required'
                    : 'OTP is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
