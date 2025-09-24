import 'dart:io';

// This class is only used on non-web platforms
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Non-web implementation for setting HTTP overrides
void setDevHttpOverrides() {
  HttpOverrides.global = DevHttpOverrides();
}
