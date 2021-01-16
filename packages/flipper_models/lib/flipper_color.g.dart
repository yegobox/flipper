// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FlipperColor extends FlipperColor {
  @override
  final String hexCode;

  factory _$FlipperColor([void Function(FlipperColorBuilder) updates]) =>
      (new FlipperColorBuilder()..update(updates)).build();

  _$FlipperColor._({this.hexCode}) : super._() {
    if (hexCode == null) {
      throw new BuiltValueNullFieldError('FlipperColor', 'hexCode');
    }
  }

  @override
  FlipperColor rebuild(void Function(FlipperColorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FlipperColorBuilder toBuilder() => new FlipperColorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FlipperColor && hexCode == other.hexCode;
  }

  @override
  int get hashCode {
    return $jf($jc(0, hexCode.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FlipperColor')
          ..add('hexCode', hexCode))
        .toString();
  }
}

class FlipperColorBuilder
    implements Builder<FlipperColor, FlipperColorBuilder> {
  _$FlipperColor _$v;

  String _hexCode;
  String get hexCode => _$this._hexCode;
  set hexCode(String hexCode) => _$this._hexCode = hexCode;

  FlipperColorBuilder();

  FlipperColorBuilder get _$this {
    if (_$v != null) {
      _hexCode = _$v.hexCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlipperColor other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FlipperColor;
  }

  @override
  void update(void Function(FlipperColorBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FlipperColor build() {
    final _$result = _$v ?? new _$FlipperColor._(hexCode: hexCode);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
