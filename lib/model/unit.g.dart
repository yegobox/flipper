// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Unit extends Unit {
  @override
  final String name;
  @override
  final bool focused;
  @override
  final int businessId;
  @override
  final int branchId;
  @override
  final int id;

  factory _$Unit([void Function(UnitBuilder) updates]) =>
      (new UnitBuilder()..update(updates)).build();

  _$Unit._({this.name, this.focused, this.businessId, this.branchId, this.id})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Unit', 'name');
    }
    if (focused == null) {
      throw new BuiltValueNullFieldError('Unit', 'focused');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Unit', 'branchId');
    }
  }

  @override
  Unit rebuild(void Function(UnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnitBuilder toBuilder() => new UnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Unit &&
        name == other.name &&
        focused == other.focused &&
        businessId == other.businessId &&
        branchId == other.branchId &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, name.hashCode), focused.hashCode),
                businessId.hashCode),
            branchId.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Unit')
          ..add('name', name)
          ..add('focused', focused)
          ..add('businessId', businessId)
          ..add('branchId', branchId)
          ..add('id', id))
        .toString();
  }
}

class UnitBuilder implements Builder<Unit, UnitBuilder> {
  _$Unit _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  bool _focused;
  bool get focused => _$this._focused;
  set focused(bool focused) => _$this._focused = focused;

  int _businessId;
  int get businessId => _$this._businessId;
  set businessId(int businessId) => _$this._businessId = businessId;

  int _branchId;
  int get branchId => _$this._branchId;
  set branchId(int branchId) => _$this._branchId = branchId;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  UnitBuilder();

  UnitBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _focused = _$v.focused;
      _businessId = _$v.businessId;
      _branchId = _$v.branchId;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Unit other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Unit;
  }

  @override
  void update(void Function(UnitBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Unit build() {
    final _$result = _$v ??
        new _$Unit._(
            name: name,
            focused: focused,
            businessId: businessId,
            branchId: branchId,
            id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
