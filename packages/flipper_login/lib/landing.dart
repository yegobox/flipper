import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'responsive_layout.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Landing extends StatefulWidget {
  Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _routerService = locator<RouterService>();
  final List<Widget> _pages = [
    Image.asset("assets/main.png",
        height: 321, width: 321, package: 'flipper_login'),
    Image.asset(
      "assets/image_2.png",
      height: 321,
      width: 321,
      package: 'flipper_login',
    ),
    Image.asset("assets/image_3.png",
        height: 321, width: 321, package: 'flipper_login'),
    Image.asset("assets/image_4.png",
        height: 321, width: 321, package: 'flipper_login'),
  ];

  final List<Widget> _pagesText = [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Everything you need to run your business in the modern age",
        style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Signup and sell in minutes - no commitments or hidden fees",
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Simple and useful reports to help you grow your business",
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Engage with your customer wherever you can find them",
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      ),
    )
  ];
  final signInButtonKey = Key('signInButtonKey');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return ResponsiveLayout(
      mobile: Stack(
        children: [
          CarouselSlider.builder(
              unlimitedMode: true,
              enableAutoSlider: false,
              slideBuilder: (index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xff0056C2),
                        Color(0xff9747FF),
                      ],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Image.asset(
                        'assets/flipper_logo.png',
                        height: 82,
                        width: 82,
                        package: 'flipper_login',
                      ),
                      _pages[index],
                      _pagesText[index],
                      const Spacer(),
                    ],
                  ),
                );
              },
              slideIndicator: CircularSlideIndicator(
                currentIndicatorColor: Colors.white,
                padding: EdgeInsets.only(bottom: screenHeight * 0.28),
              ),
              itemCount: _pages.length),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Column(
              children: [
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      side: MaterialStateProperty.resolveWith(
                          (states) => const BorderSide(color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.transparent;
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.transparent;
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () async {
                      _routerService.navigateTo(AuthOptionPageRoute());
                    },
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    key: signInButtonKey,
                    style: primaryButtonStyle.copyWith(
                        side: MaterialStateProperty.resolveWith(
                            (states) => const BorderSide(color: Colors.purple)),
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                    onPressed: () async {
                      _routerService.clearStackAndShow(AuthOptionPageRoute());
                    },
                    child: Text(
                      "Sign In",
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
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: CarouselSlider.builder(
                unlimitedMode: true,
                enableAutoSlider: false,
                slideBuilder: (index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff0056C2),
                          Color(0xff636A73),
                        ],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        _pages[index],
                      ],
                    ),
                  );
                },
                slideIndicator: CircularSlideIndicator(
                  currentIndicatorColor: Colors.white,
                  padding: const EdgeInsets.only(bottom: 10),
                ),
                itemCount: _pages.length),
          ),
        ],
      ),
    );
  }
}
