import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_layout.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _routerService = locator<RouterService>();

  final List<PageContent> _pagesContent = [
    PageContent(
      imagePath: "assets/main.png",
      text: "Everything you need to run your business in the modern age",
    ),
    PageContent(
      imagePath: "assets/image_2.png",
      text: "Signup and sell in minutes - no commitments or hidden fees",
    ),
    PageContent(
      imagePath: "assets/image_3.png",
      text: "Simple and useful reports to help you grow your business",
    ),
    PageContent(
      imagePath: "assets/image_4.png",
      text: "Engage with your customer wherever you can find them",
    ),
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
            enableAutoSlider: true,
            slideBuilder: (index) {
              final page = _pagesContent[index];
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff0056C2), Color(0xff9747FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/flipper_logo.png',
                      height: 82,
                      width: 82,
                      package: 'flipper_login',
                    ),
                    Image.asset(
                      page.imagePath,
                      height: 321,
                      width: 321,
                      package: 'flipper_login',
                      semanticLabel: 'Carousel image ${index + 1}',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        page.text,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
            slideIndicator: CircularSlideIndicator(
              currentIndicatorColor: Colors.white,
              padding: EdgeInsets.only(bottom: screenHeight * 0.28),
            ),
            itemCount: _pagesContent.length,
          ),
          Spacer(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Column(
              children: [
                _buildButton(
                  text: "Create Account",
                  onPressed: () => _routerService.navigateTo(AuthRoute()),
                ),
                const SizedBox(height: 22),
                _buildButton(
                  text: "Sign In",
                  key: signInButtonKey,
                  onPressed: () =>
                      _routerService.clearStackAndShow(AuthRoute()),
                ),
              ],
            ),
          ),
        ],
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: CarouselSlider.builder(
              unlimitedMode: true,
              enableAutoSlider: true,
              slideBuilder: (index) {
                final page = _pagesContent[index];
                return Wrap(
                  direction: Axis.vertical,
                  children: [
                    Image.asset(
                      page.imagePath,
                      height: 321,
                      width: 321,
                      package: 'flipper_login',
                    ),
                    Text(
                      page.text,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
              slideIndicator: CircularSlideIndicator(
                currentIndicatorColor: Colors.white,
              ),
              itemCount: _pagesContent.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Key? key,
  }) {
    return SizedBox(
      width: 368,
      height: 68,
      child: OutlinedButton(
        key: key,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PageContent {
  final String imagePath;
  final String text;

  PageContent({required this.imagePath, required this.text});
}
