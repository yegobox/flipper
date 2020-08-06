import 'package:built_value/built_value.dart';

part 'unit.g.dart';

abstract class Unit implements Built<Unit, UnitBuilder> {
  String get name;

  bool get focused;
  @nullable
  int get businessId;
  int get branchId;
  @nullable
  int get id;
  Unit._();

  factory Unit([void Function(UnitBuilder) updates]) = _$Unit;
}
