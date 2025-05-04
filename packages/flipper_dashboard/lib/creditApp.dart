import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CreditData(),
      child: const CreditApp(),
    ),
  );
}

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  int get availableCredits => _availableCredits;
  
  void buyCredits(int amount) {
    _availableCredits += amount;
    notifyListeners();
  }
}

class CreditApp extends StatelessWidget {
  const CreditApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Credit Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0078D4), // Microsoft blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // Apple's font (fallback to system)
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w300),
          displayMedium: TextStyle(fontWeight: FontWeight.w300),
          titleLarge: TextStyle(fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0078D4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      themeMode: ThemeMode.system,
      home: const CreditHomePage(),
    );
  }
}

class CreditHomePage extends StatefulWidget {
  const CreditHomePage({Key? key}) : super(key: key);
  
  @override
  State<CreditHomePage> createState() => _CreditHomePageState();
}

class _CreditHomePageState extends State<CreditHomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _buyCreditController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show transaction history
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Consumer<CreditData>(
                    builder: (context, creditData, child) {
                      return CreditDisplay(
                        credits: creditData.availableCredits,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isLightMode
                              ? Colors.white.withOpacity(0.8)
                              : colorScheme.surface.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isLightMode
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                          ),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  QuickAmountsSelector(
                    onAmountSelected: (amount) {
                      Provider.of<CreditData>(context, listen: false)
                          .buyCredits(amount);
                      _showSuccessSnackBar(context, amount);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _showSuccessSnackBar(BuildContext context, int amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 16),
            Text('$amount credits added successfully'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 16),
            const Text('Please enter a valid amount'),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class CreditDisplay extends StatelessWidget {
  final int credits;
  final ColorScheme colorScheme;
  
  const CreditDisplay({
    Key? key,
    required this.credits, 
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isLightMode
                ? const Color(0xFF0078D4)  // Microsoft blue
                : const Color(0xFF104E8B), // Dark blue
            isLightMode
                ? const Color(0xFF2B88D8)  // Lighter blue
                : const Color(0xFF1A6BB2), // Medium blue
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isLightMode
                ? Colors.black.withOpacity(0.1)
                : Colors.black.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Credits',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$credits',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Credits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class QuickAmountsSelector extends StatelessWidget {
  final Function(int) onAmountSelected;
  
  const QuickAmountsSelector({
    Key? key,
    required this.onAmountSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickAmountButton(context, 50, colorScheme, isLightMode),
            _buildQuickAmountButton(context, 100, colorScheme, isLightMode),
            _buildQuickAmountButton(context, 500, colorScheme, isLightMode),
          ],
        ),
      ],
    );
  }
  
  Widget _buildQuickAmountButton(
    BuildContext context, 
    int amount, 
    ColorScheme colorScheme,
    bool isLightMode,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton(
          onPressed: () => onAmountSelected(amount),
          style: OutlinedButton.styleFrom(
            backgroundColor: isLightMode
                ? Colors.white
                : colorScheme.surface,
            side: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            '+$amount',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
