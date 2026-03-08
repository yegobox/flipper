// Re-export AI feature from flipper_ai_feature package
// This ensures both flipper app and flipper_ai app use the same AI code
export 'package:flipper_ai_feature/flipper_ai_feature.dart';

import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flutter/material.dart';

/// AI Feature Wrapper
/// This class is kept for backward compatibility
/// New code should import directly from flipper_ai_feature
class Ai extends StatelessWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context) => const AiScreen();
}
