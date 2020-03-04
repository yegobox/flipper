import 'package:built_value/built_value.dart';

part 'item.g.dart';

abstract class Item implements Built<Item, ItemBuilder> {
  @nullable
  String get parentName;
  @nullable
  String get name;
  @nullable
  String get color;
  int get id;
  @nullable
  double get retailPrice;
  @nullable
  double get costPrice;
  @nullable
  int get variantId;
  @nullable
  int get price;

  @nullable
  bool get isActive;

  @nullable
  int get quantity;

  String get branchId;
  @nullable
  int get categoryId;
  @nullable
  int get unitId;

  @nullable
  String get description;
  @nullable
  int get count;
  Item._();
  factory Item([void Function(ItemBuilder) updates]) = _$Item;
}
