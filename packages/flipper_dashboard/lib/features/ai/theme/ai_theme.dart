import 'package:flutter/material.dart';

/// Theme constants for the AI feature.
/// Used across all AI-related widgets to maintain consistent styling.
abstract class AiTheme {
  /// Primary brand color used for user messages and key actions
  static const primaryColor = Color(0xFF4355B7);

  /// Secondary color used for icons and less prominent elements
  static const secondaryColor = Color(0xFF6B7280);

  /// Background color for the main AI screen
  static const backgroundColor = Color(0xFFF9FAFB);

  /// Surface color for cards and elevated elements
  static const surfaceColor = Color(0xFFFFFFFF);

  /// Background color for input fields and interactive elements
  static const inputBackgroundColor = Color(0xFFF3F4F6);

  // This class is not meant to be instantiated
  const AiTheme._();
}
