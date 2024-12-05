import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'composite.g.dart';

@JsonSerializable()
@Collection<Composite>('composites')
class Composite {
  final int? id;
  final int? productId;
  final int? variantId;
  final double? qty;
  final int? branchId;
  final int? businessId;
  final double? actualPrice;

  const Composite({
    this.id,
    this.productId,
    this.variantId,
    this.qty,
    this.branchId,
    this.businessId,
    this.actualPrice,
  });

  // Factory constructor to create a Composite from JSON
  factory Composite.fromJson(Map<String, dynamic> json) =>
      _$CompositeFromJson(json);

  // Method to convert Composite to JSON
  Map<String, dynamic> toJson() => _$CompositeToJson(this);

  // Implement copyWith method for immutability
  Composite copyWith({
    int? id,
    int? productId,
    int? variantId,
    double? qty,
    int? branchId,
    int? businessId,
    double? actualPrice,
  }) {
    return Composite(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      qty: qty ?? this.qty,
      branchId: branchId ?? this.branchId,
      businessId: businessId ?? this.businessId,
      actualPrice: actualPrice ?? this.actualPrice,
    );
  }
}

final compositesRef = CompositeCollectionReference();
