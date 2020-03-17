import 'package:built_value/built_value.dart';

part 'cart.g.dart';

abstract class Cart implements Built<Cart, CartBuilder> {
  String get parentName;

  int get id;

  int get count;

  String get variationId;

  @nullable
  DateTime get createdAt;

  @nullable
  DateTime get updatedAt;

  String get branchId;

  String get variationName;

  Cart._();
  factory Cart([void Function(CartBuilder) updates]) = _$Cart;
}
