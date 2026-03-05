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
  final GlobalKey cardKey;
  final VoidCallback onCopyGraph;

  const DataVisualization({
    super.key,
    required this.data,
    this.currency,
    required this.cardKey,
    required this.onCopyGraph,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyService = ref.watch(currencyServiceProvider);

    // Use the visualization factory to get the appropriate visualization
    final visualization =
        VisualizationFactory.createVisualization(data, currencyService, cardKey, onCopyGraph);

    // If no visualization can handle this data, return an empty widget
    if (visualization == null) {
      return const SizedBox.shrink();
    }

    // Build the visualization with the appropriate context and currency
    return visualization.build(context, currency: currency);
  }
}
