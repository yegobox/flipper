// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Price extends Price {
  @override
  final String value;

  factory _$Price([void Function(PriceBuilder) updates]) =>
      (new PriceBuilder()..update(updates)).build();

  _$Price._({this.value}) : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('Price', 'value');
    }
  }

  @override
  Price rebuild(void Function(PriceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PriceBuilder toBuilder() => new PriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Price && value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc(0, value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Price')..add('value', value))
        .toString();
  }
}

class PriceBuilder implements Builder<Price, PriceBuilder> {
  _$Price _$v;

  String _value;
  String get value => _$this._value;
  set value(String value) => _$this._value = value;

  PriceBuilder();

  PriceBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Price other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Price;
  }

  @override
  void update(void Function(PriceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Price build() {
    final _$result = _$v ?? new _$Price._(value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
