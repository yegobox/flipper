import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'unit.g.dart';

abstract class Unit implements Built<Unit, UnitBuilder> {
  String get name;

  String get table;

  String get branchId;

  bool get focused;

  BuiltList<String> get channels;

  @nullable //for some reason the query does not return the id of the document
  String get id;
  // ignore: sort_constructors_first
  Unit._();

  factory Unit([void Function(UnitBuilder) updates]) = _$Unit;

  String toJson() {
    return json.encode(toMap());
  }
//   {
//         "id": "2f72b460-4b52-11eb-a1e3-93571367a26b",
//         "branchId": "2f6e95b0-4b52-11eb-a113-97b712c57a92",
//         "name": "Per Item",
//         "table": "units",
//         "focused": false,
//         "channels": [
//             "51"
//         ]
// }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Unit.serializer, this);
  }

  Unit fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static Unit fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Unit.serializer, jsonMap);
  }

  static Serializer<Unit> get serializer => _$unitSerializer;
}
