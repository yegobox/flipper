import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/constants.dart';

// const _googleClientId =
//     '455580464649-3nhpbm3bp02stjuh0g01ovfr0kemi00j.apps.googleusercontent.com';

class AuthOptionPage extends StatelessWidget {
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
      child: Column(children: [
        SizedBox(height: screenHeight * 0.1),
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: screenHeight * 0.1),
        SizedBox(
          width: 368,
          height: 68,
          child: OutlinedButton(
            style: primaryButtonStyle.copyWith(
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                    (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)))),
            onPressed: () async {
              _routerService.clearStackAndShow(CountryPickerRoute());
            },
            child: Text(
              "Phone Number",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AuthStateListener<OAuthController>(
            child: Column(
              children: [
                SizedBox(
                    width: 368,
                    height: 68,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                            4), // Add border radius to match IconButton's shape
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final provider = GoogleAuthProvider();
                          final user =
                              await FirebaseAuth.instance.signInWithProvider(
                            provider,
                          );
                          if (user.user != null) {
                            _routerService.clearStackAndShow(
                                StartUpViewRoute(invokeLogin: true));
                          }
                        },
                        icon: SvgPicture.asset(
                          'assets/google.svg',
                          package: 'flipper_login',
                        ),
                        style: primaryButtonStyle.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                                (states) => BorderSide(
                                      color: Colors.grey.withOpacity(.1),
                                    )),
                            shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))
                            // You can remove the side property as the border is now managed by the Container's decoration
                            ),
                      ),
                    )),
                SizedBox(height: screenHeight * 0.02),

                //NOTE: The old code for google auth was not opening browser but then the entire button was not clickable
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
                SizedBox(
                    width: 368,
                    height: 68,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                            4), // Add border radius to match IconButton's shape
                      ),
                      child: IconButton(
                        onPressed: () async {
                          log('microsoft');
                          final provider = MicrosoftAuthProvider();
                          // GoogleAuthProvider();
                          provider.addScope('mail.read');
                          final user =
                              await FirebaseAuth.instance.signInWithProvider(
                            provider,
                          );
                          if (user.user != null) {
                            _routerService.clearStackAndShow(
                                StartUpViewRoute(invokeLogin: true));
                          }
                        },
                        icon: SvgPicture.asset(
                          'assets/microsoft.svg',
                          package: 'flipper_login',
                        ),
                        style: primaryButtonStyle.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                                (states) => BorderSide(
                                      color: Colors.grey.withOpacity(.1),
                                    )),
                            shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))
                            // You can remove the side property as the border is now managed by the Container's decoration
                            ),
                      ),
                    ))
              ],
            ),
            listener: (oldState, newState, ctrl) {
              if (newState is SignedIn) {
                _routerService
                    .clearStackAndShow(StartUpViewRoute(invokeLogin: true));
              }
              return null;
            },
          ),
        ),
      ]),
    ));
  }
}
