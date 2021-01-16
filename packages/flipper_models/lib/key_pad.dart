library flipper_models;

import 'package:built_value/built_value.dart';

part 'key_pad.g.dart';

abstract class KeyPad implements Built<KeyPad, KeyPadBuilder> {
  String get note;
  int get amount;

  KeyPad._();

  factory KeyPad([void Function(KeyPadBuilder) updates]) = _$KeyPad;
}
