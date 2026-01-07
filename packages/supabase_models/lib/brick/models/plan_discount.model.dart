import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'plan_discounts'),
  sqliteConfig: SqliteSerializable(),
)
class PlanDiscount extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  @Supabase(name: 'plan_id')
  @Sqlite(index: true)
  final String planId;

  @Supabase(name: 'discount_code_id')
  final String discountCodeId;

  @Supabase(name: 'original_price')
  final double originalPrice;

  @Supabase(name: 'discount_amount')
  final double discountAmount;

  @Supabase(name: 'final_price')
  final double finalPrice;

  @Supabase(name: 'applied_at')
  final DateTime appliedAt;

  @Supabase(name: 'business_id')
  final String businessId;

  PlanDiscount({
    String? id,
    required this.planId,
    required this.discountCodeId,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    DateTime? appliedAt,
    required this.businessId,
  })  : id = id ?? const Uuid().v4(),
        appliedAt = appliedAt ?? DateTime.now().toUtc();
}
