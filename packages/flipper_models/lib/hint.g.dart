// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Hint extends Hint {
  @override
  final String name;
  @override
  final HintType type;

  factory _$Hint([void Function(HintBuilder) updates]) =>
      (new HintBuilder()..update(updates)).build();

  _$Hint._({this.name, this.type}) : super._();

  @override
  Hint rebuild(void Function(HintBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HintBuilder toBuilder() => new HintBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hint && name == other.name && type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Hint')
          ..add('name', name)
          ..add('type', type))
        .toString();
  }
}

class HintBuilder implements Builder<Hint, HintBuilder> {
  _$Hint _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  HintType _type;
  HintType get type => _$this._type;
  set type(HintType type) => _$this._type = type;

  HintBuilder();

  HintBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Hint other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Hint;
  }

  @override
  void update(void Function(HintBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Hint build() {
    final _$result = _$v ?? new _$Hint._(name: name, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
