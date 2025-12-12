import 'dart:convert';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'logs'),
)
class Log extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? message;
  String? type;
  int? businessId;
  DateTime? createdAt;

  /// Tags stored as JSON string for compatibility with SQLite and Supabase
  @Supabase(
    fromGenerator: '''
      data['tags'] == null
        ? null
        : data['tags'] is String
            ? data['tags'] as String
            : jsonEncode(data['tags'])
    ''',
  )
  @Sqlite(name: 'tags')
  String? tags;

  /// Extra data stored as JSON string for compatibility with SQLite and Supabase
  @Supabase(
    fromGenerator: '''
      data['extra'] == null
        ? null
        : data['extra'] is String
            ? data['extra'] as String
            : jsonEncode(data['extra'])
    ''',
  )
  @Sqlite(name: 'extra')
  String? extra;

  Log({
    String? id,
    this.message,
    this.type,
    this.businessId,
    this.createdAt,
    this.tags,
    this.extra,
  }) : id = id ?? const Uuid().v4();

  /// Convenience getter for parsed tags as Map<String, String>
  Map<String, String>? get parsedTags {
    if (tags == null || tags!.isEmpty) return null;
    try {
      final decoded = jsonDecode(tags!) as Map<String, dynamic>;
      return decoded.cast<String, String>();
    } catch (e) {
      return null;
    }
  }

  /// Convenience method to set tags from Map
  void setTags(Map<String, String>? value) {
    this.tags = value != null ? jsonEncode(value) : null;
  }

  /// Convenience getter for parsed extra as Map<String, dynamic>
  Map<String, dynamic>? get parsedExtra {
    if (extra == null || extra!.isEmpty) return null;
    try {
      return jsonDecode(extra!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Convenience method to set extra from Map
  void setExtra(Map<String, dynamic>? value) {
    this.extra = value != null ? jsonEncode(value) : null;
  }
}
