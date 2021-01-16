// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Report extends Report {
  @override
  final double netProfit;
  @override
  final double grossProfit;

  factory _$Report([void Function(ReportBuilder) updates]) =>
      (new ReportBuilder()..update(updates)).build();

  _$Report._({this.netProfit, this.grossProfit}) : super._() {
    if (netProfit == null) {
      throw new BuiltValueNullFieldError('Report', 'netProfit');
    }
    if (grossProfit == null) {
      throw new BuiltValueNullFieldError('Report', 'grossProfit');
    }
  }

  @override
  Report rebuild(void Function(ReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportBuilder toBuilder() => new ReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Report &&
        netProfit == other.netProfit &&
        grossProfit == other.grossProfit;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, netProfit.hashCode), grossProfit.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Report')
          ..add('netProfit', netProfit)
          ..add('grossProfit', grossProfit))
        .toString();
  }
}

class ReportBuilder implements Builder<Report, ReportBuilder> {
  _$Report _$v;

  double _netProfit;
  double get netProfit => _$this._netProfit;
  set netProfit(double netProfit) => _$this._netProfit = netProfit;

  double _grossProfit;
  double get grossProfit => _$this._grossProfit;
  set grossProfit(double grossProfit) => _$this._grossProfit = grossProfit;

  ReportBuilder();

  ReportBuilder get _$this {
    if (_$v != null) {
      _netProfit = _$v.netProfit;
      _grossProfit = _$v.grossProfit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Report other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Report;
  }

  @override
  void update(void Function(ReportBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Report build() {
    final _$result =
        _$v ?? new _$Report._(netProfit: netProfit, grossProfit: grossProfit);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
