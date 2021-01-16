// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

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
      'table',
      serializers.serialize(object.table,
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
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.touched != null) {
      result
        ..add('touched')
        ..add(serializers.serialize(object.touched,
            specifiedType: const FullType(bool)));
    }
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
        case 'table':
          result.table = serializers.deserialize(value,
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
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
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
  final String table;
  @override
  final bool isDefault;
  @override
  final double percentage;
  @override
  final String businessId;
  @override
  final BuiltList<String> channels;

  factory _$Tax([void Function(TaxBuilder) updates]) =>
      (new TaxBuilder()..update(updates)).build();

  _$Tax._(
      {this.name,
      this.id,
      this.touched,
      this.table,
      this.isDefault,
      this.percentage,
      this.businessId,
      this.channels})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Tax', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Tax', 'id');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Tax', 'table');
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
    if (channels == null) {
      throw new BuiltValueNullFieldError('Tax', 'channels');
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
        table == other.table &&
        isDefault == other.isDefault &&
        percentage == other.percentage &&
        businessId == other.businessId &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, name.hashCode), id.hashCode),
                            touched.hashCode),
                        table.hashCode),
                    isDefault.hashCode),
                percentage.hashCode),
            businessId.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Tax')
          ..add('name', name)
          ..add('id', id)
          ..add('touched', touched)
          ..add('table', table)
          ..add('isDefault', isDefault)
          ..add('percentage', percentage)
          ..add('businessId', businessId)
          ..add('channels', channels))
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

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  bool _isDefault;
  bool get isDefault => _$this._isDefault;
  set isDefault(bool isDefault) => _$this._isDefault = isDefault;

  double _percentage;
  double get percentage => _$this._percentage;
  set percentage(double percentage) => _$this._percentage = percentage;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  TaxBuilder();

  TaxBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _touched = _$v.touched;
      _table = _$v.table;
      _isDefault = _$v.isDefault;
      _percentage = _$v.percentage;
      _businessId = _$v.businessId;
      _channels = _$v.channels?.toBuilder();
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
    _$Tax _$result;
    try {
      _$result = _$v ??
          new _$Tax._(
              name: name,
              id: id,
              touched: touched,
              table: table,
              isDefault: isDefault,
              percentage: percentage,
              businessId: businessId,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Tax', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
