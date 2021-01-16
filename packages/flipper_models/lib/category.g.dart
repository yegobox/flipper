// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Category> _$categorySerializer = new _$CategorySerializer();

class _$CategorySerializer implements StructuredSerializer<Category> {
  @override
  final Iterable<Type> types = const [Category, _$Category];
  @override
  final String wireName = 'Category';

  @override
  Iterable<Object> serialize(Serializers serializers, Category object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.focused != null) {
      result
        ..add('focused')
        ..add(serializers.serialize(object.focused,
            specifiedType: const FullType(bool)));
    }
    if (object.touched != null) {
      result
        ..add('touched')
        ..add(serializers.serialize(object.touched,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Category deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CategoryBuilder();

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
        case 'focused':
          result.focused = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'touched':
          result.touched = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'branchId':
          result.branchId = serializers.deserialize(value,
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

class _$Category extends Category {
  @override
  final String name;
  @override
  final String id;
  @override
  final bool focused;
  @override
  final String table;
  @override
  final bool touched;
  @override
  final String branchId;
  @override
  final BuiltList<String> channels;

  factory _$Category([void Function(CategoryBuilder) updates]) =>
      (new CategoryBuilder()..update(updates)).build();

  _$Category._(
      {this.name,
      this.id,
      this.focused,
      this.table,
      this.touched,
      this.branchId,
      this.channels})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Category', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Category', 'id');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Category', 'table');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Category', 'branchId');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Category', 'channels');
    }
  }

  @override
  Category rebuild(void Function(CategoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryBuilder toBuilder() => new CategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Category &&
        name == other.name &&
        id == other.id &&
        focused == other.focused &&
        table == other.table &&
        touched == other.touched &&
        branchId == other.branchId &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, name.hashCode), id.hashCode),
                        focused.hashCode),
                    table.hashCode),
                touched.hashCode),
            branchId.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Category')
          ..add('name', name)
          ..add('id', id)
          ..add('focused', focused)
          ..add('table', table)
          ..add('touched', touched)
          ..add('branchId', branchId)
          ..add('channels', channels))
        .toString();
  }
}

class CategoryBuilder implements Builder<Category, CategoryBuilder> {
  _$Category _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _focused;
  bool get focused => _$this._focused;
  set focused(bool focused) => _$this._focused = focused;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  bool _touched;
  bool get touched => _$this._touched;
  set touched(bool touched) => _$this._touched = touched;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  CategoryBuilder();

  CategoryBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _focused = _$v.focused;
      _table = _$v.table;
      _touched = _$v.touched;
      _branchId = _$v.branchId;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Category other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Category;
  }

  @override
  void update(void Function(CategoryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Category build() {
    _$Category _$result;
    try {
      _$result = _$v ??
          new _$Category._(
              name: name,
              id: id,
              focused: focused,
              table: table,
              touched: touched,
              branchId: branchId,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Category', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
