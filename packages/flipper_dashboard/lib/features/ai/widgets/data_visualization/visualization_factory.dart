import 'dart:ui';
import 'package:flutter/material.dart';

import 'visualization_interface.dart';
import 'business_analytics_visualization.dart';
import 'tax_visualization.dart';
import 'structured_data_visualization.dart';

/// Factory class for creating visualizations
class VisualizationFactory {
  /// Create the appropriate visualization for the given data
  static VisualizationInterface? createVisualization(
      String data, dynamic currencyService, GlobalKey cardKey, VoidCallback onCopyGraph) {
    // First try the structured data approach (preferred)
    final structuredViz = StructuredDataVisualization(data, currencyService, cardKey: cardKey, onCopyGraph: onCopyGraph);
    if (structuredViz.canVisualize(data)) {
      return structuredViz;
    }

    // Fall back to legacy visualizations if structured data not found
    if (TaxVisualization(data, currencyService, cardKey: cardKey, onCopyGraph: onCopyGraph).canVisualize(data)) {
      return TaxVisualization(data, currencyService, cardKey: cardKey, onCopyGraph: onCopyGraph);
    }

    if (BusinessAnalyticsVisualization(data, currencyService, cardKey: cardKey, onCopyGraph: onCopyGraph)
        .canVisualize(data)) {
      return BusinessAnalyticsVisualization(data, currencyService, cardKey: cardKey, onCopyGraph: onCopyGraph);
    }

    // No suitable visualization found
    return null;
  }
}
