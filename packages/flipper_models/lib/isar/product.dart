library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'DateTimeConverter.dart';
part 'product.g.dart';

@JsonSerializable()
@Collection()
class Product extends IJsonSerializable {
  late String id;
  @Index()
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

  @JsonKey(
      includeIfNull: true, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? lastTouched;

  String action;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? deletedAt;

  /// this is helper to highlight a product when is found in search
  @Ignore()
  bool searchMatch;

  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  Product({
    required this.name,
    required this.color,
    required this.businessId,
    required this.branchId,
    required this.action,
    required this.id,
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
    required this.lastTouched,
    this.deletedAt,
    this.searchMatch = false,
  });

  factory Product.fromRecord(RecordModel record) =>
      Product.fromJson(record.toJson());
  factory Product.fromJson(Map<String, dynamic> json) {
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$ProductFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
