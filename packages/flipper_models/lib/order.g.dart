// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Order> _$orderSerializer = new _$OrderSerializer();

class _$OrderSerializer implements StructuredSerializer<Order> {
  @override
  final Iterable<Type> types = const [Order, _$Order];
  @override
  final String wireName = 'Order';

  @override
  Iterable<Object> serialize(Serializers serializers, Order object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
      'cashReceived',
      serializers.serialize(object.cashReceived,
          specifiedType: const FullType(double)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.reference != null) {
      result
        ..add('reference')
        ..add(serializers.serialize(object.reference,
            specifiedType: const FullType(String)));
    }
    if (object.isDraft != null) {
      result
        ..add('isDraft')
        ..add(serializers.serialize(object.isDraft,
            specifiedType: const FullType(bool)));
    }
    if (object.orderType != null) {
      result
        ..add('orderType')
        ..add(serializers.serialize(object.orderType,
            specifiedType: const FullType(String)));
    }
    if (object.orderNUmber != null) {
      result
        ..add('orderNUmber')
        ..add(serializers.serialize(object.orderNUmber,
            specifiedType: const FullType(String)));
    }
    if (object.subTotal != null) {
      result
        ..add('subTotal')
        ..add(serializers.serialize(object.subTotal,
            specifiedType: const FullType(double)));
    }
    if (object.taxAmount != null) {
      result
        ..add('taxAmount')
        ..add(serializers.serialize(object.taxAmount,
            specifiedType: const FullType(double)));
    }
    if (object.saleTotal != null) {
      result
        ..add('saleTotal')
        ..add(serializers.serialize(object.saleTotal,
            specifiedType: const FullType(double)));
    }
    if (object.orderNote != null) {
      result
        ..add('orderNote')
        ..add(serializers.serialize(object.orderNote,
            specifiedType: const FullType(String)));
    }
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(String)));
    }
    if (object.variationId != null) {
      result
        ..add('variationId')
        ..add(serializers.serialize(object.variationId,
            specifiedType: const FullType(String)));
    }
    if (object.productName != null) {
      result
        ..add('productName')
        ..add(serializers.serialize(object.productName,
            specifiedType: const FullType(String)));
    }
    if (object.customerChangeDue != null) {
      result
        ..add('customerChangeDue')
        ..add(serializers.serialize(object.customerChangeDue,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Order deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OrderBuilder();

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
        case 'branchId':
          result.branchId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reference':
          result.reference = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isDraft':
          result.isDraft = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'orderType':
          result.orderType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'orderNUmber':
          result.orderNUmber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subTotal':
          result.subTotal = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'taxAmount':
          result.taxAmount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'cashReceived':
          result.cashReceived = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'saleTotal':
          result.saleTotal = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'orderNote':
          result.orderNote = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variationId':
          result.variationId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productName':
          result.productName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'customerChangeDue':
          result.customerChangeDue = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Order extends Order {
  @override
  final String id;
  @override
  final String branchId;
  @override
  final String reference;
  @override
  final bool isDraft;
  @override
  final String orderType;
  @override
  final String orderNUmber;
  @override
  final double subTotal;
  @override
  final double taxAmount;
  @override
  final double cashReceived;
  @override
  final double saleTotal;
  @override
  final String orderNote;
  @override
  final String status;
  @override
  final String variationId;
  @override
  final String productName;
  @override
  final BuiltList<String> channels;
  @override
  final String customerChangeDue;

  factory _$Order([void Function(OrderBuilder) updates]) =>
      (new OrderBuilder()..update(updates)).build();

  _$Order._(
      {this.id,
      this.branchId,
      this.reference,
      this.isDraft,
      this.orderType,
      this.orderNUmber,
      this.subTotal,
      this.taxAmount,
      this.cashReceived,
      this.saleTotal,
      this.orderNote,
      this.status,
      this.variationId,
      this.productName,
      this.channels,
      this.customerChangeDue})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Order', 'id');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Order', 'branchId');
    }
    if (cashReceived == null) {
      throw new BuiltValueNullFieldError('Order', 'cashReceived');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Order', 'channels');
    }
  }

  @override
  Order rebuild(void Function(OrderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderBuilder toBuilder() => new OrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Order &&
        id == other.id &&
        branchId == other.branchId &&
        reference == other.reference &&
        isDraft == other.isDraft &&
        orderType == other.orderType &&
        orderNUmber == other.orderNUmber &&
        subTotal == other.subTotal &&
        taxAmount == other.taxAmount &&
        cashReceived == other.cashReceived &&
        saleTotal == other.saleTotal &&
        orderNote == other.orderNote &&
        status == other.status &&
        variationId == other.variationId &&
        productName == other.productName &&
        channels == other.channels &&
        customerChangeDue == other.customerChangeDue;
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
                                                                    id
                                                                        .hashCode),
                                                                branchId
                                                                    .hashCode),
                                                            reference.hashCode),
                                                        isDraft.hashCode),
                                                    orderType.hashCode),
                                                orderNUmber.hashCode),
                                            subTotal.hashCode),
                                        taxAmount.hashCode),
                                    cashReceived.hashCode),
                                saleTotal.hashCode),
                            orderNote.hashCode),
                        status.hashCode),
                    variationId.hashCode),
                productName.hashCode),
            channels.hashCode),
        customerChangeDue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Order')
          ..add('id', id)
          ..add('branchId', branchId)
          ..add('reference', reference)
          ..add('isDraft', isDraft)
          ..add('orderType', orderType)
          ..add('orderNUmber', orderNUmber)
          ..add('subTotal', subTotal)
          ..add('taxAmount', taxAmount)
          ..add('cashReceived', cashReceived)
          ..add('saleTotal', saleTotal)
          ..add('orderNote', orderNote)
          ..add('status', status)
          ..add('variationId', variationId)
          ..add('productName', productName)
          ..add('channels', channels)
          ..add('customerChangeDue', customerChangeDue))
        .toString();
  }
}

class OrderBuilder implements Builder<Order, OrderBuilder> {
  _$Order _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  String _reference;
  String get reference => _$this._reference;
  set reference(String reference) => _$this._reference = reference;

  bool _isDraft;
  bool get isDraft => _$this._isDraft;
  set isDraft(bool isDraft) => _$this._isDraft = isDraft;

  String _orderType;
  String get orderType => _$this._orderType;
  set orderType(String orderType) => _$this._orderType = orderType;

  String _orderNUmber;
  String get orderNUmber => _$this._orderNUmber;
  set orderNUmber(String orderNUmber) => _$this._orderNUmber = orderNUmber;

  double _subTotal;
  double get subTotal => _$this._subTotal;
  set subTotal(double subTotal) => _$this._subTotal = subTotal;

  double _taxAmount;
  double get taxAmount => _$this._taxAmount;
  set taxAmount(double taxAmount) => _$this._taxAmount = taxAmount;

  double _cashReceived;
  double get cashReceived => _$this._cashReceived;
  set cashReceived(double cashReceived) => _$this._cashReceived = cashReceived;

  double _saleTotal;
  double get saleTotal => _$this._saleTotal;
  set saleTotal(double saleTotal) => _$this._saleTotal = saleTotal;

  String _orderNote;
  String get orderNote => _$this._orderNote;
  set orderNote(String orderNote) => _$this._orderNote = orderNote;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  String _variationId;
  String get variationId => _$this._variationId;
  set variationId(String variationId) => _$this._variationId = variationId;

  String _productName;
  String get productName => _$this._productName;
  set productName(String productName) => _$this._productName = productName;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  String _customerChangeDue;
  String get customerChangeDue => _$this._customerChangeDue;
  set customerChangeDue(String customerChangeDue) =>
      _$this._customerChangeDue = customerChangeDue;

  OrderBuilder();

  OrderBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _branchId = _$v.branchId;
      _reference = _$v.reference;
      _isDraft = _$v.isDraft;
      _orderType = _$v.orderType;
      _orderNUmber = _$v.orderNUmber;
      _subTotal = _$v.subTotal;
      _taxAmount = _$v.taxAmount;
      _cashReceived = _$v.cashReceived;
      _saleTotal = _$v.saleTotal;
      _orderNote = _$v.orderNote;
      _status = _$v.status;
      _variationId = _$v.variationId;
      _productName = _$v.productName;
      _channels = _$v.channels?.toBuilder();
      _customerChangeDue = _$v.customerChangeDue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Order other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Order;
  }

  @override
  void update(void Function(OrderBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Order build() {
    _$Order _$result;
    try {
      _$result = _$v ??
          new _$Order._(
              id: id,
              branchId: branchId,
              reference: reference,
              isDraft: isDraft,
              orderType: orderType,
              orderNUmber: orderNUmber,
              subTotal: subTotal,
              taxAmount: taxAmount,
              cashReceived: cashReceived,
              saleTotal: saleTotal,
              orderNote: orderNote,
              status: status,
              variationId: variationId,
              productName: productName,
              channels: channels.build(),
              customerChangeDue: customerChangeDue);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Order', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
