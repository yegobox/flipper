// src/widgets/ai_feature_container.dart
/// AI Feature Container - Wrapper for embedding AI features in any app

import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flutter/material.dart';
// import 'ai_screen.dart';

/// AI Feature Container
/// 
/// This widget provides a flexible container for AI features that can be:
/// 1. Embedded as a tab/page in the main flipper app
/// 2. Used as the main screen in the standalone flipper_ai app
/// 3. Integrated as a floating action button or overlay
class AIFeatureContainer extends StatelessWidget {
  final bool fullScreen;
  final String? title;
  final Color? primaryColor;
  final VoidCallback? onClose;

  const AIFeatureContainer({
    super.key,
    this.fullScreen = true,
    this.title = 'AI Assistant',
    this.primaryColor,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (fullScreen) {
      // Full screen mode - use the complete AI screen
      return const AiScreen();
    }

    // Embedded mode - can be used in a tab or page
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: primaryColor ?? Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // AI screen content (without app bar)
          const Expanded(
            child: AiScreen(),
          ),
        ],
      ),
    );
  }
}

/// AI Feature Button - Quick access button to launch AI feature
class AIFeatureButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const AIFeatureButton({
    super.key,
    this.onPressed,
    this.color,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color ?? Theme.of(context).primaryColor,
      child: const Icon(Icons.smart_toy, color: Colors.white),
    );
  }
}

/// AI Feature Drawer Tile - For navigation drawers
class AIFeatureDrawerTile extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;

  const AIFeatureDrawerTile({
    super.key,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.smart_toy,
        color: color ?? Theme.of(context).primaryColor,
      ),
      title: const Text('AI Assistant'),
      onTap: onTap,
    );
  }
}
