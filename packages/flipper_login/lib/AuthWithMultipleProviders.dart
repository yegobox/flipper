import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_login/LoadingDialog.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_services/proxy.dart';
// import 'package:flipper_login/apple_logo_painter.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
// import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'apple_logo_painter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

/// Authentication state for reactive UI updates
class AuthenticationState {
  final bool isAuthenticating;
  final String? errorMessage;
  final bool isComplete;

  AuthenticationState({
    this.isAuthenticating = false,
    this.errorMessage,
    this.isComplete = false,
  });

  factory AuthenticationState.idle() {
    return AuthenticationState(isAuthenticating: false);
  }

  factory AuthenticationState.authenticating() {
    return AuthenticationState(isAuthenticating: true);
  }

  factory AuthenticationState.error(String message) {
    return AuthenticationState(
      isAuthenticating: false,
      errorMessage: message,
    );
  }

  factory AuthenticationState.complete() {
    return AuthenticationState(
      isAuthenticating: false,
      isComplete: true,
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
  late LoginViewModel _loginViewModel;

  // Authentication state controller for reactive UI updates
  final _authenticationStateController =
      StreamController<AuthenticationState>.broadcast();

  // Dialog management
  bool _isAuthDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _loginViewModel = LoginViewModel();

    // Listen to the auth controller state changes
    _authController.authState.listen((state) {
      setState(() {
        _isLoading = state.status == AuthStatus.loading;
        _errorMessage = state.errorMessage;
      });

      if (state.status == AuthStatus.success) {
        // Set up Firebase auth state listener to handle the complete login process
        _handleAuthStateChanges();
      }
    });

    // Listen to authentication state for showing/hiding loading dialog
    _authenticationStateController.stream.listen((state) {
      if (state.isAuthenticating && !_isAuthDialogShowing) {
        _showAuthenticationDialog();
      } else if (!state.isAuthenticating && _isAuthDialogShowing) {
        _hideAuthenticationDialog();
      }

      if (state.errorMessage != null) {
        _authController.notifyError(state.errorMessage!);
      }
    });
  }

  // Show authentication loading dialog
  void _showAuthenticationDialog() {
    _isAuthDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialog(message: 'Finalizing authentication...');
      },
    ).then((_) {
      _isAuthDialogShowing = false;
    });
  }

  // Hide authentication loading dialog
  void _hideAuthenticationDialog() {
    if (_isAuthDialogShowing && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isAuthDialogShowing = false;
    }
  }

  /// Handles user authentication state changes and login flow
  Future<void> _handleAuthStateChanges() async {
    // Notify UI that authentication is in progress
    _authenticationStateController.add(AuthenticationState.authenticating());

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        _authenticationStateController.add(AuthenticationState.idle());
        return;
      }

      try {
        // Only check if authentication is already complete
        // PIN login should not prevent email/phone login
        final bool authIsComplete = (await ProxyService.box.authComplete());

        // Log authentication state for debugging
        talker.info(
            'Auth state: authIsComplete=$authIsComplete, user=${user.uid}');

        if (authIsComplete) {
          talker.info('Skipping login process: user is already authenticated');

          // Update UI state to idle (will automatically dismiss loading UI)
          _authenticationStateController.add(AuthenticationState.idle());

          // Navigate to startup view since auth is already complete
          _routerService.clearStackAndShow(StartUpViewRoute());
          return;
        }

        // Set a timeout to prevent indefinite hanging
        bool timeoutOccurred = false;
        Future.delayed(Duration(seconds: 30)).then((_) {
          if (_isAuthDialogShowing) {
            timeoutOccurred = true;
            talker.warning('Authentication process timed out after 30 seconds');
            _authenticationStateController.add(AuthenticationState.error(
                'Authentication timed out. Please try again.'));
          }
        });

        // Process login with retry for network issues
        int retryCount = 0;
        Map<String, dynamic>? loginData;

        while (retryCount < 2 && !timeoutOccurred) {
          try {
            loginData = await _loginViewModel.processUserLogin(user);
            break; // Success, exit retry loop
          } catch (e) {
            if (e.toString().contains('network') && retryCount < 1) {
              // Only retry once for network errors
              retryCount++;
              talker.info(
                  'Network error during login, retrying (${retryCount}/2)...');
              await Future.delayed(Duration(seconds: 2)); // Wait before retry
            } else {
              rethrow; // Not a network error or max retries reached
            }
          }
        }

        if (loginData == null) {
          throw Exception('Failed to process login after retries');
        }

        final Pin userPin = loginData['pin'];
        final IUser userData = loginData['user'];

        await _loginViewModel.completeLoginProcess(userPin, _loginViewModel,
            user: userData);

        // Track login event with PosthogService
        PosthogService.instance.capture('login_success', properties: {
          'source': 'auth_screen',
          'user_id': user.uid,
          'email': user.email ?? user.phoneNumber!,
        });

        // Update UI state to idle (will automatically dismiss loading UI)
        _authenticationStateController.add(AuthenticationState.idle());
      } catch (e, s) {
        talker.error('Authentication error: $e');
        // Update UI with error state (will automatically show error and dismiss loading)
        _authenticationStateController
            .add(AuthenticationState.error(e.toString()));
        _loginViewModel.handleLoginError(e, s);
      }
    });
  }

  @override
  void dispose() {
    _authenticationStateController.close();
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
      // Configure Microsoft provider to allow any Microsoft account
      final provider = MicrosoftAuthProvider();

      // Set 'common' tenant to allow any Microsoft account (personal or organizational)
      provider.setCustomParameters({
        'tenant': 'common',
        'prompt':
            'select_account', // Ensures user can select from multiple accounts
      });

      // Add necessary scopes for profile access
      provider.addScope('user.read');
      provider.addScope('openid');
      provider.addScope('profile');
      provider.addScope('email');

      // Log the authentication attempt
      talker.info(
          'Starting Microsoft OAuth sign-in process with multi-tenant configuration');

      // Perform the authentication
      final authCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);
      talker.info('Microsoft credential obtained successfully');

      if (authCredential.user != null) {
        talker
            .info('Microsoft sign-in successful: ${authCredential.user?.uid}');
        _authController.notifySignedIn();
      } else {
        _authController.notifyError("Sign in failed");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      talker.error(
          'Microsoft login FirebaseAuthException: ${e.code} - ${e.message}');
      Sentry.captureException(e, stackTrace: StackTrace.current);

      // Handle user cancellation gracefully
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled' ||
          e.code == 'web-context-canceled') {
        _authController.notifySignedOut();
      } else if (e.code == 'unauthorized-domain') {
        _authController.notifyError(
            "Authentication domain not authorized. Please contact support.");
      } else if (e.code == 'user-disabled') {
        _authController.notifyError("This account has been disabled.");
      } else if (e.code == 'account-exists-with-different-credential') {
        _authController.notifyError(
            "An account already exists with the same email address but different sign-in credentials.");
      } else {
        _authController.notifyError("Microsoft login failed: ${e.message}");
      }
    } catch (e) {
      // Log detailed error information for other exceptions
      talker.error('Microsoft login error: ${e.toString()}');
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController
          .notifyError("Microsoft login failed. Please try again later.");
    }
  }

  Future<void> _handleAppleLogin() async {
    _authController.notifyLoading();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        _authController.notifySignedIn();
      } else {
        _authController.notifyError("Sign in failed");
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        _authController.notifySignedOut();
      } else {
        Sentry.captureException(e, stackTrace: StackTrace.current);
        _authController.notifyError("Apple authorization failed: ${e.message}");
      }
    } on FirebaseAuthException catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController.notifyError(e.message ?? "Authentication failed");
    } catch (e) {
      talker.warning(e);
      Sentry.captureException(e, stackTrace: StackTrace.current);
      _authController.notifyError("Apple login failed: ${e.toString()}");
    }
  }

  void _handlePinLogin() {
    _routerService.navigateTo(PinLoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => _loginViewModel,
      builder: (context, model, child) {
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
                                Icon(Icons.error_outline,
                                    color: AppColors.error),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      Icon(Icons.close, color: AppColors.error),
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
                            onPressed:
                                _isLoading ? null : _handlePhoneNumberLogin,
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
      },
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
            SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: customIcon ??
                    (iconPath != null
                        ? SvgPicture.asset(
                            iconPath!,
                            package: 'flipper_login',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          )
                        : SizedBox()),
              ),
            ),
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
