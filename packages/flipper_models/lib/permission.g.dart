// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Permission extends Permission {
  @override
  final bool checked;
  @override
  final String type;

  factory _$Permission([void Function(PermissionBuilder) updates]) =>
      (new PermissionBuilder()..update(updates)).build();

  _$Permission._({this.checked, this.type}) : super._() {
    if (checked == null) {
      throw new BuiltValueNullFieldError('Permission', 'checked');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('Permission', 'type');
    }
  }

  @override
  Permission rebuild(void Function(PermissionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionBuilder toBuilder() => new PermissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Permission &&
        checked == other.checked &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, checked.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Permission')
          ..add('checked', checked)
          ..add('type', type))
        .toString();
  }
}

class PermissionBuilder implements Builder<Permission, PermissionBuilder> {
  _$Permission _$v;

  bool _checked;
  bool get checked => _$this._checked;
  set checked(bool checked) => _$this._checked = checked;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  PermissionBuilder();

  PermissionBuilder get _$this {
    if (_$v != null) {
      _checked = _$v.checked;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Permission other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Permission;
  }

  @override
  void update(void Function(PermissionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Permission build() {
    final _$result = _$v ?? new _$Permission._(checked: checked, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
