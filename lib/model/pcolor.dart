import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'pcolor.g.dart';

//Note: it is highligy recommended to know that even if we mark the field as nullable
//they are required when mass assigning, it is only marked as required
//because the use of this model with other model that does not have or do not have to
//comply with this model. a concrete reference of this model and other model can be found
//in technical document of database design.
abstract class PColor implements Built<PColor, PColorBuilder> {
  String get id;
  String get name;
  String get table;
  bool get isActive;
  BuiltList<String> get channels;
  
  // ignore: sort_constructors_first
  PColor._();
  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory PColor([updates(PColorBuilder b)]) = _$PColor;


  
  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(PColor.serializer, this);
  }

  PColor fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static PColor fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(PColor.serializer, jsonMap);
  }

 static Serializer<PColor> get serializer => _$pColorSerializer;
}
