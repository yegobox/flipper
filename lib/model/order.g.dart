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
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
    ];
    if (object.userId != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(object.userId,
            specifiedType: const FullType(String)));
    }
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
    if (object.orderNUmber != null) {
      result
        ..add('orderNUmber')
        ..add(serializers.serialize(object.orderNUmber,
            specifiedType: const FullType(String)));
    }
    if (object.supplierId != null) {
      result
        ..add('supplierId')
        ..add(serializers.serialize(object.supplierId,
            specifiedType: const FullType(String)));
    }
    if (object.subTotal != null) {
      result
        ..add('subTotal')
        ..add(serializers.serialize(object.subTotal,
            specifiedType: const FullType(String)));
    }
    if (object.supplierInvoiceNumber != null) {
      result
        ..add('supplierInvoiceNumber')
        ..add(serializers.serialize(object.supplierInvoiceNumber,
            specifiedType: const FullType(String)));
    }
    if (object.deliverDate != null) {
      result
        ..add('deliverDate')
        ..add(serializers.serialize(object.deliverDate,
            specifiedType: const FullType(String)));
    }
    if (object.taxRate != null) {
      result
        ..add('taxRate')
        ..add(serializers.serialize(object.taxRate,
            specifiedType: const FullType(String)));
    }
    if (object.taxAmount != null) {
      result
        ..add('taxAmount')
        ..add(serializers.serialize(object.taxAmount,
            specifiedType: const FullType(String)));
    }
    if (object.discountRate != null) {
      result
        ..add('discountRate')
        ..add(serializers.serialize(object.discountRate,
            specifiedType: const FullType(String)));
    }
    if (object.discountAmount != null) {
      result
        ..add('discountAmount')
        ..add(serializers.serialize(object.discountAmount,
            specifiedType: const FullType(String)));
    }
    if (object.cashReceived != null) {
      result
        ..add('cashReceived')
        ..add(serializers.serialize(object.cashReceived,
            specifiedType: const FullType(String)));
    }
    if (object.saleTotal != null) {
      result
        ..add('saleTotal')
        ..add(serializers.serialize(object.saleTotal,
            specifiedType: const FullType(String)));
    }
    if (object.customerSaving != null) {
      result
        ..add('customerSaving')
        ..add(serializers.serialize(object.customerSaving,
            specifiedType: const FullType(String)));
    }
    if (object.paymentId != null) {
      result
        ..add('paymentId')
        ..add(serializers.serialize(object.paymentId,
            specifiedType: const FullType(String)));
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
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
              specifiedType: const FullType(String)) as String;
          break;
        case 'supplierId':
          result.supplierId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subTotal':
          result.subTotal = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'supplierInvoiceNumber':
          result.supplierInvoiceNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'deliverDate':
          result.deliverDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'taxRate':
          result.taxRate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'taxAmount':
          result.taxAmount = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'discountRate':
          result.discountRate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'discountAmount':
          result.discountAmount = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cashReceived':
          result.cashReceived = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'saleTotal':
          result.saleTotal = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'customerSaving':
          result.customerSaving = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'paymentId':
          result.paymentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
  final String userId;
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
  final String orderNUmber;
  @override
  final String supplierId;
  @override
  final String subTotal;
  @override
  final String supplierInvoiceNumber;
  @override
  final String deliverDate;
  @override
  final String taxRate;
  @override
  final String taxAmount;
  @override
  final String discountRate;
  @override
  final String discountAmount;
  @override
  final String cashReceived;
  @override
  final String saleTotal;
  @override
  final String customerSaving;
  @override
  final String paymentId;
  @override
  final String orderNote;
  @override
  final String status;
  @override
  final String customerChangeDue;

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
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Order', 'branchId');
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

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

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

  String _orderNUmber;
  String get orderNUmber => _$this._orderNUmber;
  set orderNUmber(String orderNUmber) => _$this._orderNUmber = orderNUmber;

  String _supplierId;
  String get supplierId => _$this._supplierId;
  set supplierId(String supplierId) => _$this._supplierId = supplierId;

  String _subTotal;
  String get subTotal => _$this._subTotal;
  set subTotal(String subTotal) => _$this._subTotal = subTotal;

  String _supplierInvoiceNumber;
  String get supplierInvoiceNumber => _$this._supplierInvoiceNumber;
  set supplierInvoiceNumber(String supplierInvoiceNumber) =>
      _$this._supplierInvoiceNumber = supplierInvoiceNumber;

  String _deliverDate;
  String get deliverDate => _$this._deliverDate;
  set deliverDate(String deliverDate) => _$this._deliverDate = deliverDate;

  String _taxRate;
  String get taxRate => _$this._taxRate;
  set taxRate(String taxRate) => _$this._taxRate = taxRate;

  String _taxAmount;
  String get taxAmount => _$this._taxAmount;
  set taxAmount(String taxAmount) => _$this._taxAmount = taxAmount;

  String _discountRate;
  String get discountRate => _$this._discountRate;
  set discountRate(String discountRate) => _$this._discountRate = discountRate;

  String _discountAmount;
  String get discountAmount => _$this._discountAmount;
  set discountAmount(String discountAmount) =>
      _$this._discountAmount = discountAmount;

  String _cashReceived;
  String get cashReceived => _$this._cashReceived;
  set cashReceived(String cashReceived) => _$this._cashReceived = cashReceived;

  String _saleTotal;
  String get saleTotal => _$this._saleTotal;
  set saleTotal(String saleTotal) => _$this._saleTotal = saleTotal;

  String _customerSaving;
  String get customerSaving => _$this._customerSaving;
  set customerSaving(String customerSaving) =>
      _$this._customerSaving = customerSaving;

  String _paymentId;
  String get paymentId => _$this._paymentId;
  set paymentId(String paymentId) => _$this._paymentId = paymentId;

  String _orderNote;
  String get orderNote => _$this._orderNote;
  set orderNote(String orderNote) => _$this._orderNote = orderNote;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  String _customerChangeDue;
  String get customerChangeDue => _$this._customerChangeDue;
  set customerChangeDue(String customerChangeDue) =>
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
