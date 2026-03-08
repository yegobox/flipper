# Quick Start Guide - Flipper AI

## For Developers

### First Time Setup

1. **Bootstrap the workspace**
```bash
cd /path/to/flipper
melos bootstrap
```

2. **Verify AI feature package**
```bash
cd packages/flipper_ai_feature
flutter pub get
```

3. **Run flipper_ai app**
```bash
cd apps/flipper_ai
flutter run
```

### Common Commands

```bash
# Generate app icons for flipper_ai
melos run generate:icons:ai

# Run AI feature tests
melos run test:ai_feature

# Run flipper_ai tests
melos run test:ai

# Run all CI tests (includes AI)
melos run test:ci

# Clean and rebuild
flutter clean && melos bootstrap
```

## For Users

### Using flipper_ai (Standalone App)

1. **Download** the flipper_ai app
2. **Login** with your Flipper credentials
3. **Start chatting** with the AI assistant

### Using AI in Flipper App

1. **Open** the Flipper app
2. **Navigate** to AI Assistant (menu or home screen)
3. **Start chatting** with the AI assistant

Both apps provide the **same AI features**!

## Configuration

### Set API Keys

Edit `flipper_models/lib/secrets.dart`:

```dart
abstract class AppSecrets {
  static const String googleKey = 'YOUR_GEMINI_KEY';
  static const String openaiKey = 'YOUR_OPENAI_KEY';
  // ...
}
```

### Configure AI Models

In Supabase, add AI models:

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

## Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### Import errors
```bash
melos bootstrap
```

### Provider errors
```bash
cd packages/flipper_ai_feature
flutter pub run build_runner build --delete-conflicting-outputs
```

## More Information

- **Full Documentation**: See `packages/flipper_ai_feature/README.md`
- **Implementation Details**: See `packages/flipper_ai_feature/IMPLEMENTATION_SUMMARY.md`
- **App Guide**: See `apps/flipper_ai/README.md`

## Support

For issues or questions:
1. Check documentation above
2. Review existing issues
3. Contact the development team
