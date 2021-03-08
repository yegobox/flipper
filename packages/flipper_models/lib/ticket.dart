library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'ticket.g.dart';

abstract class Ticket implements Built<Ticket, TicketBuilder> {
  String get id;
  String get ticketName;
  @nullable
  String get note;
  String get createdAt;

  BuiltList<String> get channels;

  BuiltList<String> get orders;

  Ticket._();

  // ignore: sort_unnamed_constructors_first
  factory Ticket([void Function(TicketBuilder) updates]) = _$Ticket;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Ticket.serializer, this);
  }

  Ticket fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Ticket fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Ticket.serializer, jsonMap);
  }

  static Serializer<Ticket> get serializer => _$ticketSerializer;
}
