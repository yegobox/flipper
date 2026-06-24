import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_login/login_semantics.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PageContent> _pagesContent = [
    PageContent(
      imagePath: "assets/main.png",
      title: "Run your whole\nbusiness from one app",
      highlight: "business",
      heroLayout: 0,
      text:
          "Sell, track stock, and manage your team - Flipper is your business in your pocket.",
      metrics: const [
        _LandingMetric(
            label: 'Revenue', value: '248K', icon: Icons.trending_up),
        _LandingMetric(
            label: 'Reports', value: 'Daily', icon: Icons.bar_chart_rounded),
      ],
    ),
    PageContent(
      imagePath: "assets/image_2.png",
      title: "Simple, useful reports\nthat help you grow",
      highlight: "reports",
      heroLayout: 1,
      text:
          "See exactly what sells, what's running low, and where your money goes - every day.",
      metrics: const [
        _LandingMetric(
            label: 'Setup', value: 'Fast', icon: Icons.rocket_launch_outlined),
        _LandingMetric(
            label: 'Fees', value: 'Clear', icon: Icons.verified_outlined),
      ],
    ),
    PageContent(
      imagePath: "assets/image_3.png",
      title: "Get paid faster,\ntrack every franc",
      highlight: "track every franc",
      heroLayout: 2,
      text:
          "Accept MoMo, cash, and card. Flipper records every sale and reconciles it for you.",
      metrics: const [
        _LandingMetric(
            label: 'Stock', value: 'Live', icon: Icons.inventory_2_outlined),
        _LandingMetric(
            label: 'Growth', value: '+18%', icon: Icons.insights_outlined),
      ],
    ),
    PageContent(
      imagePath: "assets/image_4.png",
      title: "Grow your business,\nearn rewards",
      highlight: "earn rewards",
      heroLayout: 3,
      text:
          "Hit daily goals, keep your streak alive, and level up from Bronze to Gold Seller.",
      metrics: const [
        _LandingMetric(
            label: 'Sales', value: 'MoMo', icon: Icons.payments_outlined),
        _LandingMetric(
            label: 'Streak',
            value: '12d',
            icon: Icons.local_fire_department_outlined),
      ],
    ),
  ];

  final signInButtonKey = Key('signInButtonKey');

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLanding(context),
      desktop: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0056C2), Color(0xff9747FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(
                  'assets/flipper_logo.png',
                  height: 100,
                  width: 100,
                  package: 'flipper_login',
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  Widget _buildMobileLanding(BuildContext context) {
    return Semantics(
      key: const Key(LoginMaestroIds.landingScreen),
      identifier: LoginMaestroIds.landingScreen,
      label: 'Flipper landing',
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
                    child: Row(
                      children: [
                        const _FlipperGlyph(size: 34),
                        const SizedBox(width: 14),
                        Text(
                          'Flipper',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0B1220),
                              ),
                        ),
                        const Spacer(),
                        Semantics(
                          key: const Key(LoginMaestroIds.landingSignIn),
                          identifier: LoginMaestroIds.landingSignIn,
                          label: 'Sign in',
                          button: true,
                          child: TextButton(
                            key: signInButtonKey,
                            onPressed: _goToSignIn,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color(0xFF7E8AA0),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    activeColor: const Color(0xFF4F46E5),
                    inactiveColor: const Color(0xFFD6DEEA),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          key: Key(
                            _currentPage < _pagesContent.length - 1
                                ? LoginMaestroIds.landingNext
                                : LoginMaestroIds.landingCreateAccount,
                          ),
                          identifier: _currentPage < _pagesContent.length - 1
                              ? LoginMaestroIds.landingNext
                              : LoginMaestroIds.landingCreateAccount,
                          label: _currentPage < _pagesContent.length - 1
                              ? 'Next'
                              : 'Create account',
                          button: true,
                          child: FlipperGradientButton(
                            text: _currentPage < _pagesContent.length - 1
                                ? 'Next'
                                : 'Create account',
                            icon: _currentPage < _pagesContent.length - 1
                                ? Icons.chevron_right_rounded
                                : Icons.person_add_alt_1_rounded,
                            onPressed: _currentPage < _pagesContent.length - 1
                                ? _goToNextPage
                                : _goToCreateAccount,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (_currentPage < _pagesContent.length - 1) ...[
                          Semantics(
                            key: const Key(
                              LoginMaestroIds.landingSkipCreateAccount,
                            ),
                            identifier:
                                LoginMaestroIds.landingSkipCreateAccount,
                            label: 'Skip intro and create account',
                            button: true,
                            child: TextButton(
                              onPressed: _goToCreateAccount,
                              child: const Text(
                                'Skip intro - Create account',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Semantics(
                            key: const Key(
                              LoginMaestroIds.landingSecondarySignIn,
                            ),
                            identifier: LoginMaestroIds.landingSecondarySignIn,
                            label: 'Already selling on Flipper? Sign in',
                            button: true,
                            child: TextButton(
                              onPressed: _goToSignIn,
                              child: const Text(
                                'Already selling on Flipper? Sign in',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ] else
                          Semantics(
                            key: const Key(
                              LoginMaestroIds.landingSecondarySignIn,
                            ),
                            identifier: LoginMaestroIds.landingSecondarySignIn,
                            label: 'Already selling on Flipper? Sign in',
                            button: true,
                            child: TextButton(
                              onPressed: _goToSignIn,
                              child: const Text(
                                'Already selling on Flipper? Sign in',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(PageContent page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Column(
        children: [
          Expanded(
            child: ClipRect(
              child: _ProductCardsHero(layout: page.heroLayout),
            ),
          ),
          const SizedBox(height: 12),
          _LandingSlideTitle(
            title: page.title,
            highlight: page.highlight,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              page.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4A5567),
                    height: 1.42,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  void _goToNextPage() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _clearLoginDraft() {
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'userId');
  }

  void _goToCreateAccount() {
    _clearLoginDraft();
    _routerService.navigateTo(SignUpViewRoute());
  }

  void _goToSignIn() {
    _clearLoginDraft();
    _routerService.navigateTo(PinLoginRoute());
  }

  Widget _buildDesktopCarouselItem(PageContent page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          page.imagePath,
          height: 400,
          width: 400,
          package: 'flipper_login',
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Text(
            page.text,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
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
          side: const BorderSide(color: Colors.white, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ProductCardsHero extends StatefulWidget {
  final int layout;

  const _ProductCardsHero({required this.layout});

  @override
  State<_ProductCardsHero> createState() => _ProductCardsHeroState();
}

class _ProductCardsHeroState extends State<_ProductCardsHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(320.0, 390.0);
        final height = constraints.maxHeight.clamp(350.0, 470.0);

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF22D3EE).withValues(alpha: .18),
                        const Color(0xFF4F46E5).withValues(alpha: .10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * .21,
                child: Container(
                  width: width * .72,
                  height: width * .72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBFD4FF).withValues(alpha: .55),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * .30,
                child: Container(
                  width: width * .52,
                  height: width * .52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBFD4FF).withValues(alpha: .60),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              ..._buildLayout(width, height),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildLayout(double width, double height) {
    return switch (widget.layout) {
      1 => [
          _FloatPositioned(
            controller: _floatController,
            top: height * .10,
            left: width * .03,
            angle: -0.08,
            phase: .10,
            child: _ReportCard(width: width * .62),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .36,
            right: width * .00,
            angle: 0.07,
            phase: .00,
            child: _RevenueCard(width: width * .76),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .64,
            left: width * .08,
            angle: 0.09,
            phase: .20,
            child: _SaleCard(width: width * .66),
          ),
        ],
      2 => [
          _FloatPositioned(
            controller: _floatController,
            top: height * .16,
            right: width * .01,
            angle: -0.07,
            phase: .10,
            child: _SaleCard(width: width * .70),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .42,
            left: width * .00,
            angle: 0.08,
            phase: .00,
            child: _RevenueCard(width: width * .74),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .66,
            right: width * .08,
            angle: -0.06,
            phase: .20,
            child: _StreakCard(width: width * .58),
          ),
        ],
      3 => [
          _FloatPositioned(
            controller: _floatController,
            top: height * .12,
            left: width * .20,
            angle: -0.05,
            phase: .00,
            child: _BadgeCard(width: width * .68),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .45,
            left: width * .04,
            angle: 0.09,
            phase: .10,
            child: _StreakCard(width: width * .58),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .58,
            right: width * .00,
            angle: -0.08,
            phase: .20,
            child: _SaleCard(width: width * .70),
          ),
        ],
      _ => [
          _FloatPositioned(
            controller: _floatController,
            top: height * .08,
            left: width * .16,
            angle: -0.06,
            phase: .00,
            child: _RevenueCard(width: width * .76),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .36,
            left: width * .02,
            angle: 0.07,
            phase: .20,
            child: _SaleCard(width: width * .66),
          ),
          _FloatPositioned(
            controller: _floatController,
            top: height * .42,
            right: width * .00,
            angle: -0.08,
            phase: .10,
            child: _ReportCard(width: width * .62),
          ),
        ],
    };
  }
}

class _FloatPositioned extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final double top;
  final double? left;
  final double? right;
  final double angle;
  final double phase;

  const _FloatPositioned({
    required this.controller,
    required this.child,
    required this.top,
    this.left,
    this.right,
    required this.angle,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Positioned(
      top: top,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (reduceMotion) {
            return Transform.rotate(angle: angle, child: child);
          }
          final shifted = (controller.value + phase) % 1.0;
          final segment = shifted <= .5 ? shifted * 2 : (1 - shifted) * 2;
          final dy = -9 * Curves.easeInOut.transform(segment);

          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: child,
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double width;

  const _RevenueCard({required this.width});

  @override
  Widget build(BuildContext context) {
    final bars = [36.0, 54.0, 46.0, 70.0, 56.0, 88.0];

    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: _heroCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Revenue · this week',
                  style: TextStyle(
                    color: Color(0xFF7E8AA0),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '~ 18%',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'RWF 248,500',
            style: TextStyle(
              color: Color(0xFF0B1220),
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++) ...[
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: bars[i] / 100,
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: i == bars.length - 1
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF22D3EE),
                                    Color(0xFF4F46E5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: i == bars.length - 1
                              ? null
                              : const Color(0xFFE2E4FA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  if (i < bars.length - 1) const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  final double width;

  const _SaleCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: _heroCardDecoration,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFDEF7EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_rounded, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'New sale',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF0B1220),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Solar Kit · MoMo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF7E8AA0),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '+12,000',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final double width;

  const _ReportCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: _heroCardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEECFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Color(0xFF4F46E5),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Daily report',
                style: TextStyle(
                  color: Color(0xFF0B1220),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _ReportBar(label: 'Sales', value: .78),
          const SizedBox(height: 10),
          const _ReportBar(label: 'Stock', value: .55),
          const SizedBox(height: 10),
          const _ReportBar(label: 'Tax', value: .36),
        ],
      ),
    );
  }
}

class _ReportBar extends StatelessWidget {
  final String label;
  final double value;

  const _ReportBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7E8AA0),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 7,
            backgroundColor: const Color(0xFFE6ECF5),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF4F46E5),
            ),
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  final double width;

  const _StreakCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: _heroCardDecoration,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A3D), Color(0xFFFF5A36)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '12 days',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF0B1220),
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                Text(
                  'Sales streak',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF7E8AA0),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final double width;

  const _BadgeCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: _heroCardDecoration,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFFC24B), Color(0xFFFF8A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Gold Seller',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF0B1220),
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    value: .72,
                    minHeight: 7,
                    backgroundColor: Color(0xFFE6ECF5),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFF8A00)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration get _heroCardDecoration {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFE6ECF5)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF102040).withValues(alpha: .12),
        blurRadius: 28,
        offset: const Offset(0, 14),
      ),
    ],
  );
}

class _LandingSlideTitle extends StatelessWidget {
  final String title;
  final String highlight;
  final TextStyle? style;

  const _LandingSlideTitle({
    required this.title,
    required this.highlight,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final base = (style ?? const TextStyle()).copyWith(
      color: const Color(0xFF0B1220),
      fontWeight: FontWeight.w900,
      height: 1.08,
      letterSpacing: 0,
    );
    final before = title.substring(0, title.indexOf(highlight));
    final after = title.substring(title.indexOf(highlight) + highlight.length);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: base,
        children: [
          TextSpan(text: before),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF22D3EE), Color(0xFF4F46E5)],
                ).createShader(bounds);
              },
              child: Text(
                highlight,
                style: base.copyWith(color: Colors.white),
              ),
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}

class _FlipperGlyph extends StatelessWidget {
  final double size;

  const _FlipperGlyph({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FlipperGlyphPainter()),
    );
  }
}

class _FlipperGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * .16;
    final rect = Offset.zero & size;
    final cyan = Paint()
      ..color = const Color(0xFF22D3EE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final indigo = Paint()
      ..color = const Color(0xFF4F46E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final pale = Paint()
      ..color = const Color(0xFFC7D8FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(stroke / 2), -2.75, 2.1, false, cyan);
    canvas.drawArc(rect.deflate(stroke / 2), .15, 4.1, false, indigo);
    canvas.drawArc(rect.deflate(size.width * .26), -1.15, 4.8, false, pale);
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width * .12,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    this.dotSize = 10.0,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 26 : dotSize,
          height: isActive ? 7 : dotSize,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isActive ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}

class PageContent {
  final String imagePath;
  final String title;
  final String highlight;
  final int heroLayout;
  final String text;
  final List<_LandingMetric> metrics;

  PageContent({
    required this.imagePath,
    required this.title,
    required this.highlight,
    required this.heroLayout,
    required this.text,
    required this.metrics,
  });
}

class _LandingMetric {
  final String label;
  final String value;
  final IconData icon;

  const _LandingMetric({
    required this.label,
    required this.value,
    required this.icon,
  });
}
