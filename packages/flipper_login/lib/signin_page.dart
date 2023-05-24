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
        MaterialButton(
          onPressed: () {
            final _routerService = locator<RouterService>();
            _routerService.clearStackAndShow(CountryPickerRoute());
          },
          color: Colors.blue,
          textColor: Colors.white,
          //height: screenHeight * 0.07,
          minWidth: screenWidth * 0.8,
          //minwidth fits parent width

          child: Text(
            'Phone Number',
            style:
                GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        AuthStateListener<OAuthController>(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0),
            child: OAuthProviderButton(
              provider: GoogleProvider(clientId: _googleClientId),
            ),
          ),
          listener: (oldState, newState, ctrl) {
            if (newState is SignedIn) {
              final _routerService = locator<RouterService>();
              _routerService
                  .clearStackAndShow(StartUpViewRoute(invokeLogin: true));
            }
            return null;
          },
        )
      ]),
    ));
  }
}
