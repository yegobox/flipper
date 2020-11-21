import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {


  Category._();

  // ignore: sort_constructors_first
  factory Category([updates(CategoryBuilder b)]) = _$Category;
  

  @BuiltValueField(wireName: 'name')
  String get name;

  @BuiltValueField(wireName: 'id')
  String get id;

  @BuiltValueField(wireName: 'focused')
  @nullable

  bool get focused;
  @BuiltValueField(wireName: 'table')

  String get table;
  @BuiltValueField(wireName: 'touched')

  @nullable
  bool get touched;
  
  
  @BuiltValueField(wireName: 'branchId')
  
  String get branchId;
  // ignore: sort_constructors_first

  
  BuiltList<String> get channels;
  
  String toJson() {
    return json.encode(toMap());
  }
  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Category.serializer, this);
  }

  Category fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static Category fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Category.serializer, jsonMap);
  }

  static Serializer<Category> get serializer => _$categorySerializer;
}
