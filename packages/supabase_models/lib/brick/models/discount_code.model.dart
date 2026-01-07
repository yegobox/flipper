import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'discount_codes'),
  sqliteConfig: SqliteSerializable(),
)
class DiscountCode extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String code;

  @Supabase(name: 'discount_type')
  final String discountType; // 'percentage' or 'fixed'

  @Supabase(name: 'discount_value')
  final double discountValue;

  @Supabase(name: 'max_uses')
  final int? maxUses;

  @Supabase(name: 'current_uses')
  final int currentUses;

  @Supabase(name: 'valid_from')
  final DateTime? validFrom;

  @Supabase(name: 'valid_until')
  final DateTime? validUntil;

  @Supabase(name: 'applicable_plans')
  final List<String>? applicablePlans;

  @Supabase(name: 'minimum_amount')
  final double? minimumAmount;

  @Supabase(name: 'is_active')
  final bool isActive;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  final String? description;

  DiscountCode({
    String? id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.maxUses,
    this.currentUses = 0,
    this.validFrom,
    this.validUntil,
    this.applicablePlans,
    this.minimumAmount,
    this.isActive = true,
    DateTime? createdAt,
    this.description,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc();
}
