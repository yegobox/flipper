// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Product> _$productSerializer = new _$ProductSerializer();

class _$ProductSerializer implements StructuredSerializer<Product> {
  @override
  final Iterable<Type> types = const [Product, _$Product];
  @override
  final String wireName = 'Product';

  @override
  Iterable<Object> serialize(Serializers serializers, Product object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.picture != null) {
      result
        ..add('picture')
        ..add(serializers.serialize(object.picture,
            specifiedType: const FullType(String)));
    }
    if (object.taxId != null) {
      result
        ..add('taxId')
        ..add(serializers.serialize(object.taxId,
            specifiedType: const FullType(String)));
    }
    if (object.active != null) {
      result
        ..add('active')
        ..add(serializers.serialize(object.active,
            specifiedType: const FullType(bool)));
    }
    if (object.hasPicture != null) {
      result
        ..add('hasPicture')
        ..add(serializers.serialize(object.hasPicture,
            specifiedType: const FullType(bool)));
    }
    if (object.isImageLocal != null) {
      result
        ..add('isImageLocal')
        ..add(serializers.serialize(object.isImageLocal,
            specifiedType: const FullType(bool)));
    }
    if (object.touched != null) {
      result
        ..add('touched')
        ..add(serializers.serialize(object.touched,
            specifiedType: const FullType(bool)));
    }
    if (object.isDraft != null) {
      result
        ..add('isDraft')
        ..add(serializers.serialize(object.isDraft,
            specifiedType: const FullType(bool)));
    }
    if (object.color != null) {
      result
        ..add('color')
        ..add(serializers.serialize(object.color,
            specifiedType: const FullType(String)));
    }
    if (object.isCurrentUpdate != null) {
      result
        ..add('isCurrentUpdate')
        ..add(serializers.serialize(object.isCurrentUpdate,
            specifiedType: const FullType(bool)));
    }
    if (object.businessId != null) {
      result
        ..add('businessId')
        ..add(serializers.serialize(object.businessId,
            specifiedType: const FullType(String)));
    }
    if (object.supplierId != null) {
      result
        ..add('supplierId')
        ..add(serializers.serialize(object.supplierId,
            specifiedType: const FullType(String)));
    }
    if (object.categoryId != null) {
      result
        ..add('categoryId')
        ..add(serializers.serialize(object.categoryId,
            specifiedType: const FullType(String)));
    }
    if (object.createdAt != null) {
      result
        ..add('createdAt')
        ..add(serializers.serialize(object.createdAt,
            specifiedType: const FullType(String)));
    }
    if (object.unit != null) {
      result
        ..add('unit')
        ..add(serializers.serialize(object.unit,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updatedAt')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    if (object.count != null) {
      result
        ..add('count')
        ..add(serializers.serialize(object.count,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Product deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductBuilder();

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
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'picture':
          result.picture = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'taxId':
          result.taxId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'active':
          result.active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'hasPicture':
          result.hasPicture = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isImageLocal':
          result.isImageLocal = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'touched':
          result.touched = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isDraft':
          result.isDraft = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'color':
          result.color = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isCurrentUpdate':
          result.isCurrentUpdate = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'businessId':
          result.businessId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'supplierId':
          result.supplierId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'categoryId':
          result.categoryId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'count':
          result.count = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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

class _$Product extends Product {
  @override
  final String name;
  @override
  final String id;
  @override
  final String description;
  @override
  final String picture;
  @override
  final String taxId;
  @override
  final bool active;
  @override
  final bool hasPicture;
  @override
  final bool isImageLocal;
  @override
  final bool touched;
  @override
  final String table;
  @override
  final bool isDraft;
  @override
  final String color;
  @override
  final bool isCurrentUpdate;
  @override
  final String businessId;
  @override
  final String supplierId;
  @override
  final String categoryId;
  @override
  final String createdAt;
  @override
  final String unit;
  @override
  final String updatedAt;
  @override
  final int count;
  @override
  final BuiltList<String> channels;

  factory _$Product([void Function(ProductBuilder) updates]) =>
      (new ProductBuilder()..update(updates)).build();

  _$Product._(
      {this.name,
      this.id,
      this.description,
      this.picture,
      this.taxId,
      this.active,
      this.hasPicture,
      this.isImageLocal,
      this.touched,
      this.table,
      this.isDraft,
      this.color,
      this.isCurrentUpdate,
      this.businessId,
      this.supplierId,
      this.categoryId,
      this.createdAt,
      this.unit,
      this.updatedAt,
      this.count,
      this.channels})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Product', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Product', 'id');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Product', 'table');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Product', 'channels');
    }
  }

  @override
  Product rebuild(void Function(ProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductBuilder toBuilder() => new ProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Product &&
        name == other.name &&
        id == other.id &&
        description == other.description &&
        picture == other.picture &&
        taxId == other.taxId &&
        active == other.active &&
        hasPicture == other.hasPicture &&
        isImageLocal == other.isImageLocal &&
        touched == other.touched &&
        table == other.table &&
        isDraft == other.isDraft &&
        color == other.color &&
        isCurrentUpdate == other.isCurrentUpdate &&
        businessId == other.businessId &&
        supplierId == other.supplierId &&
        categoryId == other.categoryId &&
        createdAt == other.createdAt &&
        unit == other.unit &&
        updatedAt == other.updatedAt &&
        count == other.count &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc(0, name.hashCode), id.hashCode),
                                                                                description.hashCode),
                                                                            picture.hashCode),
                                                                        taxId.hashCode),
                                                                    active.hashCode),
                                                                hasPicture.hashCode),
                                                            isImageLocal.hashCode),
                                                        touched.hashCode),
                                                    table.hashCode),
                                                isDraft.hashCode),
                                            color.hashCode),
                                        isCurrentUpdate.hashCode),
                                    businessId.hashCode),
                                supplierId.hashCode),
                            categoryId.hashCode),
                        createdAt.hashCode),
                    unit.hashCode),
                updatedAt.hashCode),
            count.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Product')
          ..add('name', name)
          ..add('id', id)
          ..add('description', description)
          ..add('picture', picture)
          ..add('taxId', taxId)
          ..add('active', active)
          ..add('hasPicture', hasPicture)
          ..add('isImageLocal', isImageLocal)
          ..add('touched', touched)
          ..add('table', table)
          ..add('isDraft', isDraft)
          ..add('color', color)
          ..add('isCurrentUpdate', isCurrentUpdate)
          ..add('businessId', businessId)
          ..add('supplierId', supplierId)
          ..add('categoryId', categoryId)
          ..add('createdAt', createdAt)
          ..add('unit', unit)
          ..add('updatedAt', updatedAt)
          ..add('count', count)
          ..add('channels', channels))
        .toString();
  }
}

class ProductBuilder implements Builder<Product, ProductBuilder> {
  _$Product _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _picture;
  String get picture => _$this._picture;
  set picture(String picture) => _$this._picture = picture;

  String _taxId;
  String get taxId => _$this._taxId;
  set taxId(String taxId) => _$this._taxId = taxId;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  bool _hasPicture;
  bool get hasPicture => _$this._hasPicture;
  set hasPicture(bool hasPicture) => _$this._hasPicture = hasPicture;

  bool _isImageLocal;
  bool get isImageLocal => _$this._isImageLocal;
  set isImageLocal(bool isImageLocal) => _$this._isImageLocal = isImageLocal;

  bool _touched;
  bool get touched => _$this._touched;
  set touched(bool touched) => _$this._touched = touched;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  bool _isDraft;
  bool get isDraft => _$this._isDraft;
  set isDraft(bool isDraft) => _$this._isDraft = isDraft;

  String _color;
  String get color => _$this._color;
  set color(String color) => _$this._color = color;

  bool _isCurrentUpdate;
  bool get isCurrentUpdate => _$this._isCurrentUpdate;
  set isCurrentUpdate(bool isCurrentUpdate) =>
      _$this._isCurrentUpdate = isCurrentUpdate;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  String _supplierId;
  String get supplierId => _$this._supplierId;
  set supplierId(String supplierId) => _$this._supplierId = supplierId;

  String _categoryId;
  String get categoryId => _$this._categoryId;
  set categoryId(String categoryId) => _$this._categoryId = categoryId;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _unit;
  String get unit => _$this._unit;
  set unit(String unit) => _$this._unit = unit;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  ProductBuilder();

  ProductBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _description = _$v.description;
      _picture = _$v.picture;
      _taxId = _$v.taxId;
      _active = _$v.active;
      _hasPicture = _$v.hasPicture;
      _isImageLocal = _$v.isImageLocal;
      _touched = _$v.touched;
      _table = _$v.table;
      _isDraft = _$v.isDraft;
      _color = _$v.color;
      _isCurrentUpdate = _$v.isCurrentUpdate;
      _businessId = _$v.businessId;
      _supplierId = _$v.supplierId;
      _categoryId = _$v.categoryId;
      _createdAt = _$v.createdAt;
      _unit = _$v.unit;
      _updatedAt = _$v.updatedAt;
      _count = _$v.count;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Product other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Product;
  }

  @override
  void update(void Function(ProductBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Product build() {
    _$Product _$result;
    try {
      _$result = _$v ??
          new _$Product._(
              name: name,
              id: id,
              description: description,
              picture: picture,
              taxId: taxId,
              active: active,
              hasPicture: hasPicture,
              isImageLocal: isImageLocal,
              touched: touched,
              table: table,
              isDraft: isDraft,
              color: color,
              isCurrentUpdate: isCurrentUpdate,
              businessId: businessId,
              supplierId: supplierId,
              categoryId: categoryId,
              createdAt: createdAt,
              unit: unit,
              updatedAt: updatedAt,
              count: count,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Product', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
