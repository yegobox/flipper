import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flipper_login/apple_logo_painter.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
// import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'OAuthProviderButton.dart';
import 'apple_logo_painter.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

// Constants for consistent styling
class AppColors {
  static const primary = Color(0xFF006AFE);
  static const primaryLight = Color(0xFFE6F0FF);
  static const error = Color(0xFFE53935);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF757575);
}

class AppStyles {
  static final heading = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static final buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final secondaryButtonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}

// Button styles
class AppButtons {
  static final primaryButton = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    )),
    elevation: WidgetStateProperty.all(0),
  );

  static final secondaryButton = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.white),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.primary),
    )),
    elevation: WidgetStateProperty.all(0),
  );

  static final outlinedButton = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primaryLight),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    )),
    elevation: WidgetStateProperty.all(0),
  );
}

// Enhanced AuthState management
enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({this.status = AuthStatus.initial, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController {
  final _authStateController = StreamController<AuthState>.broadcast();

  Stream<AuthState> get authState => _authStateController.stream;

  void updateState(AuthState state) {
    _authStateController.add(state);
  }

  void notifySignedIn() {
    updateState(AuthState(status: AuthStatus.success));
  }

  void notifySignedOut() {
    updateState(AuthState(status: AuthStatus.initial));
  }

  void notifyError(String message) {
    updateState(AuthState(status: AuthStatus.error, errorMessage: message));
  }

  void notifyLoading() {
    updateState(AuthState(status: AuthStatus.loading));
  }

  void dispose() {
    _authStateController.close();
  }
}

// Main Authentication Screen
class Auth extends StatefulWidget {
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _routerService = locator<RouterService>();
  final _authController = AuthController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authController.authState.listen((state) {
      setState(() {
        _isLoading = state.status == AuthStatus.loading;
        _errorMessage = state.errorMessage;
      });

      if (state.status == AuthStatus.success) {
        _routerService.clearStackAndShow(StartUpViewRoute(invokeLogin: true));
      }
    });
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneNumberLogin() async {
    _authController.notifyLoading();
    try {
      await _routerService.clearStackAndShow(CountryPickerRoute());
    } catch (e) {
      _authController.notifyError("Failed to navigate to phone login");
    }
  }

  Future<void> _handleGoogleLogin() async {
    _authController.notifyLoading();
    try {
      final provider = GoogleAuthProvider();
      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);

      if (userCredential.user != null) {
        _authController.notifySignedIn();
      } else {
        _authController.notifyError("Sign in failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'canceled' ||
          e.code == 'web-context-canceled') {
        _authController.notifySignedOut();
      } else {
        Sentry.captureException(e, stackTrace: StackTrace.current);
        _authController.notifyError(e.message ?? "Authentication failed");
      }
    } catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController.notifyError("An unexpected error occurred");
    }
  }

  Future<void> _handleMicrosoftLogin() async {
    _authController.notifyLoading();
    try {
      final provider = MicrosoftAuthProvider();
      provider.addScope('mail.read');

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);
      if (userCredential.user != null) {
        _authController.notifySignedIn();
      } else {
        _authController.notifyError("Sign in failed");
      }
    } catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController.notifyError("Microsoft login failed");
    }
  }

  Future<void> _handleAppleLogin() async {
    _authController.notifyLoading();
    try {
      final provider = AppleAuthProvider();
      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);

      if (userCredential.user != null) {
        _authController.notifySignedIn();
      } else {
        _authController.notifyError("Sign in failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'canceled' ||
          e.code == 'web-context-canceled') {
        _authController.notifySignedOut();
      } else {
        Sentry.captureException(e, stackTrace: StackTrace.current);
        _authController.notifyError(e.message ?? "Authentication failed");
      }
    } catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController.notifyError("Apple login failed");
    }
  }

  void _handlePinLogin() {
    _routerService.navigateTo(PinLoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 48),

                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/flipper_logo.png',
                        package: 'flipper_login',
                        height: 80,
                      ),
                    ),

                    SizedBox(height: 48),

                    // Heading
                    Text(
                      "Welcome to Flipper",
                      style: AppStyles.heading,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16),

                    // Subheading
                    Text(
                      "How would you like to sign in?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40),

                    // Error message if any
                    if (_errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: AppColors.error),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: AppColors.error),
                              onPressed: () =>
                                  setState(() => _errorMessage = null),
                            ),
                          ],
                        ),
                      ),

                    if (_errorMessage != null) SizedBox(height: 24),

                    // Phone Number Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        key: Key("phoneNumberLogin"),
                        style: AppButtons.primaryButton,
                        onPressed: _isLoading ? null : _handlePhoneNumberLogin,
                        icon: Icon(Icons.phone, size: 20),
                        label: Text("Continue with Phone",
                            style: AppStyles.buttonText),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Google Button
                    SocialLoginButton(
                      key: Key("googleLogin"),
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                      iconPath: 'assets/google.svg',
                      text: 'Continue with Google',
                    ),

                    SizedBox(height: 16),

                    // Microsoft Button
                    SocialLoginButton(
                      key: Key("microsoftLogin"),
                      onPressed: _isLoading ? null : _handleMicrosoftLogin,
                      iconPath: 'assets/microsoft.svg',
                      text: 'Continue with Microsoft',
                    ),

                    SizedBox(height: 16),

                    // Apple Button
                    SocialLoginButton(
                      key: Key("appleLogin"),
                      onPressed: _isLoading ? null : _handleAppleLogin,
                      customIcon: SizedBox(
                        width: 20,
                        height: 20,
                        child: CustomPaint(
                          painter: AppleLogoPainter(color: Colors.black),
                        ),
                      ),
                      text: 'Continue with Apple',
                    ),

                    SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    SizedBox(height: 24),

                    // PIN Login Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: Key('pinLogin'),
                        style: AppButtons.outlinedButton,
                        onPressed: _isLoading ? null : _handlePinLogin,
                        icon: Icon(Icons.pin_outlined, size: 20),
                        label: Text('PIN Login',
                            style: AppStyles.secondaryButtonText),
                      ),
                    ),

                    SizedBox(height: 48),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: LoadingAnimationWidget.fallingDot(
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Social Login Button Component
class SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? iconPath;
  final Widget? customIcon;
  final String text;

  const SocialLoginButton({
    Key? key,
    required this.onPressed,
    this.iconPath,
    this.customIcon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtons.secondaryButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIcon ??
                (iconPath != null
                    ? SvgPicture.asset(
                        iconPath!,
                        package: 'flipper_login',
                        width: 20,
                        height: 20,
                      )
                    : SizedBox()),
            SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
