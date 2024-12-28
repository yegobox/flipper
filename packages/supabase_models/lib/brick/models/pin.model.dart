import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'pins'),
)
class Pin extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  int? userId;
  String? phoneNumber;
  int? pin;
  int? branchId;
  int? businessId;
  String? ownerName;
  String? tokenUid;
  String? uid;
  Pin({
    String? id,
    this.userId,
    this.phoneNumber,
    this.pin,
    this.branchId,
    this.businessId,
    this.ownerName,
    this.tokenUid,
    this.uid,
  }) : id = id ?? const Uuid().v4();
}
