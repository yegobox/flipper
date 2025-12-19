mixin DatabasePath {
  static Future<String> getDatabaseDirectory() async {
    // For web, we return a simple string which Ditto uses as an IndexedDB namespace/prefix
    return "flipper_db";
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
