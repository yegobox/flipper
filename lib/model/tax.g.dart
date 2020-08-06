// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Tax extends Tax {
  @override
  final String name;
  @override
  final String id;
  @override
  final bool isDefault;
  @override
  final double percentage;
  @override
  final String businessId;

  factory _$Tax([void Function(TaxBuilder) updates]) =>
      (new TaxBuilder()..update(updates)).build();

  _$Tax._(
      {this.name, this.id, this.isDefault, this.percentage, this.businessId})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Tax', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Tax', 'id');
    }
    if (isDefault == null) {
      throw new BuiltValueNullFieldError('Tax', 'isDefault');
    }
    if (percentage == null) {
      throw new BuiltValueNullFieldError('Tax', 'percentage');
    }
    if (businessId == null) {
      throw new BuiltValueNullFieldError('Tax', 'businessId');
    }
  }

  @override
  Tax rebuild(void Function(TaxBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxBuilder toBuilder() => new TaxBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tax &&
        name == other.name &&
        id == other.id &&
        isDefault == other.isDefault &&
        percentage == other.percentage &&
        businessId == other.businessId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, name.hashCode), id.hashCode), isDefault.hashCode),
            percentage.hashCode),
        businessId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Tax')
          ..add('name', name)
          ..add('id', id)
          ..add('isDefault', isDefault)
          ..add('percentage', percentage)
          ..add('businessId', businessId))
        .toString();
  }
}

class TaxBuilder implements Builder<Tax, TaxBuilder> {
  _$Tax _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _isDefault;
  bool get isDefault => _$this._isDefault;
  set isDefault(bool isDefault) => _$this._isDefault = isDefault;

  double _percentage;
  double get percentage => _$this._percentage;
  set percentage(double percentage) => _$this._percentage = percentage;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  TaxBuilder();

  TaxBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _isDefault = _$v.isDefault;
      _percentage = _$v.percentage;
      _businessId = _$v.businessId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Tax other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Tax;
  }

  @override
  void update(void Function(TaxBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Tax build() {
    final _$result = _$v ??
        new _$Tax._(
            name: name,
            id: id,
            isDefault: isDefault,
            percentage: percentage,
            businessId: businessId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
