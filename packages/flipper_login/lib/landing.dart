import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_layout.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:async';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _routerService = locator<RouterService>();
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

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
  void initState() {
    super.initState();
    _startAutoSlide();
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    int newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _pagesContent.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0056C2), Color(0xff9747FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    'assets/flipper_logo.png',
                    height: 82,
                    width: 82,
                    package: 'flipper_login',
                  ),
                  Expanded(
                    child: CarouselView(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      children: _pagesContent
                          .map((page) => _buildCarouselItem(page))
                          .toList(),
                    ),
                  ),
                  PageIndicator(
                    count: _pagesContent.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CarouselView(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    children: _pagesContent
                        .map((page) => _buildDesktopCarouselItem(page))
                        .toList(),
                  ),
                ),
                PageIndicator(
                  count: _pagesContent.length,
                  currentIndex: _currentPage,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(PageContent page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          page.imagePath,
          height: 321,
          width: 321,
          package: 'flipper_login',
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
    );
  }

  Widget _buildDesktopCarouselItem(PageContent page) {
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

class CarouselView extends StatelessWidget {
  final Axis scrollDirection;
  final PageController controller;
  final List<Widget> children;

  const CarouselView({
    Key? key,
    required this.scrollDirection,
    required this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: scrollDirection,
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final double dotSize;
  final Color activeColor;
  final Color inactiveColor;

  const PageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    this.dotSize = 8.0,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}

class PageContent {
  final String imagePath;
  final String text;

  PageContent({required this.imagePath, required this.text});
}
