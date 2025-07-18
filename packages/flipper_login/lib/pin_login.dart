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

    // Start entrance animations
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

  // Method to handle PIN login and its associated flow
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
        _hasError = false;
      });

      // Haptic feedback
      HapticFeedback.lightImpact();

      try {
        await ProxyService.box.writeBool(key: 'pinLogin', value: true);

        final pin = await _getPin();
        if (pin == null) throw PinError(term: "Not found");

        // Update local authentication
        await ProxyService.box.writeBool(key: 'isAnonymous', value: true);

        // Check if a PIN with this userId already exists in the local database
        final userId = int.tryParse(pin.userId);
        final existingPin = await ProxyService.strategy
            .getPinLocal(userId: userId!, alwaysHydrate: false);

        Pin thePin;
        if (existingPin != null) {
          // Update the existing PIN instead of creating a new one
          thePin = existingPin;

          // Update fields with the latest information
          thePin.phoneNumber = pin.phoneNumber;
          thePin.branchId = pin.branchId;
          thePin.businessId = pin.businessId;
          thePin.ownerName = pin.ownerName;

          print(
              "Using existing PIN with userId: ${pin.userId}, ID: ${thePin.id}");
        } else {
          // Create a new PIN if none exists
          thePin = Pin(
            userId: userId,
            pin: userId,
            branchId: pin.branchId,
            businessId: pin.businessId,
            ownerName: pin.ownerName,
            phoneNumber: pin.phoneNumber,
          );
          print("Creating new PIN with userId: ${pin.userId}");
        }

        await ProxyService.strategy.login(
          pin: thePin,
          isInSignUpProgress: false,
          flipperHttpClient: ProxyService.http,
          skipDefaultAppSetup: false,
          userPhone: pin.phoneNumber,
        );
        await ProxyService.strategy.completeLogin(thePin);

        // Success haptic feedback
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

  // Get PIN from local service
  Future<IPin?> _getPin() async {
    return await ProxyService.strategy.getPin(
      pinString: _pinController.text,
      flipperHttpClient: ProxyService.http,
    );
  }

  // Error handling for login
  Future<void> _handleLoginError(dynamic e, StackTrace s) async {
    // Trigger shake animation
    _shakeController.reset();
    _shakeController.forward();

    // Error haptic feedback
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

  // Toggles the PIN visibility
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

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: Key('PinLogin'),
          backgroundColor: isDark ? Color(0xFF1a1a1a) : Color(0xFFF8F9FA),
          body: SafeArea(
            child: Column(
              children: [
                // Modern app bar with back button
                _buildAppBar(context, isDark),

                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: _buildLoginCard(context, model, isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(
      BuildContext context, LoginViewModel model, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 480.0
        : (screenWidth > 800 ? 400.0 : double.infinity);

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 8 * (1 - _shakeAnimation.value),
            0,
          ),
          child: Container(
            width: cardWidth,
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(40),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(isDark),
                  SizedBox(height: 40),
                  _buildPinField(isDark),
                  if (_hasError) ...[
                    SizedBox(height: 16),
                    _buildErrorMessage(isDark),
                  ],
                  SizedBox(height: 40),
                  _buildLoginButton(model, isDark),
                  SizedBox(height: 24),
                  _buildHelpText(isDark),
                  SizedBox(height: 16),
                  _buildSecurityNote(isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4285F4),
                    Color(0xFF34A853),
                  ],
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
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Access',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your data is protected',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Color(0xFF1a1a1a),
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Enter your PIN to access your account securely',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white70 : Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPinField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PIN',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF374151),
          ),
        ),
        SizedBox(height: 10),
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
              fontSize: 16,
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
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF4285F4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.pin_outlined,
                  color: Color(0xFF4285F4),
                  size: 20,
                ),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.white54 : Color(0xFF6B7280),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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

  Widget _buildLoginButton(LoginViewModel model, bool isDark) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFF1976D2),
          ],
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
            padding: EdgeInsets.symmetric(vertical: 16),
            child: _isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Signing in...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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

  Widget _buildHelpText(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            // Handle forgot PIN
          },
          icon: Icon(
            Icons.help_outline,
            size: 18,
            color: Color(0xFF4285F4),
          ),
          label: Text(
            'Forgot PIN?',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontSize: 14,
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
            size: 18,
            color: isDark ? Colors.white60 : Color(0xFF6B7280),
          ),
          label: Text(
            'Need help?',
            style: TextStyle(
              color: isDark ? Colors.white60 : Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16),
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
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your PIN is encrypted and stored securely. We never share your data.',
              style: TextStyle(
                color: isDark ? Colors.white70 : Color(0xFF065F46),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
