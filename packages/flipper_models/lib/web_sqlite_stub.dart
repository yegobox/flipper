// web_sqlite_stub.dart
class ResultSet {
  bool get isEmpty => true;
  Map<String, dynamic> get single => {};
  List<Map<String, dynamic>> get rows => [];
}

class Database {
  ResultSet select(String query, [List<dynamic>? params]) {
    return ResultSet();
  }

  void execute(String sql, [List<dynamic>? params]) {
    // No-op for web
  }

  void dispose() {
    // No-op for web
  }

  void close() {
    // No-op for web
  }
}

class Sqlite3 {
  Database open(String path) {
    return Database();
  }
}

final sqlite3 = Sqlite3();
