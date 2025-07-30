import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

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
          await ProxyService.strategy
              .verifyOtpAndLogin(_otpController.text, pin: pin);
        } else {
          final response =
              await ProxyService.strategy.requestOtp(_pinController.text);
          if (response['requiresOtp']) {
            setState(() {
              _showOtpField = true;
              _otpFocusNode.requestFocus();
            });
          } else {
            // Handle login without OTP
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
      // Trigger shake animation on validation failure
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

    final errorDetails = await ProxyService.strategy.handleLoginError(e, s);
    final String errorMessage = errorDetails['errorMessage'];

    GlobalErrorHandler.logError(
      e,
      stackTrace: s,
      type: 'Pin Login Error',
      extra: {
        'error_type': e.runtimeType.toString(),
      },
    );

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
          backgroundColor: isDark ? Color(0xFF1a1a1a) : Color(0xFFF8F9FA),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Adjust padding based on screen size
                final contentPadding = screenHeight < 600
                    ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    : EdgeInsets.symmetric(horizontal: 24, vertical: 16);

                // Adjust card padding based on screen size
                final cardPadding =
                    screenWidth < 400 ? EdgeInsets.all(16) : EdgeInsets.all(24);

                return Column(
                  children: [
                    // App bar with back button
                    _buildAppBar(context, isDark, screenHeight),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: contentPadding,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight -
                                contentPadding.vertical -
                                60, // Adjust for app bar
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                        child: _buildLoginCard(
                                          context,
                                          model,
                                          isDark,
                                          cardPadding,
                                          screenWidth,
                                          screenHeight,
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
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark, double screenHeight) {
    return Container(
      height: screenHeight < 600 ? 48 : 60,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: screenHeight < 600 ? 20 : 24,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: screenHeight < 600 ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(
    BuildContext context,
    LoginViewModel model,
    bool isDark,
    EdgeInsets cardPadding,
    double screenWidth,
    double screenHeight,
  ) {
    // Adjust card width and margins based on screen size
    final cardWidth = screenWidth > 1200
        ? 480.0
        : (screenWidth > 800 ? 400.0 : double.infinity);

    final cardMargin = screenWidth < 400
        ? EdgeInsets.symmetric(horizontal: 8)
        : EdgeInsets.symmetric(horizontal: 16);

    return Container(
      width: cardWidth,
      margin: cardMargin,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Color(0xFF3a3a3a) : Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(isDark, screenHeight),
            SizedBox(height: screenHeight < 600 ? 16 : 24),
            _buildPinField(isDark, screenHeight),
            if (_showOtpField) ...[
              SizedBox(height: screenHeight < 600 ? 12 : 16),
              _buildOtpField(isDark, screenHeight),
            ],
            if (_hasError) ...[
              SizedBox(height: screenHeight < 600 ? 8 : 12),
              _buildErrorMessage(isDark),
            ],
            SizedBox(height: screenHeight < 600 ? 16 : 24),
            _buildLoginButton(model, isDark, screenHeight),
            SizedBox(height: screenHeight < 600 ? 12 : 16),
            _buildHelpText(isDark, screenHeight),
            SizedBox(height: screenHeight < 600 ? 8 : 12),
            _buildSecurityNote(isDark, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4285F4).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_person_outlined,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Access',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your data is protected',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: isDark ? Colors.white60 : Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Color(0xFF1a1a1a),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          'Enter your PIN to access your account securely',
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: isDark ? Colors.white70 : Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
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
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF374151),
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        TextFormField(
          controller: _pinController,
          focusNode: _pinFocusNode,
          obscureText: _isObscure,
          keyboardType: TextInputType.number,
          textInputAction:
              _showOtpField ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) =>
              _showOtpField ? _otpFocusNode.requestFocus() : _handleLogin(),
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 15,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Color(0xFF1a1a1a),
            letterSpacing: _isObscure ? 3 : 0,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF3a3a3a) : Color(0xFFF8F9FB),
            hintText: 'Enter your PIN',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(isSmallScreen ? 6 : 8),
              padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
              decoration: BoxDecoration(
                color: Color(0xFF4285F4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.pin_outlined,
                color: Color(0xFF4285F4),
                size: isSmallScreen ? 16 : 18,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: isDark ? Colors.white54 : Color(0xFF6B7280),
                size: isSmallScreen ? 18 : 20,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError
                    ? Color(0xFFEF4444)
                    : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError
                    ? Color(0xFFEF4444)
                    : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError ? Color(0xFFEF4444) : Color(0xFF4285F4),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 12 : 14,
            ),
            errorStyle: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              height: 1.2,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTP',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF374151),
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        TextFormField(
          controller: _otpController,
          focusNode: _otpFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleLogin(),
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 15,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Color(0xFF1a1a1a),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF3a3a3a) : Color(0xFFF8F9FB),
            hintText: 'Enter your OTP',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(isSmallScreen ? 6 : 8),
              padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
              decoration: BoxDecoration(
                color: Color(0xFF4285F4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.sms_outlined,
                color: Color(0xFF4285F4),
                size: isSmallScreen ? 16 : 18,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError
                    ? Color(0xFFEF4444)
                    : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError
                    ? Color(0xFFEF4444)
                    : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError ? Color(0xFFEF4444) : Color(0xFF4285F4),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 12 : 14,
            ),
            errorStyle: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              height: 1.2,
            ),
          ),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "OTP is required";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildErrorMessage(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(0xFFEF4444),
            size: 16,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 12,
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
      height: isSmallScreen ? 44 : 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4285F4).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : _handleLogin,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
            child: _isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: isSmallScreen ? 14 : 16,
                        width: isSmallScreen ? 14 : 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Text(
                        'Signing in...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_open_outlined,
                        color: Colors.white,
                        size: isSmallScreen ? 16 : 18,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Text(
                        'Sign In',
                        key: Key('signInButtonText'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpText(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            // Handle forgot PIN
          },
          icon: Icon(
            Icons.help_outline,
            size: isSmallScreen ? 14 : 16,
            color: Color(0xFF4285F4),
          ),
          label: Text(
            'Forgot PIN?',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontSize: isSmallScreen ? 11 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            // Handle contact support
          },
          icon: Icon(
            Icons.support_agent_outlined,
            size: isSmallScreen ? 14 : 16,
            color: isDark ? Colors.white60 : Color(0xFF6B7280),
          ),
          label: Text(
            'Need help?',
            style: TextStyle(
              color: isDark ? Colors.white60 : Color(0xFF6B7280),
              fontSize: isSmallScreen ? 11 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote(bool isDark, double screenHeight) {
    final isSmallScreen = screenHeight < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: isDark
            ? Color(0xFF10B981).withValues(alpha: 0.2)
            : Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Color(0xFF10B981).withValues(alpha: 0.3)
              : Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF10B981),
            size: isSmallScreen ? 16 : 18,
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Expanded(
            child: Text(
              'Your PIN is encrypted and stored securely.',
              style: TextStyle(
                color: isDark ? Colors.white70 : Color(0xFF065F46),
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
