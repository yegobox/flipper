import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flipper_web/widgets/app_button.dart';
import 'package:go_router/go_router.dart' as maybe_go;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/core/localization/locale_provider.dart';
import 'package:flipper_web/l10n/app_localizations.dart';
import 'package:flipper_web/l10n/app_localizations_en.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isHovering = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _pricingKey = GlobalKey();

  String _localized(String Function(AppLocalizations) getter) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return getter(localizations);
    }
    // Fallback to English if localizations not available
    return getter(AppLocalizationsEn());
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(context),
            _buildPhotoCards(context),
            _buildPricingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Row(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: _isHovering ? const Color(0xFF22C55E) : Colors.black,
                letterSpacing: -0.5,
              ),
              child: const Text('Flipper'),
            ),
          ),
          const Spacer(),
          _buildNavItem('Pricing', _localized((l) => l.pricing)),
          const SizedBox(width: 32),
          _buildNavItem('Blog', _localized((l) => l.blog)),
          const SizedBox(width: 32),
          _buildNavItem('About', _localized((l) => l.about)),
          const SizedBox(width: 32),
          _buildNavItem('Download', _localized((l) => l.download)),
          const SizedBox(width: 32),
          _buildNavItem('Help', _localized((l) => l.help)),
          const SizedBox(width: 48),
          Row(
            children: [
              Icon(Icons.star_outline, size: 20, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                '21k',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          _buildLanguageDropdown(),
          const SizedBox(width: 24),
          _buildSignUpButton(),
        ],
      ),
    );
  }

  Widget _buildNavItem(String key, String text) {
    return GestureDetector(
      onTap: () => _scrollToSection(key),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _scrollToSection(String section) {
    if (section == 'Pricing') {
      final context = _pricingKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AppButton(
        label: _localized((l) => l.signUp),
        onPressed: () => _navigateToSignup(context),
        variant: AppButtonVariant.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final currentLocale = ref.watch(localeProvider);
    return DropdownButton<Locale>(
      value: currentLocale,
      underline: const SizedBox(),
      icon: const Icon(Icons.language, color: Colors.grey),
      items: const [
        DropdownMenuItem(value: Locale('en'), child: Text('English')),
        DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
        DropdownMenuItem(value: Locale('sw'), child: Text('Kiswahili')),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          ref.read(localeProvider.notifier).setLocale(newLocale);
        }
      },
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 120, 40, 80),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _localized((l) => l.heroTitle).split('\n')[0] + '\n',
                    style: TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF22C55E), // Green color
                      height: 1.1,
                      letterSpacing: -2,
                    ),
                  ),
                  TextSpan(
                    text: _localized((l) => l.heroTitle).split('\n')[1],
                    style: TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.1,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _localized((l) => l.heroSubtitle),
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPrimaryButton(),
                const SizedBox(width: 24),
                _buildSecondaryButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(28),
      ),
      child: AppButton(
        label: _localized((l) => l.signUp),
        onPressed: () => _navigateToSignup(context),
        variant: AppButtonVariant.primary,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return AppButton(
      label: _localized((l) => l.login),
      onPressed: () => _navigateToLogin(context),
      variant: AppButtonVariant.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
    );
  }

  Widget _buildPhotoCards(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Card 1 - Back left
          Positioned(
            left: 0,
            bottom: 0,
            child: _buildHoverCard(
              angle: -0.1,
              child: _buildPhotoCard(Colors.lightBlue.shade100, 280, 200),
            ),
          ),
          // Card 2 - Middle left
          Positioned(
            left: 200,
            bottom: 40,
            child: _buildHoverCard(
              angle: 0.05,
              child: _buildPhotoCard(Colors.grey.shade200, 260, 180),
            ),
          ),
          // Card 3 - Middle right
          Positioned(
            right: 200,
            bottom: 60,
            child: _buildHoverCard(
              angle: -0.05,
              child: _buildPhotoCard(Colors.blue.shade200, 280, 200),
            ),
          ),
          // Card 4 - Front right
          Positioned(
            right: 0,
            bottom: 20,
            child: _buildHoverCard(
              angle: 0.08,
              child: _buildPhotoCard(Colors.grey.shade900, 260, 180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoverCard({required double angle, required Widget child}) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        transform: Matrix4.identity()
          ..rotateZ(angle)
          ..scale(1.0),
        child: child,
      ),
    );
  }

  Widget _buildPhotoCard(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.8)],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.business_outlined,
              size: 48,
              color: color == Colors.grey.shade900
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: .8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Container(
      key: _pricingKey,
      padding: const EdgeInsets.all(80),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Text(
            _localized((l) => l.pricingTitle),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _localized((l) => l.pricingSubtitle),
            style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 32,
            runSpacing: 32,
            children: [
              _buildPricingCard(
                _localized((l) => l.planMobile),
                _localized((l) => l.priceMobile),
                _localized((l) => l.currencyPerMonth),
                [
                  _localized((l) => l.featureMobileAppAccess),
                  _localized((l) => l.featureBasicBusinessTools),
                  _localized((l) => l.featureDataEncryption),
                  _localized((l) => l.featureSingleDevice),
                  _localized((l) => l.featureTaxReportingMobile),
                ],
                false,
              ),
              _buildPricingCard(
                _localized((l) => l.planMobileDesktop),
                _localized((l) => l.priceMobileDesktop),
                _localized((l) => l.currencyPerMonth),
                [
                  _localized((l) => l.featureMobileDesktopAppAccess),
                  _localized((l) => l.featureAdvancedBusinessTools),
                  _localized((l) => l.featureMilitaryGradeEncryption),
                  _localized((l) => l.featurePrioritySupport),
                  _localized((l) => l.featureMultipleDevices),
                  _localized((l) => l.featureAdvancedAnalytics),
                  _localized((l) => l.featureTaxReportingDesktop),
                ],
                true,
              ),
              _buildPricingCard(
                _localized((l) => l.planEnterprise),
                _localized((l) => l.priceEnterprise),
                _localized((l) => l.currencyPerMonth),
                [
                  _localized((l) => l.featureFullPlatformAccess),
                  _localized((l) => l.featureEnterpriseGradeSecurity),
                  _localized((l) => l.feature247DedicatedSupport),
                  _localized((l) => l.featureUnlimitedUsersBranches),
                  _localized((l) => l.featureCustomIntegrations),
                  _localized((l) => l.featureExtraSupport),
                  _localized((l) => l.featurePremiumTaxConsulting),
                  _localized((l) => l.featureUnlimitedBranches),
                ],
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    String title,
    String price,
    String period,
    List<String> features,
    bool isPopular,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular
            ? Border.all(color: const Color(0xFF22C55E), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _localized((l) => l.mostPopular),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (isPopular) const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                period,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.check, size: 20, color: const Color(0xFF22C55E)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _localized((l) => l.getStarted),
              onPressed: () => _navigateToSignup(context),
              variant: isPopular
                  ? AppButtonVariant.primary
                  : AppButtonVariant.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    // Navigate to login screen
    try {
      maybe_go.GoRouter.of(context).go('/login');
      return;
    } catch (_) {
      // Fallback to Navigator push with fade transition
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PinScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  void _navigateToSignup(BuildContext context) {
    // Navigate to signup screen
    try {
      maybe_go.GoRouter.of(context).go('/signup');
      return;
    } catch (_) {
      // Fallback to Navigator push with fade transition
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PinScreen(), // Fallback to PinScreen for now
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }
}
