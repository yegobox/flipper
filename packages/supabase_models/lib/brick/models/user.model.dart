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

  final int? pin;
  final bool? editId;
  final bool? isExternal;
  final String? ownership;
  final int? groupId;
  final bool? external;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? phoneNumber;

  User({
    String? id,
    this.name,
    this.key,
    this.uuid,
    this.pin,
    this.editId,
    this.isExternal,
    this.ownership,
    this.groupId,
    this.external,
    this.updatedAt,
    this.deletedAt,
    this.phoneNumber,
  }) : id = id ?? const Uuid().v4();
  // copyWith method
  User copyWith({
    String? id,
    String? name,
    String? key,
    String? uuid,
    int? pin,
    bool? editId,
    bool? isExternal,
    String? ownership,
    int? groupId,
    bool? external,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      key: key ?? this.key,
      uuid: uuid ?? this.uuid,
      pin: pin ?? this.pin,
      editId: editId ?? this.editId,
      isExternal: isExternal ?? this.isExternal,
      ownership: ownership ?? this.ownership,
      groupId: groupId ?? this.groupId,
      external: external ?? this.external,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
