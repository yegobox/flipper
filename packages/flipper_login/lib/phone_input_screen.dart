import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_login/LoadingDialog.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_ui/flipper_ui.dart';
import 'dart:io';

import 'internal/responsive_page.dart' as b;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class PhoneInputScreen extends StatefulWidget {
  final AuthAction? action;
  final String countryCode;
  final List<FirebaseUIAction>? actions;
  final FirebaseAuth? auth;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder? footerBuilder;
  final HeaderBuilder? headerBuilder;
  final double? headerMaxExtent;
  final SideBuilder? sideBuilder;
  final TextDirection? desktopLayoutDirection;
  final double breakpoint;
  final MultiFactorSession? multiFactorSession;
  final PhoneMultiFactorInfo? mfaHint;

  const PhoneInputScreen({
    Key? key,
    this.action,
    this.actions,
    this.auth,
    required this.countryCode,
    this.subtitleBuilder,
    this.footerBuilder,
    this.headerBuilder,
    this.headerMaxExtent,
    this.sideBuilder,
    this.desktopLayoutDirection,
    this.breakpoint = 500,
    this.multiFactorSession,
    this.mfaHint,
  }) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _smsCode = '';
  String _selectedCountryCode = '';

  bool _isLoading = false;
  bool _showVerificationUI = false;
  Object flowKey = Object();
  String? _verificationId;
  int? _resendToken;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // For countdown timer
  int _timerSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.countryCode;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _timerSeconds = 60;
      _canResend = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
        if (_timerSeconds > 0) {
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  Future<void> _verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });
    if (_selectedCountryCode == 'RW') {
      setState(() {
        _selectedCountryCode = '+250';
      });
    }
    final fullPhoneNumber = _selectedCountryCode +
        phoneNumber; // Combine country code and phone number

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            _isLoading = false;
          });
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar(context,
              'Verification failed: ${e.message ?? "An unknown error occurred"}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
            _resendToken = resendToken;
            _showVerificationUI = true;
          });
          _animationController.forward();
          _startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(context, 'An error occurred: ${e.toString()}');
    }
  }

  Future<void> _resendCode(BuildContext context) async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    final fullPhoneNumber = _selectedCountryCode +
        _phoneController.text; // Combine country code and phone number

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            _isLoading = false;
          });
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar(context,
              'Verification failed: ${e.message ?? "An unknown error occurred"}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
            _resendToken = resendToken;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification code resent'),
              backgroundColor: Colors.green,
            ),
          );
          _startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(context, 'An error occurred: ${e.toString()}');
    }
  }

  Future<void> _verifyCode() async {
    if (_smsCode.length < 6) {
      _showErrorSnackBar(context, 'Please enter a valid 6-digit code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential =
          firebase_auth.PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCode,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar(context, 'Failed to verify code: ${e.toString()}');
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      // Show Loading Dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing by tapping outside
        builder: (BuildContext context) {
          return const LoadingDialog(message: 'Finalizing authentication...');
        },
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => _isLoading = false);

      // Dismiss Loading Dialog
      Navigator.of(context, rootNavigator: true).pop();

      if (user.user != null) {
        // Show success and navigate
        if (mounted) {}
      }
    } catch (e) {
      // Dismiss Loading Dialog in case of error
      if (Navigator.canPop(context)) {
        // Add this check!
        Navigator.of(context, rootNavigator: true).pop();
      }
      setState(() => _isLoading = false);
      _showErrorSnackBar(context, 'Authentication failed: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{8,15}$')
        .hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Handles user authentication state changes and login flow
  /// This is only needed for non-Windows platforms
  Future<void> handleAuthStateChanges(LoginViewModel model) async {
    if (Platform.isWindows) return;

    firebase.FirebaseAuth.instance.authStateChanges().listen((user) async {
      /// bellow steps is done in @login file so doing it here is redundant
      // if (user == null) return;

      // final bool shouldProcessLogin = !await ProxyService.box.pinLogin()! &&
      //     !await ProxyService.box.authComplete();

      // if (!shouldProcessLogin) return;

      // try {
      //   final userPin = await model.processUserLogin(user);
      //   await model.completeLoginProcess(userPin, model);
      // } catch (e, s) {
      //   model.handleLoginError(e, s);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = FirebaseUILocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ViewModelBuilder<LoginViewModel>.reactive(
      onViewModelReady: (model) => handleAuthStateChanges(model),
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_ios_new,
                    size: 16, color: colorScheme.primary),
              ),
              onPressed: () {
                if (_showVerificationUI) {
                  setState(() {
                    _showVerificationUI = false;
                    _animationController.reverse();
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: FirebaseUIActions(
            actions: widget.actions ?? [],
            child: b.ResponsivePage(
              desktopLayoutDirection: widget.desktopLayoutDirection,
              sideBuilder: widget.sideBuilder,
              headerBuilder: widget.headerBuilder,
              headerMaxExtent: widget.headerMaxExtent,
              breakpoint: widget.breakpoint,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showVerificationUI
                          ? _buildVerificationUI(context, colorScheme)
                          : _buildPhoneInputUI(context, l, colorScheme),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneInputUI(BuildContext context, FirebaseUILocalizations l,
      ColorScheme colorScheme) {
    return Column(
      key: const ValueKey('phone_input'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo or illustration
        Container(
          height: 120,
          alignment: Alignment.center,
          child: Image.asset(
            package: 'flipper_login',
            'assets/flipper_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.phone_android,
              size: 80,
              color: colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Title
        Text(
          'Phone Verification',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'We\'ll send a verification code to your phone number to verify your identity.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),

        if (widget.subtitleBuilder != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              child: widget.subtitleBuilder!(context),
            ),
          ),

        const SizedBox(height: 40),

        // Phone Input
        Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Country code picker
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CountryCodePicker(
                        onChanged: (CountryCode code) {
                          setState(() {
                            _selectedCountryCode = code.dialCode ?? '';
                          });
                        },
                        initialSelection:
                            widget.countryCode.replaceAll('+', ''),
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        padding: EdgeInsets.zero,
                        flagWidth: 30,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Vertical divider
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),

                    // Phone number field
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: '123 456 7890',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.withOpacity(0.5),
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Continue Button
        SizedBox(
          height: 56,
          child: FlipperButton(
            text: _isLoading ? 'Sending code...' : 'Continue',
            textColor: Colors.white,
            color: colorScheme.primary,
            onPressed: _isLoading
                ? null
                : () => _verifyPhoneNumber(context, _phoneController.text),
            isLoading: _isLoading,
          ),
        ),

        const SizedBox(height: 24),

        // Terms and conditions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'By continuing, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Terms of Service
                    },
                ),
                const TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Privacy Policy
                    },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        if (widget.footerBuilder != null) widget.footerBuilder!(context),
      ],
    );
  }

  Widget _buildVerificationUI(BuildContext context, ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        key: const ValueKey('verification_ui'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration
          Container(
            height: 120,
            alignment: Alignment.center,
            child: Image.asset(
              package: 'flipper_login',
              // 'assets/images/sms_verification.png',
              'assets/flipper_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.sms_outlined,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Verification Code',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle with phone number
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Enter the 6-digit code sent to '),
                TextSpan(
                  text: '$_selectedCountryCode ${_phoneController.text}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // PIN Code Fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 56,
                fieldWidth: 44,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.grey.shade50,
                selectedFillColor: Colors.white,
                activeColor: colorScheme.primary,
                inactiveColor: Colors.grey.shade300,
                selectedColor: colorScheme.primary,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                _smsCode = v;
                _verifyCode();
              },
              onChanged: (value) {
                setState(() {
                  _smsCode = value;
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          // Resend code timer
          Align(
            alignment: Alignment.center,
            child: _canResend
                ? TextButton(
                    onPressed: () => _resendCode(context),
                    child: Text(
                      'Resend Code',
                      style: GoogleFonts.poppins(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Resend code in '),
                        TextSpan(
                          text: '$_timerSeconds seconds',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: 40),

          // Verify Button
          SizedBox(
            height: 56,
            child: FlipperButton(
              text: _isLoading ? 'Verifying...' : 'Verify Code',
              textColor: Colors.white,
              color: colorScheme.primary,
              onPressed: _isLoading ? null : _verifyCode,
              isLoading: _isLoading,
            ),
          ),

          const SizedBox(height: 24),

          // Change number option
          Center(
            child: TextButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _showVerificationUI = false;
                        _animationController.reverse();
                      });
                    },
              icon: Icon(Icons.edit, size: 18, color: colorScheme.primary),
              label: Text(
                'Change Phone Number',
                style: GoogleFonts.poppins(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
