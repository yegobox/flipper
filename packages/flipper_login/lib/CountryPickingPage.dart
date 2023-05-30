import 'package:flipper_login/PhoneInputScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_login/signinpage.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Positioned(
                top: 40,
                left: 30,
                child: MaterialButton(
                  minWidth: 10,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthOptionPage()),
                    );
                  },
                  child: Text("<",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Roboto')),
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 45,
                right: 30,
                child: Text("Sign In",
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(20.0), // add padding here
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.15),
                    Text('Select the country where your business is located',
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: 400,
                      height: 60,
                      child: CountryCodePicker(
                        hideSearch: true,
                        onChanged: (element) => {
                          pickedCountry = element.code.toString(),
                          print(pickedCountry)
                        },
                        initialSelection: pickedCountry,
                        showCountryOnly: true,
                        showOnlyCountryWhenClosed: true,
                        textStyle: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                              'I agree to flipper’s Seller Agreement and Privacy Policy.',
                              style: GoogleFonts.poppins(fontSize: 24)),
                        ),
                        Checkbox(
                          value: termsAndCondValue,
                          onChanged: (bool? value) {
                            setState(() {
                              termsAndCondValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Wrap(children: <Widget>[
                      Text(
                          'This app is protected by reCAPTCHA Enterprise and Google Privacy Policy and Terms of Service apply.',
                          style: GoogleFonts.poppins(fontSize: 20)),
                    ]),
                    SizedBox(height: screenHeight * 0.2),
                    SizedBox(
                      width: 368,
                      height: 68,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const Color(0xffD07A2A)
                                    .withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return const Color(0xffD07A2A)
                                    .withOpacity(0.12);
                              }
                              return null;
                            },
                          ),
                        ),
                        onPressed: () async {
                          if (termsAndCondValue) {
                            //Navigate to signinpage.dart
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneInputScreen(
                                    countryCode: pickedCountry),
                              ),
                            );
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
