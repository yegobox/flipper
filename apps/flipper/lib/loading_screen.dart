import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _dotsController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for logo
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Pulse animation for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Dots animation
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animations
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _dotsController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // Microsoft dark theme
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with subtle glow
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/flipper_logo.png',
                              height: 35.h,
                              width: 35.w,
                              // package: "flipper_rw",
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 8.h),

                // Microsoft-style progress indicator
                Container(
                  width: 60.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF0078D4)),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // App name with Microsoft typography
                Text(
                  'Flipper',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),

                SizedBox(height: 2.h),

                // Loading text with animated dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Initializing',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _dotsController,
                      builder: (context, child) {
                        final progress = _dotsController.value;
                        return SizedBox(
                          width: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(3, (index) {
                              final delay = index * 0.2;
                              final opacity =
                                  (progress - delay).clamp(0.0, 1.0);
                              final showDot = ((progress - delay) % 1.0) > 0.5;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  '.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: showDot
                                        ? Colors.grey[400]
                                        : Colors.transparent,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Text(
                  'Please wait while we set things up',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w300,
                  ),
                ),

                SizedBox(height: 8.h),

                // Microsoft-style footer
                Text(
                  'Powered by yegobox',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
