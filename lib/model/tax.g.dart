// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Tax> _$taxSerializer = new _$TaxSerializer();

class _$TaxSerializer implements StructuredSerializer<Tax> {
  @override
  final Iterable<Type> types = const [Tax, _$Tax];
  @override
  final String wireName = 'Tax';

  @override
  Iterable<Object> serialize(Serializers serializers, Tax object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'touched',
      serializers.serialize(object.touched,
          specifiedType: const FullType(bool)),
      'tableName',
      serializers.serialize(object.tableName,
          specifiedType: const FullType(String)),
      'isDefault',
      serializers.serialize(object.isDefault,
          specifiedType: const FullType(bool)),
      'percentage',
      serializers.serialize(object.percentage,
          specifiedType: const FullType(double)),
      'businessId',
      serializers.serialize(object.businessId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Tax deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TaxBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'touched':
          result.touched = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'tableName':
          result.tableName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isDefault':
          result.isDefault = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'percentage':
          result.percentage = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'businessId':
          result.businessId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Tax extends Tax {
  @override
  final String name;
  @override
  final String id;
  @override
  final bool touched;
  @override
  final String tableName;
  @override
  final bool isDefault;
  @override
  final double percentage;
  @override
  final String businessId;

  factory _$Tax([void Function(TaxBuilder) updates]) =>
      (new TaxBuilder()..update(updates)).build();

  _$Tax._(
      {this.name,
      this.id,
      this.touched,
      this.tableName,
      this.isDefault,
      this.percentage,
      this.businessId})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Tax', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Tax', 'id');
    }
    if (touched == null) {
      throw new BuiltValueNullFieldError('Tax', 'touched');
    }
    if (tableName == null) {
      throw new BuiltValueNullFieldError('Tax', 'tableName');
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
        touched == other.touched &&
        tableName == other.tableName &&
        isDefault == other.isDefault &&
        percentage == other.percentage &&
        businessId == other.businessId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, name.hashCode), id.hashCode),
                        touched.hashCode),
                    tableName.hashCode),
                isDefault.hashCode),
            percentage.hashCode),
        businessId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Tax')
          ..add('name', name)
          ..add('id', id)
          ..add('touched', touched)
          ..add('tableName', tableName)
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

  bool _touched;
  bool get touched => _$this._touched;
  set touched(bool touched) => _$this._touched = touched;

  String _tableName;
  String get tableName => _$this._tableName;
  set tableName(String tableName) => _$this._tableName = tableName;

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
      _touched = _$v.touched;
      _tableName = _$v.tableName;
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
            touched: touched,
            tableName: tableName,
            isDefault: isDefault,
            percentage: percentage,
            businessId: businessId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
