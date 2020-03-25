import 'package:built_value/built_value.dart';

part 'tax.g.dart';

//Note: it is highligy recommended to know that even if we mark the field as nullable
//they are required when mass assigning, it is only marked as required
//because the use of this model with other model that does not have or do not have to
//comply with this model. a concrete reference of this model and other model can be found
//in technical document of database design.
abstract class Tax implements Built<Tax, TaxBuilder> {
  String get name;
  String get id;

  bool get isDefault;

  double get percentage;
  String get businessId;

  Tax._();
  factory Tax([void Function(TaxBuilder) updates]) = _$Tax;
}
