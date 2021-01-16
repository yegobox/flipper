library flipper_models;

import 'package:built_value/built_value.dart';

part 'total.g.dart';

abstract class Total implements Built<Total, TotalBuilder> {
  int get value;

  Total._();

  factory Total([void Function(TotalBuilder) updates]) = _$Total;
}
