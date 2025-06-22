import 'package:flutter/material.dart';

/// Base interface for all data visualizations
abstract class VisualizationInterface {
  /// Build the visualization widget
  Widget build(BuildContext context, {String? currency});

  /// Check if this visualization can handle the given data
  bool canVisualize(String data);
}
