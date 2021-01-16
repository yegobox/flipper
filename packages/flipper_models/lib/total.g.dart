// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Total extends Total {
  @override
  final int value;

  factory _$Total([void Function(TotalBuilder) updates]) =>
      (new TotalBuilder()..update(updates)).build();

  _$Total._({this.value}) : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('Total', 'value');
    }
  }

  @override
  Total rebuild(void Function(TotalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TotalBuilder toBuilder() => new TotalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Total && value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc(0, value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Total')..add('value', value))
        .toString();
  }
}

class TotalBuilder implements Builder<Total, TotalBuilder> {
  _$Total _$v;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  TotalBuilder();

  TotalBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Total other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Total;
  }

  @override
  void update(void Function(TotalBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Total build() {
    final _$result = _$v ?? new _$Total._(value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
