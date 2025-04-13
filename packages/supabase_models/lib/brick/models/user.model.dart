import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'users'),
)
class User extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String? name;
  // key will either be phone number or email
  final String? key;
  final String? uuid;

  User({
    String? id,
    this.name,
    this.key,
    this.uuid,
  }) : id = id ?? const Uuid().v4();
  // copyWith method
  User copyWith({
    String? id,
    String? name,
    String? key,
    String? uuid,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      key: key ?? this.key,
      uuid: uuid ?? this.uuid,
    );
  }
}
