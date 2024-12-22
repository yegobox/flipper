import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Token extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  final String? name;
  String? type;
  String? token;
  DateTime? validFrom;
  DateTime? validUntil;
  int? businessId;
  DateTime? lastTouched;

  Token({
    required this.id,
    this.name,
    this.type,
    this.token,
    this.validFrom,
    this.validUntil,
    this.businessId,
    this.lastTouched,
  });
}
