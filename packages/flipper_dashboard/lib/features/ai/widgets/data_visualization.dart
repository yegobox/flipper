import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import 'data_visualization/index.dart';

/// Main widget for visualizing data from AI responses
///
/// This widget acts as a facade for the visualization system,
/// delegating to the appropriate visualization implementation
/// based on the content of the data.
class DataVisualization extends ConsumerWidget {
  final String data;
  final String? currency;

  const DataVisualization({
    super.key,
    required this.data,
    this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyService = ref.watch(currencyServiceProvider);

    // Use the visualization factory to get the appropriate visualization
    final visualization =
        VisualizationFactory.createVisualization(data, currencyService);

    // If no visualization can handle this data, return an empty widget
    if (visualization == null) {
      return const SizedBox.shrink();
    }

    // Build the visualization with the appropriate context and currency
    return visualization.build(context, currency: currency);
  }
}
