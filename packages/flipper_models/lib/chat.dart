library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'chat.g.dart';

abstract class Chat implements Built<Chat, ChatBuilder> {
  String get id;
  String get message;
  String get sendBy; //put a name of the one who sent the message
  String get time;
  BuiltList<String>
      get channels; //if I add the user into channel then I do not have to filter against
  //because otherwise I only get data that I relate to

  // ignore: sort_constructors_first
  Chat._();
  factory Chat([void Function(ChatBuilder) updates]) = _$Chat;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Chat.serializer, this);
  }

  Chat fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Chat fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Chat.serializer, jsonMap);
  }

  static Serializer<Chat> get serializer => _$chatSerializer;
}
