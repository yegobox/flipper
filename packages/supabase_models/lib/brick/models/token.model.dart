import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'tokens'),
)
class Token extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String? name;
  String? type;
  String? token;
  DateTime? validFrom;
  DateTime? validUntil;
  int? businessId;
  DateTime? lastTouched;

  Token({
    String? id,
    this.name,
    this.type,
    this.token,
    this.validFrom,
    this.validUntil,
    this.businessId,
    this.lastTouched,
  }) : id = id ?? const Uuid().v4();
}
