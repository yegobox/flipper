import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  bool termsAndCondValue = false;
  String pickedCountry = 'RW';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.red,
      body: Stack(
        children: [
          Positioned(
            top: 8,
            left: 0,
            child: IconButton(
              // minWidth: 10,
              onPressed: () {
                final _routerService = locator<RouterService>();
                _routerService.navigateTo(AuthOptionPageRoute());
              },
              icon: Image.asset('assets/fav.png',
                  height: 90, width: 45, package: 'flipper_login'),
              color: Colors.black,
            ),
          ),
          Positioned(
            top: 45,
            right: 30,
            child: Text("Sign In",
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: EdgeInsets.all(20.0), // add padding here
            child: Column(
              children: <Widget>[
                SizedBox(height: screenHeight * 0.15),
                Text('Select the country where your business is located',
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.normal)),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: CountryCodePicker(
                    hideSearch: true,
                    alignLeft: false,
                    onChanged: (element) => {
                      pickedCountry = element.code.toString(),
                      print(pickedCountry)
                    },
                    initialSelection: pickedCountry,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: true,
                    textStyle:
                        GoogleFonts.poppins(fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                          'I agree to flipper’s Seller Agreement and Privacy Policy.',
                          style: GoogleFonts.poppins(fontSize: 20)),
                    ),
                    Checkbox(
                      activeColor: const Color(0xff006AFE),
                      checkColor: activeColor,
                      focusColor: activeColor,
                      value: termsAndCondValue,
                      shape: CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          termsAndCondValue = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    children: [
                      Text(
                          'This app is protected by reCAPTCHA Enterprise and Google Privacy Policy and Terms of Service apply.',
                          style: GoogleFonts.poppins(fontSize: 18)),
                    ],
                  ),
                ),
                SizedBox(height: 130),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    style: primaryButtonStyle.copyWith(
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                    onPressed: () async {
                      if (termsAndCondValue) {
                        //Navigate to signinpage.dart
                        final _routerService = locator<RouterService>();
                        _routerService.navigateTo(
                            PhoneInputScreenRoute(countryCode: pickedCountry));
                      } else {
                        final snackBar = SnackBar(
                          content: const Text(
                              'Accept terms and conditions to continue.'),
                          action: SnackBarAction(
                            label: 'Okay',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
