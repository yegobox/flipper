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
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
      'focused',
      serializers.serialize(object.focused,
          specifiedType: const FullType(bool)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
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
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'branchId':
          result.branchId = serializers.deserialize(value,
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
  final String table;
  @override
  final String branchId;
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
      this.table,
      this.branchId,
      this.focused,
      this.channels,
      this.id})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Unit', 'name');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Unit', 'table');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Unit', 'branchId');
    }
    if (focused == null) {
      throw new BuiltValueNullFieldError('Unit', 'focused');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Unit', 'channels');
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
        table == other.table &&
        branchId == other.branchId &&
        focused == other.focused &&
        channels == other.channels &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, name.hashCode), table.hashCode),
                    branchId.hashCode),
                focused.hashCode),
            channels.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Unit')
          ..add('name', name)
          ..add('table', table)
          ..add('branchId', branchId)
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

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

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
      _table = _$v.table;
      _branchId = _$v.branchId;
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
              table: table,
              branchId: branchId,
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
