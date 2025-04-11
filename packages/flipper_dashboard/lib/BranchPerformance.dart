// ignore_for_file: unused_result

import 'dart:math';

import 'package:flipper_models/db_model_export.dart';
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
    final items = ref.watch(variantsProvider(
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
        child: items.when(
          data: (data) => data.isNotEmpty // data is the list of stocks
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BestSellingItemCard(items: data),
                            SizedBox(height: 20),
                            StockVisualizationCard(
                              items: data,
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
                            variant: data[index],
                            isSelected: data[index].id == selectedItemId,
                            onTap: () {
                              ref.read(selectedItemProvider.notifier).state =
                                  data[index].id.toString();
                            },
                          ),
                          childCount: data.length,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text('No items found.')), // Show empty state message
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
              child:
                  Text('Error loading items: $error')), // Handle loading state
        ),
      ),
    );
  }
}

class StockVisualizationCard extends StatelessWidget {
  final List<Variant> items;
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
  final List<Variant> items;
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
  final List<Variant> items;
  final double animationValue;
  final String? selectedItemId;

  StockBarChartPainter({
    required this.items,
    required this.animationValue,
    this.selectedItemId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Filter out items where stock is null or currentStock is null or less than/equal 0
    final filteredItems = items
        .where(
            (item) => item.stock != null && (item.stock?.currentStock ?? 0) > 0)
        .toList();

    if (filteredItems.isEmpty) return;

    final double barWidth = size.width / (filteredItems.length * 2 + 1);
    // Calculate maxStock from filtered items, defaulting to 1 if no stock is available
    final double maxStock = filteredItems.isNotEmpty
        ? filteredItems
            .map((e) => e.stock?.currentStock?.toDouble() ?? 0)
            .reduce(max)
        : 1; // Ensure maxStock is at least 1 to prevent division by zero

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < filteredItems.length; i++) {
      final item = filteredItems[i];
      // Calculate barHeight, ensure maxStock is not zero
      double barHeight = 0;
      if (maxStock > 0) {
        barHeight = ((item.stock?.currentStock ?? 0) / maxStock) *
            size.height *
            animationValue;
      }

      final rect = Rect.fromLTRB(
        (i * 2 + 1) * barWidth,
        size.height - barHeight,
        (i * 2 + 2) * barWidth,
        size.height,
      );

      paint.color = item.id.toString() == selectedItemId
          ? Colors.red.withValues(red: animationValue)
          : Colors.indigo.withValues(blue: animationValue);
      canvas.drawRect(rect, paint);
      item.id.toString() == selectedItemId
          ? _drawText(
              canvas,
              _formatNumber(item.stock?.currentStock ?? 0),
              Offset((i * 2 + 1.5) * barWidth, size.height - barHeight - 15),
              10,
              FontWeight.bold,
              Colors.black,
            )
          : SizedBox.shrink();
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

  String _formatNumber(double number) {
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
  final Variant variant;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemDetailCard({
    Key? key,
    required this.variant,
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
                    FutureBuilder<Variant?>(
                      future: ProxyService.strategy.getVariant(id: variant.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final variant = snapshot.data as Variant;
                          return Text(
                            variant.productName ?? "-",
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                        'Sold: ${variant.stock?.initialStock ?? 0 - (variant.stock?.currentStock ?? 0)}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('In Stock: ${variant.stock?.currentStock}',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              CircularStockIndicator(
                stock: variant.stock?.currentStock?.toInt() ?? 0,
                maxStock: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BestSellingItemCard extends StatelessWidget {
  final List<Variant> items;

  const BestSellingItemCard({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// best selling item is the item that has the currentStock is the lowest
    final bestSeller = items.reduce((current, next) {
      double currentSold = (current.stock?.initialStock ?? 0) -
          (current.stock?.currentStock ?? 0);
      double nextSold =
          (next.stock?.initialStock ?? 0) - (next.stock?.currentStock ?? 0);
      return currentSold > nextSold ? current : next;
    });
    double itemsSold =
        bestSeller.stock?.initialStock == bestSeller.stock?.currentStock
            ? 1
            : (bestSeller.stock?.initialStock ?? 0) -
                (bestSeller.stock?.currentStock ?? 0);
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
                    FutureBuilder(
                      future:
                          ProxyService.strategy.getVariant(id: bestSeller.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final variant = snapshot.data as Variant;
                          return Text(
                            variant.productName!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text('No data');
                        }
                      },
                    ),
                    Text(
                      'Sold: $itemsSold',
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
            '${(stock / maxStock * 100).roundToDouble() / 100}%',
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

final selectedItemProvider = StateProvider<String?>((ref) => null);
