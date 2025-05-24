import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'credits'),
)
class Credit extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  String? branchId;
  String? businessId;
  double credits;
  DateTime createdAt;
  DateTime updatedAt;
  int branchServerId;

  Credit(
      {String? id,
      this.branchId,
      this.businessId,
      required this.credits,
      required this.createdAt,
      required this.branchServerId,
      required this.updatedAt})
      : id = id ?? const Uuid().v4();
}
