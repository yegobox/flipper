import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_page_desktop.dart';
import 'responsive_layout.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Landing extends StatefulWidget {
  Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
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
        style: GoogleFonts.roboto(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Signup and sell in minutes - no commitments or hidden fees",
        style: GoogleFonts.roboto(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Simple and useful reports to help you grow your business",
        style: GoogleFonts.roboto(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Engage with your customer wherever you can find them",
        style: GoogleFonts.roboto(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return ResponsiveLayout(
      mobile: Stack(
        children: [
          Image.asset(
            'assets/flipper_logo.png',
            height: 82,
            width: 82,
            package: 'flipper_login',
          ),
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
                        Color(0xff636A73),
                      ],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.2,
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
                      
                      final _routerService = locator<RouterService>();
                      _routerService.clearStackAndShow(AuthOptionPageRoute());
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
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
                      //Navigate to signinpage.dart
                      final _routerService = locator<RouterService>();
                      _routerService.clearStackAndShow(AuthOptionPageRoute());
                    },
                    child: Text(
                      "Login",
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
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      AuthPageDesktop(
                        startUpPage: Center(child: Text("hello")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
