import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/credit_data.dart';
import '../widgets/credit_display.dart';
import '../widgets/credit_icon_widget.dart';
import '../widgets/quick_amounts_selector.dart';

class CreditHomePage extends StatefulWidget {
  const CreditHomePage({Key? key}) : super(key: key);

  @override
  State<CreditHomePage> createState() => _CreditHomePageState();
}

class _CreditHomePageState extends State<CreditHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _buyCreditController = TextEditingController();
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _buyCreditController.dispose();
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
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
                    _buildAddCreditsSection(
                        context, isLightMode, colorScheme, textTheme),
                    const SizedBox(height: 30),
                    QuickAmountsSelector(
                      onAmountSelected: (amount) {
                        Provider.of<CreditData>(context, listen: false)
                            .buyCredits(amount);
                        _showSuccessSnackBar(context, amount);
                      },
                    ),
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

  Widget _buildAddCreditsSection(BuildContext context, bool isLightMode,
      ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.white : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _buyCreditController,
            keyboardType: TextInputType.number,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Enter amount',
              labelStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isLightMode
                  ? Colors.grey.withOpacity(0.05)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(_buyCreditController.text);
                if (amount != null && amount > 0) {
                  Provider.of<CreditData>(context, listen: false)
                      .buyCredits(amount);
                  _buyCreditController.clear();

                  // Show success message
                  _showSuccessSnackBar(context, amount);
                } else {
                  _showErrorSnackBar(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Credits',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _buildSnackBar(String message, IconData icon, Color color) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Text(message),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  void _showSuccessSnackBar(BuildContext context, int amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('$amount credits added successfully', Icons.check_circle,
          Colors.green.shade600),
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('Please enter a valid amount', Icons.error_outline,
          Colors.red.shade600),
    );
  }
}
