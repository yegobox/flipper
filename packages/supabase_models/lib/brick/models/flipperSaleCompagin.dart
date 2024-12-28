import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class FlipperSaleCompaign extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  int? compaignId;
  int? discountRate;
  DateTime? createdAt;
  String? couponCode;
  FlipperSaleCompaign({
    String? id,
    this.compaignId,
    this.discountRate,
    this.createdAt,
    this.couponCode,
  }) : id = id ?? const Uuid().v4();
}
