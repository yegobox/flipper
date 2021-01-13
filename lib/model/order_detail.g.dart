// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OrderDetail> _$orderDetailSerializer = new _$OrderDetailSerializer();

class _$OrderDetailSerializer implements StructuredSerializer<OrderDetail> {
  @override
  final Iterable<Type> types = const [OrderDetail, _$OrderDetail];
  @override
  final String wireName = 'OrderDetail';

  @override
  Iterable<Object> serialize(Serializers serializers, OrderDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'productName',
      serializers.serialize(object.productName,
          specifiedType: const FullType(String)),
      'stockId',
      serializers.serialize(object.stockId,
          specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(String)),
      'variantId',
      serializers.serialize(object.variantId,
          specifiedType: const FullType(String)),
      'discountAmount',
      serializers.serialize(object.discountAmount,
          specifiedType: const FullType(double)),
      'orderId',
      serializers.serialize(object.orderId,
          specifiedType: const FullType(String)),
      'subTotal',
      serializers.serialize(object.subTotal,
          specifiedType: const FullType(double)),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.price != null) {
      result
        ..add('price')
        ..add(serializers.serialize(object.price,
            specifiedType: const FullType(String)));
    }
    if (object.variantName != null) {
      result
        ..add('variantName')
        ..add(serializers.serialize(object.variantName,
            specifiedType: const FullType(String)));
    }
    if (object.canTrackStock != null) {
      result
        ..add('canTrackStock')
        ..add(serializers.serialize(object.canTrackStock,
            specifiedType: const FullType(String)));
    }
    if (object.unit != null) {
      result
        ..add('unit')
        ..add(serializers.serialize(object.unit,
            specifiedType: const FullType(String)));
    }
    if (object.sku != null) {
      result
        ..add('sku')
        ..add(serializers.serialize(object.sku,
            specifiedType: const FullType(String)));
    }
    if (object.taxRate != null) {
      result
        ..add('taxRate')
        ..add(serializers.serialize(object.taxRate,
            specifiedType: const FullType(int)));
    }
    if (object.taxAmount != null) {
      result
        ..add('taxAmount')
        ..add(serializers.serialize(object.taxAmount,
            specifiedType: const FullType(double)));
    }
    if (object.discountRate != null) {
      result
        ..add('discountRate')
        ..add(serializers.serialize(object.discountRate,
            specifiedType: const FullType(double)));
    }
    if (object.note != null) {
      result
        ..add('note')
        ..add(serializers.serialize(object.note,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OrderDetail deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OrderDetailBuilder();

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
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variantName':
          result.variantName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productName':
          result.productName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'canTrackStock':
          result.canTrackStock = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'stockId':
          result.stockId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sku':
          result.sku = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variantId':
          result.variantId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'taxRate':
          result.taxRate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'taxAmount':
          result.taxAmount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'discountRate':
          result.discountRate = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'discountAmount':
          result.discountAmount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'orderId':
          result.orderId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subTotal':
          result.subTotal = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
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

class _$OrderDetail extends OrderDetail {
  @override
  final String id;
  @override
  final String price;
  @override
  final String variantName;
  @override
  final String productName;
  @override
  final String canTrackStock;
  @override
  final String stockId;
  @override
  final String unit;
  @override
  final String sku;
  @override
  final String quantity;
  @override
  final String variantId;
  @override
  final int taxRate;
  @override
  final double taxAmount;
  @override
  final double discountRate;
  @override
  final String note;
  @override
  final double discountAmount;
  @override
  final String orderId;
  @override
  final double subTotal;
  @override
  final String table;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final BuiltList<String> channels;

  factory _$OrderDetail([void Function(OrderDetailBuilder) updates]) =>
      (new OrderDetailBuilder()..update(updates)).build();

  _$OrderDetail._(
      {this.id,
      this.price,
      this.variantName,
      this.productName,
      this.canTrackStock,
      this.stockId,
      this.unit,
      this.sku,
      this.quantity,
      this.variantId,
      this.taxRate,
      this.taxAmount,
      this.discountRate,
      this.note,
      this.discountAmount,
      this.orderId,
      this.subTotal,
      this.table,
      this.createdAt,
      this.updatedAt,
      this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'id');
    }
    if (productName == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'productName');
    }
    if (stockId == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'stockId');
    }
    if (quantity == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'quantity');
    }
    if (variantId == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'variantId');
    }
    if (discountAmount == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'discountAmount');
    }
    if (orderId == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'orderId');
    }
    if (subTotal == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'subTotal');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'table');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'updatedAt');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('OrderDetail', 'channels');
    }
  }

  @override
  OrderDetail rebuild(void Function(OrderDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDetailBuilder toBuilder() => new OrderDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDetail &&
        id == other.id &&
        price == other.price &&
        variantName == other.variantName &&
        productName == other.productName &&
        canTrackStock == other.canTrackStock &&
        stockId == other.stockId &&
        unit == other.unit &&
        sku == other.sku &&
        quantity == other.quantity &&
        variantId == other.variantId &&
        taxRate == other.taxRate &&
        taxAmount == other.taxAmount &&
        discountRate == other.discountRate &&
        note == other.note &&
        discountAmount == other.discountAmount &&
        orderId == other.orderId &&
        subTotal == other.subTotal &&
        table == other.table &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
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
                                                                            $jc($jc($jc(0, id.hashCode), price.hashCode),
                                                                                variantName.hashCode),
                                                                            productName.hashCode),
                                                                        canTrackStock.hashCode),
                                                                    stockId.hashCode),
                                                                unit.hashCode),
                                                            sku.hashCode),
                                                        quantity.hashCode),
                                                    variantId.hashCode),
                                                taxRate.hashCode),
                                            taxAmount.hashCode),
                                        discountRate.hashCode),
                                    note.hashCode),
                                discountAmount.hashCode),
                            orderId.hashCode),
                        subTotal.hashCode),
                    table.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('OrderDetail')
          ..add('id', id)
          ..add('price', price)
          ..add('variantName', variantName)
          ..add('productName', productName)
          ..add('canTrackStock', canTrackStock)
          ..add('stockId', stockId)
          ..add('unit', unit)
          ..add('sku', sku)
          ..add('quantity', quantity)
          ..add('variantId', variantId)
          ..add('taxRate', taxRate)
          ..add('taxAmount', taxAmount)
          ..add('discountRate', discountRate)
          ..add('note', note)
          ..add('discountAmount', discountAmount)
          ..add('orderId', orderId)
          ..add('subTotal', subTotal)
          ..add('table', table)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('channels', channels))
        .toString();
  }
}

class OrderDetailBuilder implements Builder<OrderDetail, OrderDetailBuilder> {
  _$OrderDetail _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _price;
  String get price => _$this._price;
  set price(String price) => _$this._price = price;

  String _variantName;
  String get variantName => _$this._variantName;
  set variantName(String variantName) => _$this._variantName = variantName;

  String _productName;
  String get productName => _$this._productName;
  set productName(String productName) => _$this._productName = productName;

  String _canTrackStock;
  String get canTrackStock => _$this._canTrackStock;
  set canTrackStock(String canTrackStock) =>
      _$this._canTrackStock = canTrackStock;

  String _stockId;
  String get stockId => _$this._stockId;
  set stockId(String stockId) => _$this._stockId = stockId;

  String _unit;
  String get unit => _$this._unit;
  set unit(String unit) => _$this._unit = unit;

  String _sku;
  String get sku => _$this._sku;
  set sku(String sku) => _$this._sku = sku;

  String _quantity;
  String get quantity => _$this._quantity;
  set quantity(String quantity) => _$this._quantity = quantity;

  String _variantId;
  String get variantId => _$this._variantId;
  set variantId(String variantId) => _$this._variantId = variantId;

  int _taxRate;
  int get taxRate => _$this._taxRate;
  set taxRate(int taxRate) => _$this._taxRate = taxRate;

  double _taxAmount;
  double get taxAmount => _$this._taxAmount;
  set taxAmount(double taxAmount) => _$this._taxAmount = taxAmount;

  double _discountRate;
  double get discountRate => _$this._discountRate;
  set discountRate(double discountRate) => _$this._discountRate = discountRate;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  double _discountAmount;
  double get discountAmount => _$this._discountAmount;
  set discountAmount(double discountAmount) =>
      _$this._discountAmount = discountAmount;

  String _orderId;
  String get orderId => _$this._orderId;
  set orderId(String orderId) => _$this._orderId = orderId;

  double _subTotal;
  double get subTotal => _$this._subTotal;
  set subTotal(double subTotal) => _$this._subTotal = subTotal;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  OrderDetailBuilder();

  OrderDetailBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _price = _$v.price;
      _variantName = _$v.variantName;
      _productName = _$v.productName;
      _canTrackStock = _$v.canTrackStock;
      _stockId = _$v.stockId;
      _unit = _$v.unit;
      _sku = _$v.sku;
      _quantity = _$v.quantity;
      _variantId = _$v.variantId;
      _taxRate = _$v.taxRate;
      _taxAmount = _$v.taxAmount;
      _discountRate = _$v.discountRate;
      _note = _$v.note;
      _discountAmount = _$v.discountAmount;
      _orderId = _$v.orderId;
      _subTotal = _$v.subTotal;
      _table = _$v.table;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDetail other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$OrderDetail;
  }

  @override
  void update(void Function(OrderDetailBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$OrderDetail build() {
    _$OrderDetail _$result;
    try {
      _$result = _$v ??
          new _$OrderDetail._(
              id: id,
              price: price,
              variantName: variantName,
              productName: productName,
              canTrackStock: canTrackStock,
              stockId: stockId,
              unit: unit,
              sku: sku,
              quantity: quantity,
              variantId: variantId,
              taxRate: taxRate,
              taxAmount: taxAmount,
              discountRate: discountRate,
              note: note,
              discountAmount: discountAmount,
              orderId: orderId,
              subTotal: subTotal,
              table: table,
              createdAt: createdAt,
              updatedAt: updatedAt,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'OrderDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
