import 'visualization_interface.dart';
import 'business_analytics_visualization.dart';
import 'tax_visualization.dart';

/// Factory class for creating visualizations
class VisualizationFactory {

  /// Create the appropriate visualization for the given data
  static VisualizationInterface? createVisualization(
      String data, dynamic currencyService) {
    // Try to find a visualization that can handle this data
    if (TaxVisualization(data, currencyService).canVisualize(data)) {
      return TaxVisualization(data, currencyService);
    }
    
    if (BusinessAnalyticsVisualization(data, currencyService).canVisualize(data)) {
      return BusinessAnalyticsVisualization(data, currencyService);
    }
    
    // No suitable visualization found
    return null;
  }
}
