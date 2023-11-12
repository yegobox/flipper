library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product.freezed.dart';
part 'product.g.dart';

@freezed
@JsonSerializable()
@Collection()
class Product extends IJsonSerializable with _$Product {
  const factory Product({
    required String id,
    required String name,
    String? description,
    String? taxId,
    required String color,
    required int businessId,
    required int branchId,
    String? supplierId,
    String? categoryId,
    String? createdAt,
    String? unit,
    String? imageUrl,
    String? expiryDate,
    String? barCode,
    bool? nfcEnabled,
    int? bindedToTenantId,
    bool? isFavorite,
    DateTime? lastTouched,
    required String action,
    DateTime? deletedAt,
    bool? searchMatch,
  }) = _Product;

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

  // Add the missing setters for the other fields
  @override
  set action(String value) => this.copyWith(action: value);

  @override
  set deletedAt(DateTime? value) => this.copyWith(deletedAt: value);

  @override
  set lastTouched(DateTime? value) => this.copyWith(lastTouched: value);
}
