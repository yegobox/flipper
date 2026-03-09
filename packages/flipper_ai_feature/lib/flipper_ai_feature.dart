/// Flipper AI Feature - Reusable AI module for Flipper applications
///
/// This package provides AI features that can be:
/// 1. Embedded in the main flipper app (via flipper_dashboard)
/// 2. Used as a standalone feature in flipper_ai app
///
/// ## Features
/// - AI chat interface with conversation history
/// - Multi-model support (Gemini, OpenAI, Groq, etc.)
/// - WhatsApp integration for business messaging
/// - File attachment support (Excel, PDF)
/// - Voice message recording
/// - Data visualization (charts, graphs)
/// - Credit-based usage tracking
/// - Business and personal use cases
/// - **Data source connections** (Supabase, PostgreSQL, MySQL, MongoDB, etc.)
///
/// ## Usage
///
/// ### In flipper_dashboard (embedded mode):
/// ```dart
/// import 'package:flipper_ai_feature/flipper_ai_feature.dart';
///
/// // Use the AI screen
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const AiScreen()),
/// );
/// ```
///
/// ### In flipper_ai (standalone app):
/// ```dart
/// import 'package:flipper_ai_feature/flipper_ai_feature.dart';
///
/// // Use AI feature container
/// AIFeatureContainer(
///   config: AIConfig(
///     provider: AIProvider.gemini,
///     apiKey: 'your-api-key',
///   ),
/// )
/// ```
///
/// ### Connect a Data Source:
/// ```dart
/// import 'package:flipper_ai_feature/flipper_ai_feature.dart';
///
/// // Show data source connection dialog
/// showDialog(
///   context: context,
///   builder: (context) => const DataSourceConnectionDialog(),
/// );
///
/// // Navigate to data source management screen
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const DataSourceListScreen()),
/// );
/// ```
library flipper_ai_feature;

// Models
export 'src/models/ai_models.dart';
export 'src/models/data_source/data_source_models.dart';

// Providers
export 'src/providers/ai_provider.dart';
export 'src/providers/conversation_provider.dart';
export 'src/providers/data_source_provider.dart';

// Services
export 'src/services/ai_service.dart';
export 'src/services/data_source/data_source_services.dart';

// Widgets
export 'src/screens/ai_screen.dart';
export 'src/widgets/ai_feature_container.dart';
export 'src/widgets/message_bubble.dart';
export 'src/widgets/ai_input_field.dart';
export 'src/widgets/conversation_list.dart';
export 'src/widgets/welcome_view.dart';
export 'src/widgets/data_source/data_source_widgets.dart';

// Theme
export 'src/theme/ai_theme.dart';
