library flipper_models;

import 'package:built_value/built_value.dart';

part 'price.g.dart';

abstract class Price implements Built<Price, PriceBuilder> {
  String get value;

  Price._();

  factory Price([void Function(PriceBuilder) updates]) = _$Price;
}
