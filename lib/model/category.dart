import 'package:built_value/built_value.dart';

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {
  String get name;
  String get id;
  bool get focused;
  String get branchId;
  Category._();

  factory Category([void Function(CategoryBuilder) updates]) = _$Category;
}
