import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AuthOptionPage extends StatefulWidget {
  @override
  State<AuthOptionPage> createState() => _AuthOptionPageState();
}

class _AuthOptionPageState extends State<AuthOptionPage> {
  final _routerService = locator<RouterService>();

  final _authController = AuthController();

  bool isAddingUser = false;

  @override
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/flipper_logo.png',
                  package: 'flipper_login',
                ),
                SizedBox(height: screenHeight * 0.1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "How would you like to proceed?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    key: Key("phoneNumberLogin"),
                    style: primaryButtonStyle.copyWith(
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isAddingUser = true;
                      });
                      _routerService.clearStackAndShow(CountryPickerRoute());
                    },
                    child: Text(
                      "Phone Number",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 368,
                //   height: 68,
                //   child: OAuthProviderButton(
                //     variant: OAuthButtonVariant.icon,
                //     provider:
                //         GoogleProvider(clientId: _googleClientId, scopes: [
                //       ga.DriveApi.driveFileScope,
                //       ga.DriveApi.driveMetadataScope,
                //       ga.DriveApi.driveAppdataScope,
                //       ga.DriveApi.driveScope
                //     ]),
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.02),
                AuthButton(
                  key: Key("googleLogin"),
                  onPressed: () async {
                    setState(() {
                      isAddingUser = true;
                    });
                    final provider = GoogleAuthProvider();
                    final user = await FirebaseAuth.instance
                        .signInWithProvider(provider);
                    if (user.user != null) {
                      _authController.notifySignedIn();
                      _routerService.clearStackAndShow(
                          StartUpViewRoute(invokeLogin: true));
                    }
                  },
                  iconPath: 'assets/google.svg',
                ),
                SizedBox(height: screenHeight * 0.02),
                AuthButton(
                  key: Key("microsoftLogin"),
                  onPressed: () async {
                    log('microsoft');
                    setState(() {
                      isAddingUser = true;
                    });
                    final provider = MicrosoftAuthProvider();
                    provider.addScope('mail.read');
                    log(FirebaseAuth.instance.currentUser?.uid ?? "None",
                        name: "microsoft");
                    final user = await FirebaseAuth.instance
                        .signInWithProvider(provider);
                    if (user.user != null) {
                      _authController.notifySignedIn();
                      _routerService.clearStackAndShow(
                          StartUpViewRoute(invokeLogin: true));
                    }
                  },
                  iconPath: 'assets/microsoft.svg',
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    key: Key('pinLogin'),
                    child: Text(
                      'PIN Login',
                      style: TextStyle(color: Color(0xff006AFE)),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                          color: const Color(0xff006AFE).withOpacity(0.1),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff006AFE).withOpacity(0.1)),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Color(0xff006AFE).withOpacity(0.5);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Color(0xff006AFE).withOpacity(0.5);
                          }
                          return Color(0xff006AFE).withOpacity(0.5);
                        },
                      ),
                    ),
                    onPressed: () {
                      _routerService.navigateTo(PinLoginRoute());
                    },
                  ),
                )
              ],
            ),
            if (isAddingUser)
              LoadingAnimationWidget.fallingDot(
                color: Colors.blueGrey,
                size: 100,
              ),
          ],
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.onPressed,
    required this.iconPath,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 368,
      height: 68,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: SvgPicture.asset(
            iconPath,
            package: 'flipper_login',
          ),
          style: primaryButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (states) => BorderSide(
                color: Colors.grey.withOpacity(.1),
              ),
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthController {
  final _authStateChanged = StreamController<AuthState>();

  Stream<AuthState> get authStateChanged => _authStateChanged.stream;

  void notifySignedIn() {
    _authStateChanged.add(SignedIn());
  }

  void notifySignedOut() {
    _authStateChanged.add(SignedOut());
  }

  void dispose() {
    _authStateChanged.close();
  }
}

abstract class AuthState {}

class SignedIn extends AuthState {}

class SignedOut extends AuthState {}
