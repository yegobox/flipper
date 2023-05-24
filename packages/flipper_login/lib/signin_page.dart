import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

const _googleClientId =
    '455580464649-3nhpbm3bp02stjuh0g01ovfr0kemi00j.apps.googleusercontent.com';

class AuthOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue.shade300),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color(0xffD07A2A).withOpacity(0.04);
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return const Color(0xffD07A2A).withOpacity(0.12);
                  }
                  return null;
                },
              ),
            ),
            onPressed: () async {
              final _routerService = locator<RouterService>();
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
            child: OAuthProviderButton(
              provider: GoogleProvider(clientId: _googleClientId),
            ),
            listener: (oldState, newState, ctrl) {
              if (newState is SignedIn) {
                final _routerService = locator<RouterService>();
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
