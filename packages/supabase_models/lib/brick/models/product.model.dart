import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/composite.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'products'),
  sqliteConfig: SqliteSerializable(),
)
class Product extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String name;
  String? description;
  String? taxId;
  String color;
  final String businessId;

  final String branchId;
  String? supplierId;
  String? categoryId;
  DateTime? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;

  String? barCode;
  @Supabase(defaultValue: "false")
  bool? nfcEnabled;

  String? bindedToTenantId;
  @Supabase(defaultValue: "false")
  bool? isFavorite;

  DateTime? lastTouched;

  String? spplrNm;
  @Supabase(defaultValue: "false")
  bool? isComposite;

  @Supabase(name: "composites")
  final List<Composite>? composites;

  @Supabase(ignore: true)
  bool? searchMatch;

  Product({
    String? id,
    required this.name,
    this.searchMatch,
    this.description,
    this.taxId,
    required this.color,
    required this.businessId,
    required this.branchId,
    this.supplierId,
    this.categoryId,
    this.createdAt,
    this.unit,
    this.imageUrl,
    this.expiryDate,
    this.barCode,
    this.nfcEnabled,
    this.bindedToTenantId,
    this.isFavorite,
    this.lastTouched,
    this.spplrNm,
    this.isComposite,
    this.composites = const [], // Initialize as an empty list
  }) : id = id ?? const Uuid().v4();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      taxId: json['taxId'] as String?,
      color: (json['color'] ?? '') as String,
      businessId: (json['businessId'] ?? '') as String,
      branchId: (json['branchId'] ?? '') as String,
      supplierId: json['supplierId'] as String?,
      categoryId: json['categoryId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
      expiryDate: json['expiryDate'] as String?,
      barCode: json['barCode'] as String?,
      nfcEnabled: json['nfcEnabled'] as bool?,
      bindedToTenantId: json['bindedToTenantId'] as String?,
      isFavorite: json['isFavorite'] as bool?,
      lastTouched: json['lastTouched'] != null
          ? DateTime.tryParse(json['lastTouched'] as String)
          : null,
      spplrNm: json['spplrNm'] as String?,
      isComposite: json['isComposite'] as bool?,
    );
  }
}
