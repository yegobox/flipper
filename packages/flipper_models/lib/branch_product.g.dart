// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BranchProduct extends BranchProduct {
  @override
  final int productId;
  @override
  final int branchId;

  factory _$BranchProduct([void Function(BranchProductBuilder) updates]) =>
      (new BranchProductBuilder()..update(updates)).build();

  _$BranchProduct._({this.productId, this.branchId}) : super._() {
    if (productId == null) {
      throw new BuiltValueNullFieldError('BranchProduct', 'productId');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('BranchProduct', 'branchId');
    }
  }

  @override
  BranchProduct rebuild(void Function(BranchProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BranchProductBuilder toBuilder() => new BranchProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BranchProduct &&
        productId == other.productId &&
        branchId == other.branchId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, productId.hashCode), branchId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BranchProduct')
          ..add('productId', productId)
          ..add('branchId', branchId))
        .toString();
  }
}

class BranchProductBuilder
    implements Builder<BranchProduct, BranchProductBuilder> {
  _$BranchProduct _$v;

  int _productId;
  int get productId => _$this._productId;
  set productId(int productId) => _$this._productId = productId;

  int _branchId;
  int get branchId => _$this._branchId;
  set branchId(int branchId) => _$this._branchId = branchId;

  BranchProductBuilder();

  BranchProductBuilder get _$this {
    if (_$v != null) {
      _productId = _$v.productId;
      _branchId = _$v.branchId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BranchProduct other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BranchProduct;
  }

  @override
  void update(void Function(BranchProductBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BranchProduct build() {
    final _$result =
        _$v ?? new _$BranchProduct._(productId: productId, branchId: branchId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
