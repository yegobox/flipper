// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Unit> _$unitSerializer = new _$UnitSerializer();

class _$UnitSerializer implements StructuredSerializer<Unit> {
  @override
  final Iterable<Type> types = const [Unit, _$Unit];
  @override
  final String wireName = 'Unit';

  @override
  Iterable<Object> serialize(Serializers serializers, Unit object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'tableName',
      serializers.serialize(object.tableName,
          specifiedType: const FullType(String)),
      'productId',
      serializers.serialize(object.productId,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    if (object.focused != null) {
      result
        ..add('focused')
        ..add(serializers.serialize(object.focused,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Unit deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UnitBuilder();

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
        case 'tableName':
          result.tableName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productId':
          result.productId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'focused':
          result.focused = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Unit extends Unit {
  @override
  final String name;
  @override
  final String tableName;
  @override
  final String productId;
  @override
  final bool focused;
  @override
  final BuiltList<String> channels;
  @override
  final String id;

  factory _$Unit([void Function(UnitBuilder) updates]) =>
      (new UnitBuilder()..update(updates)).build();

  _$Unit._(
      {this.name,
      this.tableName,
      this.productId,
      this.focused,
      this.channels,
      this.id})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Unit', 'name');
    }
    if (tableName == null) {
      throw new BuiltValueNullFieldError('Unit', 'tableName');
    }
    if (productId == null) {
      throw new BuiltValueNullFieldError('Unit', 'productId');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Unit', 'channels');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Unit', 'id');
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
        tableName == other.tableName &&
        productId == other.productId &&
        focused == other.focused &&
        channels == other.channels &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, name.hashCode), tableName.hashCode),
                    productId.hashCode),
                focused.hashCode),
            channels.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Unit')
          ..add('name', name)
          ..add('tableName', tableName)
          ..add('productId', productId)
          ..add('focused', focused)
          ..add('channels', channels)
          ..add('id', id))
        .toString();
  }
}

class UnitBuilder implements Builder<Unit, UnitBuilder> {
  _$Unit _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _tableName;
  String get tableName => _$this._tableName;
  set tableName(String tableName) => _$this._tableName = tableName;

  String _productId;
  String get productId => _$this._productId;
  set productId(String productId) => _$this._productId = productId;

  bool _focused;
  bool get focused => _$this._focused;
  set focused(bool focused) => _$this._focused = focused;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  UnitBuilder();

  UnitBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _tableName = _$v.tableName;
      _productId = _$v.productId;
      _focused = _$v.focused;
      _channels = _$v.channels?.toBuilder();
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
    _$Unit _$result;
    try {
      _$result = _$v ??
          new _$Unit._(
              name: name,
              tableName: tableName,
              productId: productId,
              focused: focused,
              channels: channels.build(),
              id: id);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Unit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
