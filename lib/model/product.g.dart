// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
  final String updatedAt;
  @override
  final int count;

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
      this.isDraft,
      this.color,
      this.isCurrentUpdate,
      this.businessId,
      this.supplierId,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.count})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Product', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Product', 'id');
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
        isDraft == other.isDraft &&
        color == other.color &&
        isCurrentUpdate == other.isCurrentUpdate &&
        businessId == other.businessId &&
        supplierId == other.supplierId &&
        categoryId == other.categoryId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        count == other.count;
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
                                                                    0,
                                                                    name
                                                                        .hashCode),
                                                                id.hashCode),
                                                            description
                                                                .hashCode),
                                                        picture.hashCode),
                                                    taxId.hashCode),
                                                active.hashCode),
                                            hasPicture.hashCode),
                                        isDraft.hashCode),
                                    color.hashCode),
                                isCurrentUpdate.hashCode),
                            businessId.hashCode),
                        supplierId.hashCode),
                    categoryId.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        count.hashCode));
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
          ..add('isDraft', isDraft)
          ..add('color', color)
          ..add('isCurrentUpdate', isCurrentUpdate)
          ..add('businessId', businessId)
          ..add('supplierId', supplierId)
          ..add('categoryId', categoryId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('count', count))
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

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

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
      _isDraft = _$v.isDraft;
      _color = _$v.color;
      _isCurrentUpdate = _$v.isCurrentUpdate;
      _businessId = _$v.businessId;
      _supplierId = _$v.supplierId;
      _categoryId = _$v.categoryId;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _count = _$v.count;
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
    final _$result = _$v ??
        new _$Product._(
            name: name,
            id: id,
            description: description,
            picture: picture,
            taxId: taxId,
            active: active,
            hasPicture: hasPicture,
            isDraft: isDraft,
            color: color,
            isCurrentUpdate: isCurrentUpdate,
            businessId: businessId,
            supplierId: supplierId,
            categoryId: categoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            count: count);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
