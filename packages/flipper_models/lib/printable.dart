library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'printable.g.dart';

abstract class Printable implements Built<Printable, PrintableBuilder> {
  double get amount;
  String get unit;
  String get name;
  double get quantity;
  double get price;

  Printable._();

  factory Printable([void Function(PrintableBuilder) updates]) = _$Printable;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Printable.serializer, this);
  }

  Printable fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Printable fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Printable.serializer, jsonMap);
  }

  static Serializer<Printable> get serializer => _$printableSerializer;
}
