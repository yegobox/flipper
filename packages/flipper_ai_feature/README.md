# Flipper AI Feature - Architecture & Usage Guide

## Overview

The AI feature has been extracted from `flipper_dashboard` into a shared package `flipper_ai_feature` that can be used by:
1. **flipper_ai** - Standalone AI application
2. **flipper** (via flipper_dashboard) - Main Flipper app with embedded AI feature

Both applications use the **same shared code**, ensuring no regression in functionality.

## Architecture

```
flipper/
├── apps/
│   ├── flipper/                    # Main Flipper app
│   │   └── uses flipper_dashboard → flipper_ai_feature
│   ├── flipper_ai/                 # Standalone AI app
│   │   └── uses flipper_ai_feature directly
│   └── flipper_auth/               # Authentication app (shared auth)
│
├── packages/
│   ├── flipper_ai_feature/         # ★ SHARED AI FEATURE PACKAGE
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/         # AI models (AIModel, etc.)
│   │   │   │   ├── providers/      # Riverpod providers
│   │   │   │   ├── services/       # AI services
│   │   │   │   ├── widgets/        # UI components
│   │   │   │   ├── theme/          # AI theme constants
│   │   │   │   └── utils/          # Utility functions
│   │   │   └── flipper_ai_feature.dart
│   │   └── pubspec.yaml
│   ├── flipper_dashboard/          # Dashboard package (now uses flipper_ai_feature)
│   ├── flipper_models/             # Shared models
│   └── flipper_services/           # Shared services
```

## Key Components

### 1. flipper_ai_feature Package

The core shared package containing all AI functionality:

#### Models (`lib/src/models/`)
- `AIModel` - AI model configuration (Gemini, OpenAI, etc.)
- Business logic for AI providers

#### Providers (`lib/src/providers/`)
- `ai_provider.dart` - Riverpod providers for AI operations
- `conversation_provider.dart` - Conversation state management
- `whatsapp_message_provider.dart` - WhatsApp integration

#### Services (`lib/src/services/`)
- `ai_service.dart` - AI API interactions
- `ai_strategy.dart` - Strategy pattern for different AI providers

#### Widgets (`lib/src/widgets/`)
- `ai_screen.dart` - Main AI screen (full-featured)
- `ai_feature_container.dart` - Embeddable AI container
- `message_bubble.dart` - Chat message UI
- `ai_input_field.dart` - Input field with voice/file support
- `conversation_list.dart` - Conversation history
- `welcome_view.dart` - Welcome screen
- `data_visualization.dart` - Charts and graphs

#### Theme (`lib/src/theme/`)
- `ai_theme.dart` - Consistent styling across apps

### 2. flipper_ai (Standalone App)

Uses `flipper_ai_feature` directly with authentication from `flipper_auth`:

```dart
// apps/flipper_ai/lib/main.dart
import 'package:flipper_auth/features/auth/views/login_screen.dart';
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

// Login uses flipper_auth
// After login, shows AiScreen from flipper_ai_feature
```

### 3. flipper_dashboard (Embedded Mode)

Re-exports `flipper_ai_feature` for use in main flipper app:

```dart
// packages/flipper_dashboard/lib/features/ai/
// Now re-exports from flipper_ai_feature
export 'package:flipper_ai_feature/flipper_ai_feature.dart';
```

## Usage

### In flipper_ai (Standalone)

```dart
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

class AiHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AiScreen(); // Full AI screen from shared package
  }
}
```

### In flipper_dashboard (Embedded)

```dart
import 'package:flipper_dashboard/features/ai/ai.dart';
// or
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

// Use in navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AiScreen()),
);

// Or embed in a tab/page
AIFeatureContainer(
  fullScreen: false,
  onClose: () => Navigator.pop(context),
)
```

## Authentication

Both apps use the **same authentication** from `flipper_auth`:

```dart
// Authentication is handled by flipper_auth package
// Both flipper_ai and flipper app use Supabase auth
import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Check if user is authenticated
final user = Supabase.instance.client.auth.currentUser;

// Listen to auth changes
Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  // Handle auth state changes
});
```

## Dependencies

### flipper_ai_feature depends on:
- `flipper_services` - Business logic and strategies
- `flipper_models` - Data models
- `supabase_models` - Supabase-specific models
- `flipper_ui` - UI components

### flipper_ai (standalone) depends on:
- `flipper_auth` - Authentication
- `flipper_ai_feature` - AI functionality
- `flipper_web` - Shared web utilities

## No Regression Guarantee

The AI feature works **identically** in both apps because:

1. **Same Code**: Both use `flipper_ai_feature` package
2. **Same Auth**: Both use `flipper_auth` authentication
3. **Same Services**: Both use `flipper_services` strategies
4. **Same Models**: Both use `supabase_models` for data

Any update to `flipper_ai_feature` automatically updates both apps.

## Development Workflow

### Making Changes to AI Feature

1. **Edit** files in `packages/flipper_ai_feature/lib/src/`
2. **Test** in both:
   - `apps/flipper_ai` (standalone)
   - `apps/flipper` → flipper_dashboard (embedded)
3. **Run** build_runner if providers changed:
   ```bash
   cd packages/flipper_ai_feature
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Adding New AI Providers

1. Add provider configuration in `AIModel`
2. Implement strategy in `ai_service.dart`
3. Update `ai_provider.dart` with new provider logic

### Testing

```bash
# Test flipper_ai_feature package
cd packages/flipper_ai_feature
flutter test

# Test flipper_ai app
cd apps/flipper_ai
flutter test

# Test flipper app (includes AI feature)
cd apps/flipper
flutter test
```

## Configuration

### AI Models

AI models are configured in Supabase `ai_models` table:

```sql
INSERT INTO ai_models (
  name, model_id, provider, api_url, 
  is_active, is_default, is_paid_only
) VALUES (
  'Gemini Pro',
  'gemini-pro',
  'Google',
  'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=',
  true,
  true,
  false
);
```

### API Keys

Store API keys in `flipper_models/lib/secrets.dart`:

```dart
abstract class AppSecrets {
  static const String googleKey = 'your-gemini-key';
  static const String openaiKey = 'your-openai-key';
  // ...
}
```

## File Structure

```
packages/flipper_ai_feature/
├── lib/
│   ├── flipper_ai_feature.dart          # Main export
│   └── src/
│       ├── models/
│       │   └── ai_models.dart           # AIModel, AIConfig
│       ├── providers/
│       │   ├── ai_provider.dart         # Riverpod providers
│       │   ├── conversation_provider.dart
│       │   └── whatsapp_message_provider.dart
│       ├── services/
│       │   ├── ai_service.dart          # AI API calls
│       │   └── ai_strategy.dart         # Strategy pattern
│       ├── widgets/
│       │   ├── ai_screen.dart           # Main screen
│       │   ├── ai_feature_container.dart
│       │   ├── message_bubble.dart
│       │   ├── ai_input_field.dart
│       │   ├── conversation_list.dart
│       │   ├── welcome_view.dart
│       │   └── data_visualization.dart
│       ├── theme/
│       │   └── ai_theme.dart            # Theme constants
│       └── utils/
│           └── visualization_utils.dart # Chart utilities
├── pubspec.yaml
└── README.md
```

## Troubleshooting

### Import Errors

Make sure to run:
```bash
melos bootstrap
# or
flutter pub get
```

### Provider Errors

If Riverpod providers fail:
```bash
cd packages/flipper_ai_feature
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Authentication Issues

Verify Supabase configuration in both apps matches `flipper_auth`.

## Future Enhancements

1. **Multi-modal AI**: Image analysis, voice processing
2. **Offline Support**: Cache conversations locally
3. **Custom Themes**: Allow businesses to customize AI appearance
4. **Analytics**: Track AI usage and performance
5. **More Providers**: Anthropic, Cohere, etc.

## Contributing

When contributing to the AI feature:
1. Keep code in `flipper_ai_feature` package
2. Ensure compatibility with both standalone and embedded modes
3. Update this README with new features
4. Test in both `flipper_ai` and `flipper` apps
