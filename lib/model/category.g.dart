// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

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
      'tableName',
      serializers.serialize(object.tableName,
          specifiedType: const FullType(String)),
      'touched',
      serializers.serialize(object.touched,
          specifiedType: const FullType(bool)),
    ];
    if (object.focused != null) {
      result
        ..add('focused')
        ..add(serializers.serialize(object.focused,
            specifiedType: const FullType(bool)));
    }
    if (object.branchId != null) {
      result
        ..add('branchId')
        ..add(serializers.serialize(object.branchId,
            specifiedType: const FullType(String)));
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
        case 'tableName':
          result.tableName = serializers.deserialize(value,
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
  final String tableName;
  @override
  final bool touched;
  @override
  final String branchId;

  factory _$Category([void Function(CategoryBuilder) updates]) =>
      (new CategoryBuilder()..update(updates)).build();

  _$Category._(
      {this.name,
      this.id,
      this.focused,
      this.tableName,
      this.touched,
      this.branchId})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Category', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Category', 'id');
    }
    if (tableName == null) {
      throw new BuiltValueNullFieldError('Category', 'tableName');
    }
    if (touched == null) {
      throw new BuiltValueNullFieldError('Category', 'touched');
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
        tableName == other.tableName &&
        touched == other.touched &&
        branchId == other.branchId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, name.hashCode), id.hashCode), focused.hashCode),
                tableName.hashCode),
            touched.hashCode),
        branchId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Category')
          ..add('name', name)
          ..add('id', id)
          ..add('focused', focused)
          ..add('tableName', tableName)
          ..add('touched', touched)
          ..add('branchId', branchId))
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

  String _tableName;
  String get tableName => _$this._tableName;
  set tableName(String tableName) => _$this._tableName = tableName;

  bool _touched;
  bool get touched => _$this._touched;
  set touched(bool touched) => _$this._touched = touched;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  CategoryBuilder();

  CategoryBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _focused = _$v.focused;
      _tableName = _$v.tableName;
      _touched = _$v.touched;
      _branchId = _$v.branchId;
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
    final _$result = _$v ??
        new _$Category._(
            name: name,
            id: id,
            focused: focused,
            tableName: tableName,
            touched: touched,
            branchId: branchId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
