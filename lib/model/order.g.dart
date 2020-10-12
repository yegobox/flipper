// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

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
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
      'orderNUmber',
      serializers.serialize(object.orderNUmber,
          specifiedType: const FullType(int)),
      'supplierId',
      serializers.serialize(object.supplierId,
          specifiedType: const FullType(int)),
      'subTotal',
      serializers.serialize(object.subTotal,
          specifiedType: const FullType(int)),
      'supplierInvoiceNumber',
      serializers.serialize(object.supplierInvoiceNumber,
          specifiedType: const FullType(int)),
      'deliverDate',
      serializers.serialize(object.deliverDate,
          specifiedType: const FullType(DateTime)),
      'taxRate',
      serializers.serialize(object.taxRate, specifiedType: const FullType(int)),
      'taxAmount',
      serializers.serialize(object.taxAmount,
          specifiedType: const FullType(int)),
      'discountRate',
      serializers.serialize(object.discountRate,
          specifiedType: const FullType(int)),
      'discountAmount',
      serializers.serialize(object.discountAmount,
          specifiedType: const FullType(int)),
      'cashReceived',
      serializers.serialize(object.cashReceived,
          specifiedType: const FullType(int)),
      'saleTotal',
      serializers.serialize(object.saleTotal,
          specifiedType: const FullType(int)),
      'customerSaving',
      serializers.serialize(object.customerSaving,
          specifiedType: const FullType(int)),
      'paymentId',
      serializers.serialize(object.paymentId,
          specifiedType: const FullType(int)),
      'orderNote',
      serializers.serialize(object.orderNote,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'customerChangeDue',
      serializers.serialize(object.customerChangeDue,
          specifiedType: const FullType(int)),
    ];
    if (object.deviceId != null) {
      result
        ..add('deviceId')
        ..add(serializers.serialize(object.deviceId,
            specifiedType: const FullType(String)));
    }
    if (object.currency != null) {
      result
        ..add('currency')
        ..add(serializers.serialize(object.currency,
            specifiedType: const FullType(String)));
    }
    if (object.reference != null) {
      result
        ..add('reference')
        ..add(serializers.serialize(object.reference,
            specifiedType: const FullType(String)));
    }
    if (object.idLocal != null) {
      result
        ..add('idLocal')
        ..add(serializers.serialize(object.idLocal,
            specifiedType: const FullType(String)));
    }
    if (object.orderDate != null) {
      result
        ..add('orderDate')
        ..add(serializers.serialize(object.orderDate,
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
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'branchId':
          result.branchId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'deviceId':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'currency':
          result.currency = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reference':
          result.reference = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'idLocal':
          result.idLocal = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'orderDate':
          result.orderDate = serializers.deserialize(value,
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
              specifiedType: const FullType(int)) as int;
          break;
        case 'supplierId':
          result.supplierId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'subTotal':
          result.subTotal = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'supplierInvoiceNumber':
          result.supplierInvoiceNumber = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deliverDate':
          result.deliverDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'taxRate':
          result.taxRate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'taxAmount':
          result.taxAmount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'discountRate':
          result.discountRate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'discountAmount':
          result.discountAmount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'cashReceived':
          result.cashReceived = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'saleTotal':
          result.saleTotal = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'customerSaving':
          result.customerSaving = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'paymentId':
          result.paymentId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'orderNote':
          result.orderNote = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'customerChangeDue':
          result.customerChangeDue = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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
  final int userId;
  @override
  final String branchId;
  @override
  final String deviceId;
  @override
  final String currency;
  @override
  final String reference;
  @override
  final String idLocal;
  @override
  final String orderDate;
  @override
  final bool isDraft;
  @override
  final String orderType;
  @override
  final int orderNUmber;
  @override
  final int supplierId;
  @override
  final int subTotal;
  @override
  final int supplierInvoiceNumber;
  @override
  final DateTime deliverDate;
  @override
  final int taxRate;
  @override
  final int taxAmount;
  @override
  final int discountRate;
  @override
  final int discountAmount;
  @override
  final int cashReceived;
  @override
  final int saleTotal;
  @override
  final int customerSaving;
  @override
  final int paymentId;
  @override
  final String orderNote;
  @override
  final String status;
  @override
  final int customerChangeDue;

  factory _$Order([void Function(OrderBuilder) updates]) =>
      (new OrderBuilder()..update(updates)).build();

  _$Order._(
      {this.id,
      this.userId,
      this.branchId,
      this.deviceId,
      this.currency,
      this.reference,
      this.idLocal,
      this.orderDate,
      this.isDraft,
      this.orderType,
      this.orderNUmber,
      this.supplierId,
      this.subTotal,
      this.supplierInvoiceNumber,
      this.deliverDate,
      this.taxRate,
      this.taxAmount,
      this.discountRate,
      this.discountAmount,
      this.cashReceived,
      this.saleTotal,
      this.customerSaving,
      this.paymentId,
      this.orderNote,
      this.status,
      this.customerChangeDue})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Order', 'id');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('Order', 'userId');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Order', 'branchId');
    }
    if (orderNUmber == null) {
      throw new BuiltValueNullFieldError('Order', 'orderNUmber');
    }
    if (supplierId == null) {
      throw new BuiltValueNullFieldError('Order', 'supplierId');
    }
    if (subTotal == null) {
      throw new BuiltValueNullFieldError('Order', 'subTotal');
    }
    if (supplierInvoiceNumber == null) {
      throw new BuiltValueNullFieldError('Order', 'supplierInvoiceNumber');
    }
    if (deliverDate == null) {
      throw new BuiltValueNullFieldError('Order', 'deliverDate');
    }
    if (taxRate == null) {
      throw new BuiltValueNullFieldError('Order', 'taxRate');
    }
    if (taxAmount == null) {
      throw new BuiltValueNullFieldError('Order', 'taxAmount');
    }
    if (discountRate == null) {
      throw new BuiltValueNullFieldError('Order', 'discountRate');
    }
    if (discountAmount == null) {
      throw new BuiltValueNullFieldError('Order', 'discountAmount');
    }
    if (cashReceived == null) {
      throw new BuiltValueNullFieldError('Order', 'cashReceived');
    }
    if (saleTotal == null) {
      throw new BuiltValueNullFieldError('Order', 'saleTotal');
    }
    if (customerSaving == null) {
      throw new BuiltValueNullFieldError('Order', 'customerSaving');
    }
    if (paymentId == null) {
      throw new BuiltValueNullFieldError('Order', 'paymentId');
    }
    if (orderNote == null) {
      throw new BuiltValueNullFieldError('Order', 'orderNote');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('Order', 'status');
    }
    if (customerChangeDue == null) {
      throw new BuiltValueNullFieldError('Order', 'customerChangeDue');
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
        userId == other.userId &&
        branchId == other.branchId &&
        deviceId == other.deviceId &&
        currency == other.currency &&
        reference == other.reference &&
        idLocal == other.idLocal &&
        orderDate == other.orderDate &&
        isDraft == other.isDraft &&
        orderType == other.orderType &&
        orderNUmber == other.orderNUmber &&
        supplierId == other.supplierId &&
        subTotal == other.subTotal &&
        supplierInvoiceNumber == other.supplierInvoiceNumber &&
        deliverDate == other.deliverDate &&
        taxRate == other.taxRate &&
        taxAmount == other.taxAmount &&
        discountRate == other.discountRate &&
        discountAmount == other.discountAmount &&
        cashReceived == other.cashReceived &&
        saleTotal == other.saleTotal &&
        customerSaving == other.customerSaving &&
        paymentId == other.paymentId &&
        orderNote == other.orderNote &&
        status == other.status &&
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
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc(0, id.hashCode), userId.hashCode), branchId.hashCode), deviceId.hashCode), currency.hashCode), reference.hashCode), idLocal.hashCode),
                                                                                orderDate.hashCode),
                                                                            isDraft.hashCode),
                                                                        orderType.hashCode),
                                                                    orderNUmber.hashCode),
                                                                supplierId.hashCode),
                                                            subTotal.hashCode),
                                                        supplierInvoiceNumber.hashCode),
                                                    deliverDate.hashCode),
                                                taxRate.hashCode),
                                            taxAmount.hashCode),
                                        discountRate.hashCode),
                                    discountAmount.hashCode),
                                cashReceived.hashCode),
                            saleTotal.hashCode),
                        customerSaving.hashCode),
                    paymentId.hashCode),
                orderNote.hashCode),
            status.hashCode),
        customerChangeDue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Order')
          ..add('id', id)
          ..add('userId', userId)
          ..add('branchId', branchId)
          ..add('deviceId', deviceId)
          ..add('currency', currency)
          ..add('reference', reference)
          ..add('idLocal', idLocal)
          ..add('orderDate', orderDate)
          ..add('isDraft', isDraft)
          ..add('orderType', orderType)
          ..add('orderNUmber', orderNUmber)
          ..add('supplierId', supplierId)
          ..add('subTotal', subTotal)
          ..add('supplierInvoiceNumber', supplierInvoiceNumber)
          ..add('deliverDate', deliverDate)
          ..add('taxRate', taxRate)
          ..add('taxAmount', taxAmount)
          ..add('discountRate', discountRate)
          ..add('discountAmount', discountAmount)
          ..add('cashReceived', cashReceived)
          ..add('saleTotal', saleTotal)
          ..add('customerSaving', customerSaving)
          ..add('paymentId', paymentId)
          ..add('orderNote', orderNote)
          ..add('status', status)
          ..add('customerChangeDue', customerChangeDue))
        .toString();
  }
}

class OrderBuilder implements Builder<Order, OrderBuilder> {
  _$Order _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  String _deviceId;
  String get deviceId => _$this._deviceId;
  set deviceId(String deviceId) => _$this._deviceId = deviceId;

  String _currency;
  String get currency => _$this._currency;
  set currency(String currency) => _$this._currency = currency;

  String _reference;
  String get reference => _$this._reference;
  set reference(String reference) => _$this._reference = reference;

  String _idLocal;
  String get idLocal => _$this._idLocal;
  set idLocal(String idLocal) => _$this._idLocal = idLocal;

  String _orderDate;
  String get orderDate => _$this._orderDate;
  set orderDate(String orderDate) => _$this._orderDate = orderDate;

  bool _isDraft;
  bool get isDraft => _$this._isDraft;
  set isDraft(bool isDraft) => _$this._isDraft = isDraft;

  String _orderType;
  String get orderType => _$this._orderType;
  set orderType(String orderType) => _$this._orderType = orderType;

  int _orderNUmber;
  int get orderNUmber => _$this._orderNUmber;
  set orderNUmber(int orderNUmber) => _$this._orderNUmber = orderNUmber;

  int _supplierId;
  int get supplierId => _$this._supplierId;
  set supplierId(int supplierId) => _$this._supplierId = supplierId;

  int _subTotal;
  int get subTotal => _$this._subTotal;
  set subTotal(int subTotal) => _$this._subTotal = subTotal;

  int _supplierInvoiceNumber;
  int get supplierInvoiceNumber => _$this._supplierInvoiceNumber;
  set supplierInvoiceNumber(int supplierInvoiceNumber) =>
      _$this._supplierInvoiceNumber = supplierInvoiceNumber;

  DateTime _deliverDate;
  DateTime get deliverDate => _$this._deliverDate;
  set deliverDate(DateTime deliverDate) => _$this._deliverDate = deliverDate;

  int _taxRate;
  int get taxRate => _$this._taxRate;
  set taxRate(int taxRate) => _$this._taxRate = taxRate;

  int _taxAmount;
  int get taxAmount => _$this._taxAmount;
  set taxAmount(int taxAmount) => _$this._taxAmount = taxAmount;

  int _discountRate;
  int get discountRate => _$this._discountRate;
  set discountRate(int discountRate) => _$this._discountRate = discountRate;

  int _discountAmount;
  int get discountAmount => _$this._discountAmount;
  set discountAmount(int discountAmount) =>
      _$this._discountAmount = discountAmount;

  int _cashReceived;
  int get cashReceived => _$this._cashReceived;
  set cashReceived(int cashReceived) => _$this._cashReceived = cashReceived;

  int _saleTotal;
  int get saleTotal => _$this._saleTotal;
  set saleTotal(int saleTotal) => _$this._saleTotal = saleTotal;

  int _customerSaving;
  int get customerSaving => _$this._customerSaving;
  set customerSaving(int customerSaving) =>
      _$this._customerSaving = customerSaving;

  int _paymentId;
  int get paymentId => _$this._paymentId;
  set paymentId(int paymentId) => _$this._paymentId = paymentId;

  String _orderNote;
  String get orderNote => _$this._orderNote;
  set orderNote(String orderNote) => _$this._orderNote = orderNote;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  int _customerChangeDue;
  int get customerChangeDue => _$this._customerChangeDue;
  set customerChangeDue(int customerChangeDue) =>
      _$this._customerChangeDue = customerChangeDue;

  OrderBuilder();

  OrderBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _userId = _$v.userId;
      _branchId = _$v.branchId;
      _deviceId = _$v.deviceId;
      _currency = _$v.currency;
      _reference = _$v.reference;
      _idLocal = _$v.idLocal;
      _orderDate = _$v.orderDate;
      _isDraft = _$v.isDraft;
      _orderType = _$v.orderType;
      _orderNUmber = _$v.orderNUmber;
      _supplierId = _$v.supplierId;
      _subTotal = _$v.subTotal;
      _supplierInvoiceNumber = _$v.supplierInvoiceNumber;
      _deliverDate = _$v.deliverDate;
      _taxRate = _$v.taxRate;
      _taxAmount = _$v.taxAmount;
      _discountRate = _$v.discountRate;
      _discountAmount = _$v.discountAmount;
      _cashReceived = _$v.cashReceived;
      _saleTotal = _$v.saleTotal;
      _customerSaving = _$v.customerSaving;
      _paymentId = _$v.paymentId;
      _orderNote = _$v.orderNote;
      _status = _$v.status;
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
    final _$result = _$v ??
        new _$Order._(
            id: id,
            userId: userId,
            branchId: branchId,
            deviceId: deviceId,
            currency: currency,
            reference: reference,
            idLocal: idLocal,
            orderDate: orderDate,
            isDraft: isDraft,
            orderType: orderType,
            orderNUmber: orderNUmber,
            supplierId: supplierId,
            subTotal: subTotal,
            supplierInvoiceNumber: supplierInvoiceNumber,
            deliverDate: deliverDate,
            taxRate: taxRate,
            taxAmount: taxAmount,
            discountRate: discountRate,
            discountAmount: discountAmount,
            cashReceived: cashReceived,
            saleTotal: saleTotal,
            customerSaving: customerSaving,
            paymentId: paymentId,
            orderNote: orderNote,
            status: status,
            customerChangeDue: customerChangeDue);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
