import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class FlipperSaleCompaign extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? compaignId;
  int? discountRate;
  DateTime? createdAt;
  String? couponCode;
  FlipperSaleCompaign({
    required this.id,
    this.compaignId,
    this.discountRate,
    this.createdAt,
    this.couponCode,
  });
}
