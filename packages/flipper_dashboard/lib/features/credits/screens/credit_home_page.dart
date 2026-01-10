import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/credit_data.dart';
import '../widgets/credit_display.dart';
import '../widgets/credit_icon_widget.dart';
import '../widgets/credit_purchase_widget.dart';

class CreditHomePage extends StatefulWidget {
  const CreditHomePage({Key? key}) : super(key: key);

  @override
  State<CreditHomePage> createState() => _CreditHomePageState();
}

class _CreditHomePageState extends State<CreditHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    // _buyCreditController.dispose();
    // _phoneNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightMode
          ? const Color(0xFFF5F5F7) // Apple light background
          : const Color(0xFF121212), // Dark mode background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Credit Hub',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<CreditData>(
            builder: (context, creditData, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CreditIconWidget(
                  credits: creditData.availableCredits,
                  maxCredits: creditData.maxCredits,
                  size: 40,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Consumer<CreditData>(
                      builder: (context, creditData, child) {
                        return CreditDisplay(
                          credits: creditData.availableCredits,
                          maxCredits: creditData.maxCredits,
                          colorScheme: colorScheme,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Add Credits',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CreditPurchaseWidget(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
