library flipper_models;

import 'package:built_value/built_value.dart';

part 'flipper_color.g.dart';

@deprecated
abstract class FlipperColor
    implements Built<FlipperColor, FlipperColorBuilder> {
  String get hexCode;
  FlipperColor._();

  factory FlipperColor([void Function(FlipperColorBuilder) updates]) =
      _$FlipperColor;
}
