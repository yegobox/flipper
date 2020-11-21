// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pcolor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PColor> _$pColorSerializer = new _$PColorSerializer();

class _$PColorSerializer implements StructuredSerializer<PColor> {
  @override
  final Iterable<Type> types = const [PColor, _$PColor];
  @override
  final String wireName = 'PColor';

  @override
  Iterable<Object> serialize(Serializers serializers, PColor object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'isActive',
      serializers.serialize(object.isActive,
          specifiedType: const FullType(bool)),
    ];
    if (object.channels != null) {
      result
        ..add('channels')
        ..add(serializers.serialize(object.channels,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  PColor deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PColorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isActive':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
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

class _$PColor extends PColor {
  @override
  final String id;
  @override
  final String name;
  @override
  final String table;
  @override
  final bool isActive;
  @override
  final BuiltList<String> channels;

  factory _$PColor([void Function(PColorBuilder) updates]) =>
      (new PColorBuilder()..update(updates)).build();

  _$PColor._({this.id, this.name, this.table, this.isActive, this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PColor', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('PColor', 'name');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('PColor', 'table');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('PColor', 'isActive');
    }
  }

  @override
  PColor rebuild(void Function(PColorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PColorBuilder toBuilder() => new PColorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PColor &&
        id == other.id &&
        name == other.name &&
        table == other.table &&
        isActive == other.isActive &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), table.hashCode),
            isActive.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PColor')
          ..add('id', id)
          ..add('name', name)
          ..add('table', table)
          ..add('isActive', isActive)
          ..add('channels', channels))
        .toString();
  }
}

class PColorBuilder implements Builder<PColor, PColorBuilder> {
  _$PColor _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  PColorBuilder();

  PColorBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _table = _$v.table;
      _isActive = _$v.isActive;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PColor other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PColor;
  }

  @override
  void update(void Function(PColorBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PColor build() {
    _$PColor _$result;
    try {
      _$result = _$v ??
          new _$PColor._(
              id: id,
              name: name,
              table: table,
              isActive: isActive,
              channels: _channels?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        _channels?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PColor', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
