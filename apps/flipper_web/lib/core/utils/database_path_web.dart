mixin DatabasePath {
  static Future<String> getDatabaseDirectory({String? subDirectory}) async {
    // For web, Ditto Flutter uses an in-memory store (see Ditto install guide).
    // This string is still passed as the persistence namespace for the session.
    final base = 'flipper_db';
    final sub = subDirectory?.trim();
    if (sub == null || sub.isEmpty) return base;
    // Keep it path-like but IDB-safe.
    return '${base}__${sub.replaceAll(RegExp(r"[^a-zA-Z0-9._-]+"), "_")}';
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
