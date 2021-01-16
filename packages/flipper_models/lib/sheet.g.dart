// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Sheets extends Sheets {
  @override
  final String name;
  @override
  final Type type;

  factory _$Sheets([void Function(SheetsBuilder) updates]) =>
      (new SheetsBuilder()..update(updates)).build();

  _$Sheets._({this.name, this.type}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Sheets', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('Sheets', 'type');
    }
  }

  @override
  Sheets rebuild(void Function(SheetsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SheetsBuilder toBuilder() => new SheetsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sheets && name == other.name && type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Sheets')
          ..add('name', name)
          ..add('type', type))
        .toString();
  }
}

class SheetsBuilder implements Builder<Sheets, SheetsBuilder> {
  _$Sheets _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  Type _type;
  Type get type => _$this._type;
  set type(Type type) => _$this._type = type;

  SheetsBuilder();

  SheetsBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Sheets other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Sheets;
  }

  @override
  void update(void Function(SheetsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Sheets build() {
    final _$result = _$v ?? new _$Sheets._(name: name, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
