# Flipper AI - Standalone AI Application

Flipper AI is a standalone application that provides AI-powered features for Flipper users. It shares the same AI feature code with the main Flipper app through the `flipper_ai_feature` package.

## Features

- **AI Chat Interface**: Chat with AI assistant for business insights
- **Multi-Model Support**: Support for Gemini, OpenAI, Groq, and other AI providers
- **WhatsApp Integration**: Send and receive WhatsApp messages via AI
- **File Analysis**: Upload and analyze Excel, PDF files
- **Voice Messages**: Record and send voice messages
- **Data Visualization**: View business analytics as charts and graphs
- **Conversation History**: Access all previous conversations
- **Credit System**: Usage tracking with credit-based access

## Architecture

```
flipper_ai/
├── lib/
│   └── main.dart              # App entry point
├── pubspec.yaml               # Dependencies
└── pubspec_overrides.yaml     # Local package overrides

Dependencies:
├── flipper_auth              # Authentication (same as flipper app)
├── flipper_ai_feature        # AI features (shared package)
├── flipper_models            # Data models
└── flipper_services          # Business logic
```

## Getting Started

### Prerequisites

1. Flutter SDK (>=3.0.0 <4.0.0)
2. Supabase account configured
3. AI API keys (Gemini, OpenAI, etc.)

### Installation

1. **Clone the repository**
```bash
cd /path/to/flipper
```

2. **Bootstrap dependencies with Melos**
```bash
dart pub global activate melos
melos bootstrap
```

3. **Configure environment**
   - Update `flipper_models/lib/secrets.dart` with your API keys
   - Ensure Supabase is configured

4. **Run the app**
```bash
cd apps/flipper_ai
flutter run
```

## Authentication

Flipper AI uses the same authentication system as the main Flipper app:

- **Supabase Auth**: Email/password, OAuth providers
- **Session Management**: Persistent sessions
- **TOTP Support**: Two-factor authentication

Users can log in with their existing Flipper credentials.

## AI Configuration

### AI Models

AI models are configured in the Supabase `ai_models` table. Example:

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
  static const String groqKey = 'your-groq-key';
  // ...
}
```

## Usage

### Basic Usage

1. **Login**: Use your Flipper credentials
2. **Start Chat**: Tap the message input to start chatting
3. **Ask Questions**: Ask about sales, inventory, analytics, etc.
4. **View Results**: See responses with visualizations

### Advanced Features

#### File Analysis

1. Tap the attachment button (+)
2. Select Excel or PDF file
3. Ask questions about the file content

#### Voice Messages

1. Hold the microphone button
2. Record your message
3. Slide up to lock or release to send

#### WhatsApp Integration

1. Configure WhatsApp Business API
2. AI can reply to customer messages
3. Track message delivery status

## Development

### Project Structure

```
apps/flipper_ai/
├── lib/
│   └── main.dart           # Main app - uses flipper_ai_feature
├── android/                # Android platform files
├── ios/                    # iOS platform files
├── web/                    # Web platform files
└── pubspec.yaml           # Dependencies
```

### Making Changes

The AI feature code is in `packages/flipper_ai_feature`. To make changes:

1. **Edit** files in `packages/flipper_ai_feature/lib/src/`
2. **Test** in both `flipper_ai` and `flipper` apps
3. **Run** build_runner if providers changed:
   ```bash
   cd packages/flipper_ai_feature
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Testing

```bash
# Run tests
cd apps/flipper_ai
flutter test

# Run with coverage
flutter test --coverage

# Run on specific device
flutter run -d <device_id>
```

## Deployment

### Android

```bash
cd apps/flipper_ai
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
cd apps/flipper_ai
flutter build ios --release
```

### Web

```bash
cd apps/flipper_ai
flutter build web --release
```

## Troubleshooting

### Import Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
```

### Provider Errors

```bash
# Rebuild generated files
cd packages/flipper_ai_feature
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Authentication Issues

1. Verify Supabase configuration
2. Check API keys in `secrets.dart`
3. Ensure network connectivity

## Differences from Flipper App

| Feature | Flipper AI | Flipper App |
|---------|-----------|-------------|
| Authentication | Same (flipper_auth) | Same (flipper_auth) |
| AI Features | Full | Full |
| Other Features | AI only | All (POS, Inventory, etc.) |
| Package Size | Smaller | Larger |
| Use Case | AI-focused | Full business management |

## Contributing

1. Keep AI feature code in `packages/flipper_ai_feature`
2. Ensure compatibility with both apps
3. Update documentation
4. Test in both standalone and embedded modes

## License

Same as main Flipper project

## Support

For issues or questions:
1. Check the main Flipper documentation
2. Review `packages/flipper_ai_feature/README.md`
3. Contact the development team
