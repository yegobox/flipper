library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'product.g.dart';

@JsonSerializable()
@Collection()
class Product extends IJsonSerializable {
  Id? id;
  @Index(caseSensitive: true)
  late String name;
  String? description;
  String? taxId;
  late String color;
  late int businessId;
  @Index()
  late int branchId;
  String? supplierId;
  String? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;
  @Index()
  String? barCode;
  bool? nfcEnabled;
  // This is a localID not necessary coming from remote
  @Index()
  int? bindedToTenantId;
  bool? isFavorite;

  /// as multiple devices can touch the same product, we need to track the device
  /// the onlne generated ID will be the ID other device need to use in updating so
  /// the ID of the product in all devices should be similar and other IDs.
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String? action;
  int? localId;
  @Index()
  DateTime? deletedAt;
  final variants = IsarLinks<Variant>();

  Product({
    required this.name,
    required this.color,
    required this.businessId,
    required this.branchId,
    required this.action,
    this.id,
    this.description,
    this.taxId,
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
    this.remoteID,
    this.deletedAt,
  });

  factory Product.fromRecord(RecordModel record) =>
      Product.fromJson(record.toJson());
  factory Product.fromJson(Map<String, dynamic> json) {
    json['remoteID'] = json['id'];
    json.remove('id');
    return _$ProductFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$ProductToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
