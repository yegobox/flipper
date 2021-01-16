// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Disable extends Disable {
  @override
  final String disable;

  factory _$Disable([void Function(DisableBuilder) updates]) =>
      (new DisableBuilder()..update(updates)).build();

  _$Disable._({this.disable}) : super._() {
    if (disable == null) {
      throw new BuiltValueNullFieldError('Disable', 'disable');
    }
  }

  @override
  Disable rebuild(void Function(DisableBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisableBuilder toBuilder() => new DisableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Disable && disable == other.disable;
  }

  @override
  int get hashCode {
    return $jf($jc(0, disable.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Disable')..add('disable', disable))
        .toString();
  }
}

class DisableBuilder implements Builder<Disable, DisableBuilder> {
  _$Disable _$v;

  String _disable;
  String get disable => _$this._disable;
  set disable(String disable) => _$this._disable = disable;

  DisableBuilder();

  DisableBuilder get _$this {
    if (_$v != null) {
      _disable = _$v.disable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Disable other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Disable;
  }

  @override
  void update(void Function(DisableBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Disable build() {
    final _$result = _$v ?? new _$Disable._(disable: disable);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
