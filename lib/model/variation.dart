import 'package:built_value/built_value.dart';

part 'variation.g.dart';

abstract class Variation implements Built<Variation, VariationBuilder> {
  String get id;
  String get sku;
  String get productId;
  String get name;
  @nullable
  String get unit;
  Variation._();

  factory Variation([void Function(VariationBuilder) updates]) = _$Variation;
}
