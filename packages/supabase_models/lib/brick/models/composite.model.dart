import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'composites'),
  sqliteConfig: SqliteSerializable(),
)
class Composite extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final String id;

  String? productId;
  String? variantId;
  double? qty;
  int? branchId;
  int? businessId;

  /// this hold the actual price of the sum of item on composite
  /// sound like if we have 4 item on a composite, they will all have this column to represent the price
  /// of the whole composite.
  double? actualPrice;

  Composite({
    String? id,
    this.productId,
    this.variantId,
    this.qty,
    this.branchId,
    this.businessId,
    this.actualPrice,
  }) : id = id ?? const Uuid().v4();
}
