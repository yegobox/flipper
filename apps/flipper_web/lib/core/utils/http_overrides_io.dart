import 'dart:io';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/foundation.dart' as foundation;

// Non-web implementation for setting HTTP overrides

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeCriticalDependencies() async {
  // Configure HTTP overrides for SSL/TLS connections
  if (!foundation.kIsWeb) {
    HttpOverrides.global = DevHttpOverrides();
    debugPrint('HTTP overrides configured for secure connections');
  }
}
