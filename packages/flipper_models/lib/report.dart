library flipper_models;

import 'package:built_value/built_value.dart';

part 'report.g.dart';

abstract class Report implements Built<Report, ReportBuilder> {
  double get netProfit;
  double get grossProfit;
  Report._();
  factory Report([void Function(ReportBuilder) updates]) = _$Report;
}
