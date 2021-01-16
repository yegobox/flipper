// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DateFilter extends DateFilter {
  @override
  final String startDate;
  @override
  final String endDate;

  factory _$DateFilter([void Function(DateFilterBuilder) updates]) =>
      (new DateFilterBuilder()..update(updates)).build();

  _$DateFilter._({this.startDate, this.endDate}) : super._() {
    if (startDate == null) {
      throw new BuiltValueNullFieldError('DateFilter', 'startDate');
    }
    if (endDate == null) {
      throw new BuiltValueNullFieldError('DateFilter', 'endDate');
    }
  }

  @override
  DateFilter rebuild(void Function(DateFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateFilterBuilder toBuilder() => new DateFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateFilter &&
        startDate == other.startDate &&
        endDate == other.endDate;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, startDate.hashCode), endDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DateFilter')
          ..add('startDate', startDate)
          ..add('endDate', endDate))
        .toString();
  }
}

class DateFilterBuilder implements Builder<DateFilter, DateFilterBuilder> {
  _$DateFilter _$v;

  String _startDate;
  String get startDate => _$this._startDate;
  set startDate(String startDate) => _$this._startDate = startDate;

  String _endDate;
  String get endDate => _$this._endDate;
  set endDate(String endDate) => _$this._endDate = endDate;

  DateFilterBuilder();

  DateFilterBuilder get _$this {
    if (_$v != null) {
      _startDate = _$v.startDate;
      _endDate = _$v.endDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateFilter other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DateFilter;
  }

  @override
  void update(void Function(DateFilterBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DateFilter build() {
    final _$result =
        _$v ?? new _$DateFilter._(startDate: startDate, endDate: endDate);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
