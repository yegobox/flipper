import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_login/mfa_provider.dart';

enum AuthMethod { authenticator, sms }

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
  bool _isObscure = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showOtpField = false;
  AuthMethod _authMethod = AuthMethod.authenticator;
  final MfaProvider _mfa = const MfaProvider();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _shakeController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _pinFocusNode.addListener(_onFocusChange);
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  void _onFocusChange() {
    if (_hasError && _pinFocusNode.hasFocus) {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _shakeController.dispose();
    _pinFocusNode.dispose();
    _otpFocusNode.dispose();
    _pinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
        _hasError = false;
      });

      HapticFeedback.lightImpact();

      try {
        if (_showOtpField) {
          final pin = await _getPin();
          if (_authMethod == AuthMethod.authenticator) {
            final otpCode = _otpController.text;
            if (otpCode.length != 6 || int.tryParse(otpCode) == null) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Authenticator code must be a 6-digit number.';
              });
              return;
            }

            if (pin == null) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Invalid PIN. Please re-enter and try again.';
              });
              return;
            }

            final ok = await _mfa.validateTotpThenLogin(
              pin: pin,
              code: otpCode,
            );
            if (!ok) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Invalid authenticator code. Please try again.';
              });
            }
          } else {
            // SMS selected while already at OTP stage
            if (_otpController.text.isEmpty) {
              // Ensure an SMS is sent, keep OTP visible
              await _requestSmsOtp();
              return;
            }
            if (pin == null) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Invalid PIN. Please re-enter and try again.';
              });
              return;
            }
            await _mfa.verifySmsOtpThenLogin(
                otp: _otpController.text, pin: pin);
          }
        } else {
          if (_authMethod == AuthMethod.sms) {
            final response =
                await _mfa.requestSmsOtp(pinString: _pinController.text);
            if (response['requiresOtp']) {
              setState(() {
                _showOtpField = true;
                _otpFocusNode.requestFocus();
              });
            } else {
              // No OTP required: proceed to login directly using the PIN details
              final pin = await _getPin();
              if (pin != null) {
                await ProxyService.strategy.login(
                  userPhone: pin.phoneNumber,
                  isInSignUpProgress: false,
                  skipDefaultAppSetup: false,
                  pin: Pin(
                    userId: pin.userId,
                    pin: pin.pin,
                    businessId: pin.businessId,
                    branchId: pin.branchId,
                    ownerName: pin.ownerName ?? '',
                    phoneNumber: pin.phoneNumber,
                  ),
                  flipperHttpClient: ProxyService.http,
                );
              }
            }
          } else {
            // Authenticator selected: show OTP field without requesting SMS
            // Validate PIN exists before proceeding
            await _getPin();
            setState(() {
              _showOtpField = true;
              _otpFocusNode.requestFocus();
            });
          }
        }
      } catch (e, s) {
        await _handleLoginError(e, s);
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    } else {
      _shakeController.reset();
      _shakeController.forward();
      HapticFeedback.heavyImpact();
    }
  }

  Future<IPin?> _getPin() async {
    return await ProxyService.strategy.getPin(
      pinString: _pinController.text,
      flipperHttpClient: ProxyService.http,
    );
  }

  Future<void> _handleLoginError(dynamic e, StackTrace s) async {
    _shakeController.reset();
    _shakeController.forward();

    HapticFeedback.heavyImpact();

    String errorMessage;
    if (e is NeedSignUpException) {
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
      extra: {
        'error_type': e.runtimeType.toString(),
      },
    );

    if (!mounted) return;

    setState(() {
      _hasError = true;
      _errorMessage = errorMessage.isNotEmpty
          ? errorMessage
          : 'Invalid PIN or OTP. Please try again.';
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
    HapticFeedback.selectionClick();
  }

  void _setAuthMethod(AuthMethod method) {
    if (_authMethod == method) return;
    setState(() {
      _authMethod = method;
      _hasError = false;
      _errorMessage = '';
      // Keep OTP stage if already shown; just clear current code
      _otpController.clear();
    });
    // If switching to SMS while already in OTP stage, request an SMS code immediately
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
        setState(() {
          _showOtpField = true;
        });
        _otpFocusNode.requestFocus();
      }
    } catch (e, s) {
      if (mounted) {
        await _handleLoginError(e, s);
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Trouble Signing In?'),
          content: const Text(
            'If you are having trouble signing in, please ensure your PIN and OTP (if applicable) are correct.\n\nFor further assistance, please contact support.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: Key('PinLogin'),
          backgroundColor: isDark ? Color(0xFF1a1a1a) : Colors.white,
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentPadding = screenHeight < 600
                    ? EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                    : EdgeInsets.symmetric(horizontal: 32, vertical: 32);

                final cardWidth = screenWidth > 800 ? 400.0 : double.infinity;

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: contentPadding,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - contentPadding.vertical,
                    ),
                    child: Container(
                      width: cardWidth,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: AnimatedBuilder(
                                  animation: _shakeAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        _shakeAnimation.value *
                                            8 *
                                            (1 - _shakeAnimation.value),
                                        0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildWelcomeSection(
                                              isDark, screenHeight),
                                          SizedBox(
                                              height:
                                                  screenHeight < 600 ? 32 : 56),
                                          _buildPinField(isDark, screenHeight),
                                          if (_showOtpField) ...[
                                            SizedBox(
                                                height: screenHeight < 600
                                                    ? 16
                                                    : 24),
                                            _buildMethodToggle(
                                                isDark, screenHeight),
                                            SizedBox(
                                                height: screenHeight < 600
                                                    ? 16
                                                    : 24),
                                            _buildOtpField(
                                                isDark, screenHeight),
                                          ],
                                          if (_hasError) ...[
                                            SizedBox(
                                                height: screenHeight < 600
                                                    ? 12
                                                    : 16),
                                            _buildErrorMessage(isDark),
                                          ],
                                          SizedBox(
                                              height:
                                                  screenHeight < 600 ? 32 : 48),
                                          _buildLoginButton(
                                              model, isDark, screenHeight),
                                          SizedBox(
                                              height:
                                                  screenHeight < 600 ? 16 : 24),
                                          _buildHelpText(isDark, screenHeight),
                                          SizedBox(
                                              height:
                                                  screenHeight < 600 ? 24 : 40),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: isSmallScreen ? 32 : 40,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Color(0xFF111827),
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Text(
          'Manage your business securely.',
          style: TextStyle(
            fontSize: isSmallScreen ? 15 : 17,
            color: isDark ? Colors.white60 : Color(0xFF4B5563),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPinField(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PIN',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Color(0xFF374151),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 10),
        TextFormField(
          key: Key('pinField'),
          controller: _pinController,
          focusNode: _pinFocusNode,
          obscureText: _isObscure,
          keyboardType: TextInputType.number,
          textInputAction:
              _showOtpField ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) =>
              _showOtpField ? _otpFocusNode.requestFocus() : _handleLogin(),
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF111827),
            letterSpacing: _isObscure ? 4 : 1,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF2d2d2d) : Color(0xFFF9FAFB),
            hintText: '••••',
            hintStyle: TextStyle(
              color: isDark ? Colors.white24 : Color(0xFF9CA3AF),
              letterSpacing: 4,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: isDark ? Colors.white54 : Color(0xFF6B7280),
                size: isSmallScreen ? 20 : 22,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _hasError ? Color(0xFFEF4444) : Color(0xFF4285F4),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: isSmallScreen ? 14 : 18,
            ),
          ),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "PIN is required";
            }
            if (text.length < 4) {
              return "PIN must be at least 4 digits";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOtpField(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;
    final isAuthenticator = _authMethod == AuthMethod.authenticator;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAuthenticator ? 'Authenticator Code' : 'SMS Code',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Color(0xFF374151),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 10),
        TextFormField(
          key: Key('otpField'),
          controller: _otpController,
          focusNode: _otpFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleLogin(),
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF111827),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF2d2d2d) : Color(0xFFF9FAFB),
            hintText: '000000',
            hintStyle: TextStyle(
              color: isDark ? Colors.white24 : Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _hasError ? Color(0xFFEF4444) : Color(0xFF4285F4),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: isSmallScreen ? 14 : 18,
            ),
          ),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return isAuthenticator
                  ? "Authenticator code is required"
                  : "OTP is required";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMethodToggle(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2d2d2d) : Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleItem(
              'Authenticator',
              AuthMethod.authenticator,
              isDark,
              isSmallScreen,
            ),
          ),
          Expanded(
            child: _buildToggleItem(
              'SMS',
              AuthMethod.sms,
              isDark,
              isSmallScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    String label,
    AuthMethod method,
    bool isDark,
    bool isSmallScreen,
  ) {
    final isSelected = _authMethod == method;
    return GestureDetector(
      onTap: () => _setAuthMethod(method),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Color(0xFF4285F4) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? (isDark ? Colors.white : Color(0xFF111827))
                : (isDark ? Colors.white38 : Color(0xFF6B7280)),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFEE2E2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Color(0xFF991B1B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(
      LoginViewModel model, bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Container(
      width: double.infinity,
      height: isSmallScreen ? 50 : 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4285F4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isProcessing
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Sign In',
                key: Key('signInButtonText'),
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildHelpText(bool isDark, double screenHeight) {
    return Center(
      child: TextButton(
        onPressed: _showHelpDialog,
        child: Text(
          'Trouble signing in?',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
