import 'package:flutter/foundation.dart';
import 'package:flipper_web/core/utils/platform.dart';

/// Native iOS/macOS builds skip the marketing home page and open PIN login.
bool get opensOnLoginScreen => !kIsWeb && (isIOS || isMacOS);

/// First route for an unauthenticated session.
String get unauthenticatedEntryLocation =>
    opensOnLoginScreen ? '/login' : '/';
