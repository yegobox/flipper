// ignore_for_file: unused_result

import 'dart:math';

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'BranchDropdown.dart';

class BranchPerformance extends StatefulHookConsumerWidget {
  @override
  BranchPerformanceState createState() => BranchPerformanceState();
}

class BranchPerformanceState extends ConsumerState<BranchPerformance>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final branch = ref.watch(selectedBranchProvider);
    final items = ref.watch(stocksProvider(
        (branchId: branch?.serverId ?? ProxyService.box.getBranchId()!)));
    final selectedItemId = ref.watch(selectedItemProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // Clean, light background
        elevation: 0, // Flat design, no shadow
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w600, // Semi-bold for clean emphasis
                  fontSize: 18, // Moderately sized font
                  color: Colors.black, // Dark text for contrast
                ),
              ),
              BranchDropdown(),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: items.isNotEmpty
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BestSellingItemCard(items: items),
                          SizedBox(height: 20),
                          StockVisualizationCard(
                            items: items,
                            selectedItemId: selectedItemId,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ItemDetailCard(
                          item: items[index],
                          isSelected: items[index].id == selectedItemId,
                          onTap: () {
                            ref.read(selectedItemProvider.notifier).state =
                                items[index].id.toString();
                          },
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

class StockVisualizationCard extends StatelessWidget {
  final List<Stock> items;
  final String? selectedItemId;

  const StockVisualizationCard({
    Key? key,
    required this.items,
    this.selectedItemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock Count',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            AnimatedStockBarChart(
              items: items,
              selectedItemId: selectedItemId,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedStockBarChart extends StatefulWidget {
  final List<Stock> items;
  final String? selectedItemId;

  const AnimatedStockBarChart({
    Key? key,
    required this.items,
    this.selectedItemId,
  }) : super(key: key);

  @override
  _AnimatedStockBarChartState createState() => _AnimatedStockBarChartState();
}

class _AnimatedStockBarChartState extends State<AnimatedStockBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: 200,
          child: CustomPaint(
            size: Size(double.infinity, 200),
            painter: StockBarChartPainter(
              items: widget.items,
              animationValue: _animation.value,
              selectedItemId: widget.selectedItemId,
            ),
          ),
        );
      },
    );
  }
}

class StockBarChartPainter extends CustomPainter {
  final List<Stock> items;
  final double animationValue;
  final String? selectedItemId;

  StockBarChartPainter({
    required this.items,
    required this.animationValue,
    this.selectedItemId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final filteredItems = items.where((item) => item.currentStock > 1).toList();

    if (filteredItems.isEmpty) return;

    final double barWidth = size.width / (filteredItems.length * 2 + 1);
    final double maxStock =
        filteredItems.map((e) => e.currentStock.toDouble()).reduce(max);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < filteredItems.length; i++) {
      final item = filteredItems[i];
      final barHeight =
          (item.currentStock / maxStock) * size.height * animationValue;

      final rect = Rect.fromLTRB(
        (i * 2 + 1) * barWidth,
        size.height - barHeight,
        (i * 2 + 2) * barWidth,
        size.height,
      );

      paint.color = item.id.toString() == selectedItemId
          ? Colors.red.withOpacity(animationValue)
          : Colors.indigo.withOpacity(animationValue);
      canvas.drawRect(rect, paint);

      _drawText(
        canvas,
        _formatNumber(item.currentStock.toInt()),
        Offset((i * 2 + 1.5) * barWidth, size.height - barHeight - 15),
        10,
        FontWeight.bold,
        Colors.black,
      );

      // Removed the bottom label drawing
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, double fontSize,
      FontWeight fontWeight, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, 0));
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ItemDetailCard extends StatelessWidget {
  final Stock item;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemDetailCard({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.black26,
        color: isSelected ? Colors.blue.shade50 : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variant?.productName ??
                          (item.variant?.id ?? "-").toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text('Sold: ${item.sold}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('In Stock: ${item.currentStock}',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              CircularStockIndicator(
                stock: item.currentStock.toInt(),
                maxStock: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ... (previous code remains the same)

class BestSellingItemCard extends StatelessWidget {
  final List<Stock> items;

  const BestSellingItemCard({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestSeller = items.reduce((a, b) => a.sold! > b.sold! ? a : b);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best-Selling Item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bestSeller.variant!.productName!,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Sold: ${bestSeller.sold}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularStockIndicator extends StatelessWidget {
  final int stock;
  final int maxStock;

  const CircularStockIndicator({
    Key? key,
    required this.stock,
    required this.maxStock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: CircularStockPainter(
          percentage: stock / maxStock,
          baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          percentageColor: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Text(
            '${(stock / maxStock * 100).round()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularStockPainter extends CustomPainter {
  final double percentage;
  final Color baseColor;
  final Color percentageColor;

  CircularStockPainter({
    required this.percentage,
    required this.baseColor,
    required this.percentageColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = baseColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final percentagePaint = Paint()
      ..color = percentageColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    canvas.drawCircle(center, radius, basePaint);
    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, percentagePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// ... (rest of the previous code remains the same)

// Add this provider at the top of your file or in a separate providers file
final selectedItemProvider = StateProvider<String?>((ref) => null);
