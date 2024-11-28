import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'composites'),
  sqliteConfig: SqliteSerializable(),
)
class Composite extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final int id;

  int? productId;
  int? variantId;
  double? qty = 1.0;
  int? branchId;
  int? businessId;

  /// this hold the actual price of the sum of item on composite
  /// sound like if we have 4 item on a composite, they will all have this column to represent the price
  /// of the whole composite.
  double? actualPrice = 0;

  Composite({
    required this.id,
    this.productId,
    this.variantId,
    this.qty,
    this.branchId,
    this.businessId,
    this.actualPrice,
  });
}
