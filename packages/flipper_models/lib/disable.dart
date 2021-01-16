library flipper_models;

import 'package:built_value/built_value.dart';

part 'disable.g.dart';

abstract class Disable implements Built<Disable, DisableBuilder> {
  String get disable;
  Disable._();

  factory Disable([void Function(DisableBuilder) updates]) = _$Disable;
}
