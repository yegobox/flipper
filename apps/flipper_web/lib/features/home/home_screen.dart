import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isHovering = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(context),
            _buildPhotoCards(context),
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
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF22C55E),
                letterSpacing: -0.5,
              ),
              child: const Text('Flipper'),
            ),
          ),
          const Spacer(),
          _buildNavItem('Pricing'),
          const SizedBox(width: 32),
          _buildNavItem('Blog'),
          const SizedBox(width: 32),
          _buildNavItem('About'),
          const SizedBox(width: 32),
          _buildNavItem('Download'),
          const SizedBox(width: 32),
          _buildNavItem('Help'),
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
          _buildSignUpButton(),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextButton(
        onPressed: () => _navigateToLogin(context),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
                    text: 'Safe home\n',
                    style: TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF22C55E), // Green color
                      height: 1.1,
                      letterSpacing: -2,
                    ),
                  ),
                  TextSpan(
                    text: 'for your business',
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
              'Private by default. Works everywhere. Ready for business.',
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
      child: TextButton(
        onPressed: () => _navigateToLogin(context),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return TextButton(
      onPressed: () => _navigateToLogin(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
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

  void _navigateToLogin(BuildContext context) {
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
