mixin DatabasePath {
  static Future<String> getDatabaseDirectory({String? subDirectory}) async {
    // For web, Ditto uses this string as an IndexedDB namespace/prefix.
    //
    // IMPORTANT: we must respect `subDirectory` here. The desktop/mobile code
    // isolates Ditto stores (e.g. `db2/` vs `login_ditto/<user>`). On web the
    // lock mechanism is a no-op, so returning a single constant namespace would
    // make multiple tabs / login flows contend on the same underlying sqlite3/IDB
    // store and surface "database locked" errors.
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
