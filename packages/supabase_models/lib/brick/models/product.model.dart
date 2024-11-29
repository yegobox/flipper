import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'composite.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'products'),
  sqliteConfig: SqliteSerializable(),
)
class Product extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? name;
  String? description;
  String? taxId;
  String color = "#e74c3c";
  int? businessId;

  int? branchId;
  String? supplierId;
  int? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;

  String? barCode;
  bool nfcEnabled = false;

  int? bindedToTenantId;
  bool isFavorite = false;

  DateTime? lastTouched;

  DateTime? deletedAt;

  bool searchMatch = false;
  String? spplrNm;
  bool? isComposite = false;

  List<Composite> composites = [];

  Product({
    required this.id,
    this.name,
    this.description,
    this.taxId,
    this.color = "#e74c3c",
    this.businessId,
    this.branchId,
    this.supplierId,
    this.categoryId,
    this.createdAt,
    this.unit,
    this.imageUrl,
    this.expiryDate,
    this.barCode,
    this.nfcEnabled = false,
    this.bindedToTenantId,
    this.isFavorite = false,
    this.lastTouched,
    this.deletedAt,
    this.searchMatch = false,
    this.spplrNm,
    this.isComposite = false,
    this.composites = const [], // Initialize as an empty list
  });
}
