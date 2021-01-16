library flipper_models;

import 'package:built_value/built_value.dart';

part 'hint.g.dart';

abstract class Hint implements Built<Hint, HintBuilder> {
  @nullable
  String get name;
  @nullable
  HintType get type;
  Hint._();
  factory Hint([void Function(HintBuilder) updates]) = _$Hint;
}

enum HintType { Branch, Business }
