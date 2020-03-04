// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Order extends Order {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String branchId;
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
                                                                            $jc(
                                                                                0,
                                                                                id
                                                                                    .hashCode),
                                                                            userId
                                                                                .hashCode),
                                                                        branchId
                                                                            .hashCode),
                                                                    orderNUmber
                                                                        .hashCode),
                                                                supplierId
                                                                    .hashCode),
                                                            subTotal.hashCode),
                                                        supplierInvoiceNumber
                                                            .hashCode),
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

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

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
