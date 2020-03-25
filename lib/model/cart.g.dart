// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Cart extends Cart {
  @override
  final String parentName;
  @override
  final String id;
  @override
  final int count;
  @override
  final String variationId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String branchId;
  @override
  final String variationName;

  factory _$Cart([void Function(CartBuilder) updates]) =>
      (new CartBuilder()..update(updates)).build();

  _$Cart._(
      {this.parentName,
      this.id,
      this.count,
      this.variationId,
      this.createdAt,
      this.updatedAt,
      this.branchId,
      this.variationName})
      : super._() {
    if (parentName == null) {
      throw new BuiltValueNullFieldError('Cart', 'parentName');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Cart', 'id');
    }
    if (count == null) {
      throw new BuiltValueNullFieldError('Cart', 'count');
    }
    if (variationId == null) {
      throw new BuiltValueNullFieldError('Cart', 'variationId');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Cart', 'branchId');
    }
    if (variationName == null) {
      throw new BuiltValueNullFieldError('Cart', 'variationName');
    }
  }

  @override
  Cart rebuild(void Function(CartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartBuilder toBuilder() => new CartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cart &&
        parentName == other.parentName &&
        id == other.id &&
        count == other.count &&
        variationId == other.variationId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        branchId == other.branchId &&
        variationName == other.variationName;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, parentName.hashCode), id.hashCode),
                            count.hashCode),
                        variationId.hashCode),
                    createdAt.hashCode),
                updatedAt.hashCode),
            branchId.hashCode),
        variationName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Cart')
          ..add('parentName', parentName)
          ..add('id', id)
          ..add('count', count)
          ..add('variationId', variationId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('branchId', branchId)
          ..add('variationName', variationName))
        .toString();
  }
}

class CartBuilder implements Builder<Cart, CartBuilder> {
  _$Cart _$v;

  String _parentName;
  String get parentName => _$this._parentName;
  set parentName(String parentName) => _$this._parentName = parentName;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  String _variationId;
  String get variationId => _$this._variationId;
  set variationId(String variationId) => _$this._variationId = variationId;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  String _variationName;
  String get variationName => _$this._variationName;
  set variationName(String variationName) =>
      _$this._variationName = variationName;

  CartBuilder();

  CartBuilder get _$this {
    if (_$v != null) {
      _parentName = _$v.parentName;
      _id = _$v.id;
      _count = _$v.count;
      _variationId = _$v.variationId;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _branchId = _$v.branchId;
      _variationName = _$v.variationName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Cart other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Cart;
  }

  @override
  void update(void Function(CartBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Cart build() {
    final _$result = _$v ??
        new _$Cart._(
            parentName: parentName,
            id: id,
            count: count,
            variationId: variationId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            branchId: branchId,
            variationName: variationName);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
