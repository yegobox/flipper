import 'visualization_interface.dart';
import 'business_analytics_visualization.dart';
import 'tax_visualization.dart';
import 'structured_data_visualization.dart';

/// Factory class for creating visualizations
class VisualizationFactory {
  /// Create the appropriate visualization for the given data
  static VisualizationInterface? createVisualization(
      String data, dynamic currencyService) {
    // First try the structured data approach (preferred)
    final structuredViz = StructuredDataVisualization(data, currencyService);
    if (structuredViz.canVisualize(data)) {
      return structuredViz;
    }

    // Fall back to legacy visualizations if structured data not found
    if (TaxVisualization(data, currencyService).canVisualize(data)) {
      return TaxVisualization(data, currencyService);
    }

    if (BusinessAnalyticsVisualization(data, currencyService)
        .canVisualize(data)) {
      return BusinessAnalyticsVisualization(data, currencyService);
    }

    // No suitable visualization found
    return null;
  }
}
