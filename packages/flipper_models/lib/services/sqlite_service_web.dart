class SqliteService {
  static int execute(String dbPath, String sql,
      [List<Object?> params = const []]) {
    throw UnsupportedError('SqliteService is not supported on web');
  }

  static List<Map<String, Object?>> select(String dbPath, String sql,
      [List<Object?> params = const []]) {
    throw UnsupportedError('SqliteService is not supported on web');
  }

  static int executeTransaction(
      String dbPath, List<String> statements, List<List<Object?>> paramsList) {
    throw UnsupportedError('SqliteService is not supported on web');
  }
}
