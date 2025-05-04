import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  final int _maxCredits = 1000; // Maximum credit limit

  int get availableCredits => _availableCredits;
  int get maxCredits => _maxCredits;

  void buyCredits(int amount) {
    _availableCredits += amount;
    if (_availableCredits > _maxCredits) {
      _availableCredits = _maxCredits;
    }
    notifyListeners();
  }

  void useCredits(int amount) {
    if (_availableCredits >= amount) {
      _availableCredits -= amount;
      notifyListeners();
    }
  }
}

class CreditApp extends StatelessWidget {
  const CreditApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreditData(),
      child: const CreditHomePage(),
    );
  }
}

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
                    Container(
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
                                final amount =
                                    int.tryParse(_buyCreditController.text);
                                if (amount != null && amount > 0) {
                                  Provider.of<CreditData>(context,
                                          listen: false)
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
                    const SizedBox(height: 30),
                    QuickAmountsSelector(
                      onAmountSelected: (amount) {
                        Provider.of<CreditData>(context, listen: false)
                            .buyCredits(amount);
                        _showSuccessSnackBar(context, amount);
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Use Credits',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<CreditData>(
                      builder: (context, creditData, child) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isLightMode
                                ? Colors.white
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CreditIconWidget(
                                  credits: creditData.availableCredits,
                                  maxCredits: creditData.maxCredits,
                                  size: 80,
                                ),
                              ),
                              TextButton(
                                onPressed: creditData.availableCredits >= 10
                                    ? () {
                                        creditData.useCredits(10);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          _buildSnackBar('Used 10 credits',
                                              Icons.check_circle, Colors.blue),
                                        );
                                      }
                                    : null,
                                child: const Text('Use 10'),
                              ),
                              TextButton(
                                onPressed: creditData.availableCredits >= 50
                                    ? () {
                                        creditData.useCredits(50);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          _buildSnackBar('Used 50 credits',
                                              Icons.check_circle, Colors.blue),
                                        );
                                      }
                                    : null,
                                child: const Text('Use 50'),
                              ),
                              TextButton(
                                onPressed: creditData.availableCredits >= 100
                                    ? () {
                                        creditData.useCredits(100);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          _buildSnackBar('Used 100 credits',
                                              Icons.check_circle, Colors.blue),
                                        );
                                      }
                                    : null,
                                child: const Text('Use 100'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
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

class CreditIconWidget extends StatelessWidget {
  final int credits;
  final int maxCredits;
  final double size;
  final TextStyle? textStyle;

  const CreditIconWidget({
    Key? key,
    required this.credits,
    required this.maxCredits,
    this.size = 60.0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate percentage of credits remaining
    final percentage = maxCredits > 0 ? credits / maxCredits : 0.0;

    // Clamp the percentage between 0 and 1
    final clampedPercentage = percentage.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CreditRingPainter(
          percentage: clampedPercentage,
          strokeWidth: size * 0.1,
        ),
        child: Center(
          child: Text(
            '$credits',
            style: textStyle ??
                TextStyle(
                  color: _getTextColor(clampedPercentage),
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(double percentage) {
    if (percentage > 0.6) {
      return const Color(0xFF2E7D32); // Dark green for high credits
    } else if (percentage > 0.3) {
      return const Color(0xFFF57F17); // Amber for medium credits
    } else {
      return const Color(0xFFB71C1C); // Dark red for low credits
    }
  }
}

class CreditRingPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;

  CreditRingPainter({
    required this.percentage,
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle (light gray)
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw colored progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Define gradient colors based on percentage
    final List<Color> gradientColors = [
      _getColorForPercentage(percentage),
      _getColorForPercentage(percentage * 0.7),
    ];

    // Create gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    progressPaint.shader = SweepGradient(
      colors: gradientColors,
      tileMode: TileMode.clamp,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    ).createShader(rect);

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from the top
      2 * math.pi * percentage, // Sweep angle based on percentage
      false,
      progressPaint,
    );

    // Add inner shadow/glow effect
    if (percentage > 0.05) {
      final innerGlowPaint = Paint()
        ..color = _getColorForPercentage(percentage).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

      canvas.drawCircle(
        center,
        radius - strokeWidth,
        innerGlowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CreditRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  Color _getColorForPercentage(double percentage) {
    // Color transition: green -> yellow -> orange -> red
    if (percentage > 0.7) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage > 0.5) {
      return const Color(0xFF8BC34A); // Light green
    } else if (percentage > 0.3) {
      return const Color(0xFFFFC107); // Amber
    } else if (percentage > 0.2) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }
}

class CreditDisplay extends StatelessWidget {
  final int credits;
  final int maxCredits;
  final ColorScheme colorScheme;

  const CreditDisplay({
    Key? key,
    required this.credits,
    required this.maxCredits,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isLightMode
                ? const Color(0xFF0078D4) // Microsoft blue
                : const Color(0xFF104E8B), // Dark blue
            isLightMode
                ? const Color(0xFF2B88D8) // Lighter blue
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Credits',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CreditIconWidget(
                credits: credits,
                maxCredits: maxCredits,
                size: 60,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: credits / maxCredits,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                credits / maxCredits > 0.5
                    ? Colors.greenAccent
                    : credits / maxCredits > 0.2
                        ? Colors.amberAccent
                        : Colors.redAccent,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Maximum: $maxCredits',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
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
            backgroundColor: isLightMode ? Colors.white : colorScheme.surface,
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
