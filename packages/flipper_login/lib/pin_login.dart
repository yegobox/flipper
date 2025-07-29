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
  final FocusNode _pinFocusNode = FocusNode();

  bool _isProcessing = false;
  bool _isObscure = true;
  bool _hasError = false;
  String _errorMessage = '';

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
        await ProxyService.box.writeBool(key: 'pinLogin', value: true);

        final pin = await _getPin();
        if (pin == null) throw PinError(term: "Not found");

        await ProxyService.box.writeBool(key: 'isAnonymous', value: true);

        final userId = int.tryParse(pin.userId);
        final existingPin = await ProxyService.strategy
            .getPinLocal(userId: userId!, alwaysHydrate: false);

        Pin thePin;
        if (existingPin != null) {
          thePin = existingPin;
          thePin.phoneNumber = pin.phoneNumber;
          thePin.branchId = pin.branchId;
          thePin.businessId = pin.businessId;
          thePin.ownerName = pin.ownerName;
        } else {
          thePin = Pin(
            userId: userId,
            pin: userId,
            branchId: pin.branchId,
            businessId: pin.businessId,
            ownerName: pin.ownerName,
            phoneNumber: pin.phoneNumber,
          );
        }

        await ProxyService.strategy.login(
          pin: thePin,
          isInSignUpProgress: false,
          flipperHttpClient: ProxyService.http,
          skipDefaultAppSetup: false,
          userPhone: pin.phoneNumber,
        );
        await ProxyService.strategy.completeLogin(thePin);

        HapticFeedback.mediumImpact();
      } catch (e, s) {
        await _handleLoginError(e, s);
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
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
          : 'Invalid PIN. Please try again.';
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
                    screenWidth < 400 ? EdgeInsets.all(24) : EdgeInsets.all(40);

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
                            minHeight: constraints.maxHeight - 100,
                          ),
                          child: IntrinsicHeight(
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
        ? EdgeInsets.symmetric(horizontal: 12)
        : EdgeInsets.symmetric(horizontal: 24);

    return Container(
      width: cardWidth,
      margin: cardMargin,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Color(0xFF3a3a3a) : Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: Offset(0, 16),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 4),
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
            SizedBox(height: screenHeight < 600 ? 24 : 40),
            _buildPinField(isDark, screenHeight),
            if (_hasError) ...[
              SizedBox(height: screenHeight < 600 ? 12 : 16),
              _buildErrorMessage(isDark),
            ],
            SizedBox(height: screenHeight < 600 ? 24 : 40),
            _buildLoginButton(model, isDark, screenHeight),
            SizedBox(height: screenHeight < 600 ? 16 : 24),
            _buildHelpText(isDark, screenHeight),
            SizedBox(height: screenHeight < 600 ? 12 : 16),
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
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4285F4).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_person_outlined,
                color: Colors.white,
                size: isSmallScreen ? 24 : 32,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Access',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your data is protected',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: isDark ? Colors.white60 : Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 16 : 32),
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 32,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Color(0xFF1a1a1a),
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Text(
          'Enter your PIN to access your account securely',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: isDark ? Colors.white70 : Color(0xFF6B7280),
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
            fontSize: isSmallScreen ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF374151),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Color(0xFF000000).withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: TextFormField(
            controller: _pinController,
            focusNode: _pinFocusNode,
            obscureText: _isObscure,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            style: TextStyle(
              fontSize: isSmallScreen ? 15 : 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Color(0xFF1a1a1a),
              letterSpacing: _isObscure ? 4 : 0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Color(0xFF3a3a3a) : Color(0xFFF8F9FB),
              hintText: 'Enter your PIN',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Color(0xFF9CA3AF),
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Color(0xFF4285F4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.pin_outlined,
                  color: Color(0xFF4285F4),
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.only(right: isSmallScreen ? 4 : 8),
                child: IconButton(
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.white54 : Color(0xFF6B7280),
                    size: isSmallScreen ? 20 : 24,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _hasError
                      ? Color(0xFFEF4444)
                      : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _hasError
                      ? Color(0xFFEF4444)
                      : (isDark ? Color(0xFF4a4a4a) : Color(0xFFE5E7EB)),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _hasError ? Color(0xFFEF4444) : Color(0xFF4285F4),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
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
        ),
      ],
    );
  }

  Widget _buildErrorMessage(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(0xFFEF4444),
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 14,
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
      height: isSmallScreen ? 48 : 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4285F4).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : _handleLogin,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
            child: _isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: isSmallScreen ? 16 : 20,
                        width: isSmallScreen ? 16 : 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Text(
                        'Signing in...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
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
                        size: isSmallScreen ? 18 : 20,
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Text(
                        'Sign In',
                        key: Key('signInButtonText'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
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
            size: isSmallScreen ? 16 : 18,
            color: Color(0xFF4285F4),
          ),
          label: Text(
            'Forgot PIN?',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontSize: isSmallScreen ? 12 : 14,
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
            size: isSmallScreen ? 16 : 18,
            color: isDark ? Colors.white60 : Color(0xFF6B7280),
          ),
          label: Text(
            'Need help?',
            style: TextStyle(
              color: isDark ? Colors.white60 : Color(0xFF6B7280),
              fontSize: isSmallScreen ? 12 : 14,
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
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark
            ? Color(0xFF1a4d3a).withValues(alpha: 0.3)
            : Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
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
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Text(
              'Your PIN is encrypted and stored securely. We never share your data.',
              style: TextStyle(
                color: isDark ? Colors.white70 : Color(0xFF065F46),
                fontSize: isSmallScreen ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
