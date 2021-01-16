library flipper_models;

import 'package:built_value/built_value.dart';

part 'sheet.g.dart';

abstract class Sheets implements Built<Sheets, SheetsBuilder> {
  String get name;
  Type get type;

  Sheets._();

  factory Sheets([void Function(SheetsBuilder) updates]) = _$Sheets;
}

enum Type { ADDNOTE, SPLITBILL }
