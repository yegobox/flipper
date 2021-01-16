library flipper_models;

import 'package:built_value/built_value.dart';

part 'sku.g.dart';

abstract class Sku implements Built<Sku, SkuBuilder> {
  String get value;

  Sku._();

  factory Sku([void Function(SkuBuilder) updates]) = _$Sku;
}
