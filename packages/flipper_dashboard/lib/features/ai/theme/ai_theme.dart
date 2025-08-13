import 'package:flutter/material.dart';

/// Theme constants for the AI feature.
/// Used across all AI-related widgets to maintain consistent styling.
/// Inspired by modern chat UIs like Microsoft Copilot and QuickBooks.
abstract class AiTheme {
  // Primary brand color - a modern, professional blue
  static const primaryColor = Color(0xFF0078D4);

  // Secondary color for accents, icons, and less prominent elements
  static const secondaryColor = Color(0xFF5D5D5D);

  // Background color for the main chat screen - a very light, clean grey
  static const backgroundColor = Color(0xFFF8F9FA);

  // Surface color for cards, conversation lists, and elevated elements
  static const surfaceColor = Color(0xFFFFFFFF);

  // Input field background color
  static const inputBackgroundColor = Color(0xFFF1F1F1);

  // User message bubble background color
  static const userMessageColor = primaryColor;
  static const userBubbleColor = primaryColor;

  // AI message bubble background color
  static const assistantMessageColor = Color(0xFFFFFFFF);
  static const aiBubbleColor = Color(0xFFFFFFFF);

  // Text colors
  static const onPrimaryColor = Colors.white;
  static const onAssistantMessageColor = Color(0xFF202124);
  static const textColor = Color(0xFF333333);
  static const hintColor = Color(0xFF8A8A8A);

  // Border color
  static const borderColor = Color(0xFFE0E0E0);

  // This class is not meant to be instantiated
  const AiTheme._();
}