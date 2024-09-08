import 'dart:math';

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BranchPerformance extends StatefulHookConsumerWidget {
  @override
  BranchPerformanceState createState() => BranchPerformanceState();
}

class BranchPerformanceState extends ConsumerState<BranchPerformance>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(branchesProvider);
    final items =
        ref.watch(stocksProvider((branchId: ProxyService.box.getBranchId()!)));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Inventory Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Add Dropdown for branches
            DropdownButton<Branch>(
              value: branches.isNotEmpty ? branches.first : null,
              onChanged: (Branch? newBranch) {
                // Handle branch selection change
                if (newBranch != null) {
                  ref.read(selectedBranchProvider.notifier).state = newBranch;
                }
              },
              items: branches.map<DropdownMenuItem<Branch>>((Branch branch) {
                return DropdownMenuItem<Branch>(
                    value: branch, child: Text(branch.name!));
              }).toList(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BestSellingItemCard(items: items),
                    SizedBox(height: 20),
                    StockVisualizationCard(items: items),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ItemDetailCard(item: items[index]),
                  childCount: items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class StockVisualizationCard extends StatelessWidget {
  final List<Stock> items;

  const StockVisualizationCard({Key? key, required this.items})
      : super(key: key);

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
            AnimatedStockBarChart(items: items), // Adding an animated chart
          ],
        ),
      ),
    );
  }
}

class AnimatedStockBarChart extends StatefulWidget {
  final List<Stock> items;

  const AnimatedStockBarChart({Key? key, required this.items})
      : super(key: key);

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
      vsync: this, // Use the State class for TickerProvider
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose the controller to free up resources
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
              animationValue: _animation.value, // Pass the animation value
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

  StockBarChartPainter({required this.items, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = size.width / (items.length * 2 + 1);
    final double maxStock =
        items.map((e) => e.currentStock.toDouble()).reduce(max);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final barHeight = (item.currentStock / maxStock) *
          size.height *
          animationValue; // Use animated height
      final rect = Rect.fromLTRB(
        (i * 2 + 1) * barWidth, // left
        size.height - barHeight, // top
        (i * 2 + 2) * barWidth, // right
        size.height, // bottom
      );

      paint.color = Colors.indigo
          .withOpacity(animationValue); // Adjust opacity with animation
      canvas.drawRect(rect, paint);

      // Draw stock count above the bars
      final countPainter = TextPainter(
        text: TextSpan(
          text: item.currentStock.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      countPainter.layout();
      countPainter.paint(
        canvas,
        Offset((i * 2 + 1.5) * barWidth - countPainter.width / 2,
            size.height - barHeight - 15),
      );

      // Draw item label below the bars
      final labelPainter = TextPainter(
        text: TextSpan(
          text: item.variant?.productName ?? "-",
          style: TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset((i * 2 + 1.5) * barWidth - labelPainter.width / 2,
            size.height + 5), // Position below the bar
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ItemDetailCard extends StatelessWidget {
  final Stock item;

  const ItemDetailCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.variant?.productName ?? "-",
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
