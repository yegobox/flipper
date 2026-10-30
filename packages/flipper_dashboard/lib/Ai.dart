// Re-export AI feature from flipper_ai_feature package
// This ensures both flipper app and flipper_ai app use the same AI code
export 'package:flipper_ai_feature/flipper_ai_feature.dart';

import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AI Feature Wrapper
/// This class is kept for backward compatibility
/// New code should import directly from flipper_ai_feature
class Ai extends ConsumerWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every entry to Flo is hidden in local mode; this catches a desktop tab
    // that was already selected when the mode changed.
    if (ref.watch(isLocalModeProvider)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            context.flipperL10n.localModeFloUnavailable,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return const AiScreen();
  }
}
