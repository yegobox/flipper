import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'codes'),
)
class ItemCode extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  @Sqlite(index: true)
  @Supabase(name: 'item_code')
  final String itemCode;
  @Supabase(name: 'created_at')
  final DateTime createdAt;

  ItemCode({
    required this.id,
    required this.itemCode,
    required this.createdAt,
  });

  // Factory constructor to create an instance from a map
  // factory ItemCode.fromMap(Map<String, dynamic> map) {
  //   return ItemCode(
  //     id: map['id'] as int,
  //     itemCode: map['itemCode'] as String,
  //     createdAt: DateTime.parse(map['createdAt'] as String),
  //   );
  // }

  // // Method to convert an instance into a map
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'itemCode': itemCode,
  //     'createdAt': createdAt.toIso8601String(),
  //   };
  // }
}
