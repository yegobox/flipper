library flipper_models;

import 'package:built_value/built_value.dart';

part 'date_filter.g.dart';

abstract class DateFilter implements Built<DateFilter, DateFilterBuilder> {
  String get startDate;
  String get endDate;
  DateFilter._();
  factory DateFilter([void Function(DateFilterBuilder) updates]) = _$DateFilter;
}
