// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Sku extends Sku {
  @override
  final String value;

  factory _$Sku([void Function(SkuBuilder) updates]) =>
      (new SkuBuilder()..update(updates)).build();

  _$Sku._({this.value}) : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('Sku', 'value');
    }
  }

  @override
  Sku rebuild(void Function(SkuBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SkuBuilder toBuilder() => new SkuBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sku && value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc(0, value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Sku')..add('value', value)).toString();
  }
}

class SkuBuilder implements Builder<Sku, SkuBuilder> {
  _$Sku _$v;

  String _value;
  String get value => _$this._value;
  set value(String value) => _$this._value = value;

  SkuBuilder();

  SkuBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Sku other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Sku;
  }

  @override
  void update(void Function(SkuBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Sku build() {
    final _$result = _$v ?? new _$Sku._(value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
