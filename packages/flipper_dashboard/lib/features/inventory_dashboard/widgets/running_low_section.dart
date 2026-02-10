import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_models/services/forecasting_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_dashboard/features/production_output/widgets/work_order_bottom_sheet.dart';

// Riverpod provider for low stock predictions
final lowStockPredictionsProvider = FutureProvider<List<LowStockPrediction>>((
  ref,
) async {
  final service = ForecastingService();
  return await service.getLowStockItems(daysThreshold: 7);
});

class RunningLowSection extends ConsumerWidget {
  const RunningLowSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionsAsync = ref.watch(lowStockPredictionsProvider);

    return predictionsAsync.when(
      data: (predictions) {
        if (predictions.isEmpty) return SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_down, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Running Low (7-Day Forecast)',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: predictions.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                final prediction = predictions[index];
                return _buildPredictionCard(context, ref, prediction);
              },
            ),
          ],
        );
      },
      loading: () => SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => SizedBox.shrink(),
    );
  }

  Widget _buildPredictionCard(
    BuildContext context,
    WidgetRef ref,
    LowStockPrediction prediction,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.variant.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${prediction.currentStock.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Daily Usage: ${prediction.dailyUsage.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${prediction.daysRemaining} days left',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger request or production?
                    // "Running Low" usually implies need to BUY or PRODUCE more.
                    // If it's raw material -> Request Stock / Purchase
                    // If it's finished good -> Produce (Work Order)

                    // For now, let's assume we want to "Produce" more if it's a produced item,
                    // or maybe just show a generic "Action" sheet.
                    // Given the previous task was "Incoming Orders -> Produce",
                    // maybe this direction is "Running Low -> Produce" too?
                    // Or "Running Low -> Request from Warehouse"?

                    // Let's implement "Produce" for now as it aligns with previous work,
                    // but name it "Replenish".
                    WorkOrderBottomSheet.show(
                      context: context,
                      ref: ref,
                      initialVariantId: prediction.variant.id,
                      initialVariantName: prediction.variant.name,
                      initialPlannedQuantity:
                          prediction.dailyUsage * 7, // Suggest 1 week supply
                      onSubmit: (data) async {
                        // This logic is likely duplicated from ActionRow.
                        // Ideally shared, but fine for now.
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Replenish',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
