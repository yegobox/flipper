// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int? get id => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get transactionNumber => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get transactionType => throw _privateConstructorUsedError;
  double get subTotal => throw _privateConstructorUsedError;
  String? get paymentType => throw _privateConstructorUsedError;
  double get cashReceived => throw _privateConstructorUsedError;
  double get customerChangeDue => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get receiptType => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  int? get customerId => throw _privateConstructorUsedError;
  String? get customerType => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  String? get ticketName => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int? get supplierId => throw _privateConstructorUsedError;
  bool get ebmSynced => throw _privateConstructorUsedError;
  bool get isIncome => throw _privateConstructorUsedError;
  bool get isExpense => throw _privateConstructorUsedError;
  bool get isRefunded => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerTin => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get customerBhfId => throw _privateConstructorUsedError;
  String? get sarTyCd => throw _privateConstructorUsedError;
  int? get receiptNumber => throw _privateConstructorUsedError;
  int? get totalReceiptNumber => throw _privateConstructorUsedError;
  int? get invoiceNumber => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {int? id,
      String? reference,
      String? categoryId,
      String? transactionNumber,
      int? branchId,
      String? status,
      String? transactionType,
      double subTotal,
      String? paymentType,
      double cashReceived,
      double customerChangeDue,
      String? createdAt,
      String? receiptType,
      String? updatedAt,
      int? customerId,
      String? customerType,
      String? note,
      DateTime? lastTouched,
      String? ticketName,
      DateTime? deletedAt,
      int? supplierId,
      bool ebmSynced,
      bool isIncome,
      bool isExpense,
      bool isRefunded,
      String? customerName,
      String? customerTin,
      String? remark,
      String? customerBhfId,
      String? sarTyCd,
      int? receiptNumber,
      int? totalReceiptNumber,
      int? invoiceNumber});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? reference = freezed,
    Object? categoryId = freezed,
    Object? transactionNumber = freezed,
    Object? branchId = freezed,
    Object? status = freezed,
    Object? transactionType = freezed,
    Object? subTotal = null,
    Object? paymentType = freezed,
    Object? cashReceived = null,
    Object? customerChangeDue = null,
    Object? createdAt = freezed,
    Object? receiptType = freezed,
    Object? updatedAt = freezed,
    Object? customerId = freezed,
    Object? customerType = freezed,
    Object? note = freezed,
    Object? lastTouched = freezed,
    Object? ticketName = freezed,
    Object? deletedAt = freezed,
    Object? supplierId = freezed,
    Object? ebmSynced = null,
    Object? isIncome = null,
    Object? isExpense = null,
    Object? isRefunded = null,
    Object? customerName = freezed,
    Object? customerTin = freezed,
    Object? remark = freezed,
    Object? customerBhfId = freezed,
    Object? sarTyCd = freezed,
    Object? receiptNumber = freezed,
    Object? totalReceiptNumber = freezed,
    Object? invoiceNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionNumber: freezed == transactionNumber
          ? _value.transactionNumber
          : transactionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: freezed == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String?,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: freezed == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String?,
      cashReceived: null == cashReceived
          ? _value.cashReceived
          : cashReceived // ignore: cast_nullable_to_non_nullable
              as double,
      customerChangeDue: null == customerChangeDue
          ? _value.customerChangeDue
          : customerChangeDue // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptType: freezed == receiptType
          ? _value.receiptType
          : receiptType // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerType: freezed == customerType
          ? _value.customerType
          : customerType // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ticketName: freezed == ticketName
          ? _value.ticketName
          : ticketName // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      isExpense: null == isExpense
          ? _value.isExpense
          : isExpense // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefunded: null == isRefunded
          ? _value.isRefunded
          : isRefunded // ignore: cast_nullable_to_non_nullable
              as bool,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerTin: freezed == customerTin
          ? _value.customerTin
          : customerTin // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      customerBhfId: freezed == customerBhfId
          ? _value.customerBhfId
          : customerBhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      sarTyCd: freezed == sarTyCd
          ? _value.sarTyCd
          : sarTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptNumber: freezed == receiptNumber
          ? _value.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      totalReceiptNumber: freezed == totalReceiptNumber
          ? _value.totalReceiptNumber
          : totalReceiptNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? reference,
      String? categoryId,
      String? transactionNumber,
      int? branchId,
      String? status,
      String? transactionType,
      double subTotal,
      String? paymentType,
      double cashReceived,
      double customerChangeDue,
      String? createdAt,
      String? receiptType,
      String? updatedAt,
      int? customerId,
      String? customerType,
      String? note,
      DateTime? lastTouched,
      String? ticketName,
      DateTime? deletedAt,
      int? supplierId,
      bool ebmSynced,
      bool isIncome,
      bool isExpense,
      bool isRefunded,
      String? customerName,
      String? customerTin,
      String? remark,
      String? customerBhfId,
      String? sarTyCd,
      int? receiptNumber,
      int? totalReceiptNumber,
      int? invoiceNumber});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? reference = freezed,
    Object? categoryId = freezed,
    Object? transactionNumber = freezed,
    Object? branchId = freezed,
    Object? status = freezed,
    Object? transactionType = freezed,
    Object? subTotal = null,
    Object? paymentType = freezed,
    Object? cashReceived = null,
    Object? customerChangeDue = null,
    Object? createdAt = freezed,
    Object? receiptType = freezed,
    Object? updatedAt = freezed,
    Object? customerId = freezed,
    Object? customerType = freezed,
    Object? note = freezed,
    Object? lastTouched = freezed,
    Object? ticketName = freezed,
    Object? deletedAt = freezed,
    Object? supplierId = freezed,
    Object? ebmSynced = null,
    Object? isIncome = null,
    Object? isExpense = null,
    Object? isRefunded = null,
    Object? customerName = freezed,
    Object? customerTin = freezed,
    Object? remark = freezed,
    Object? customerBhfId = freezed,
    Object? sarTyCd = freezed,
    Object? receiptNumber = freezed,
    Object? totalReceiptNumber = freezed,
    Object? invoiceNumber = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionNumber: freezed == transactionNumber
          ? _value.transactionNumber
          : transactionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: freezed == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String?,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: freezed == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String?,
      cashReceived: null == cashReceived
          ? _value.cashReceived
          : cashReceived // ignore: cast_nullable_to_non_nullable
              as double,
      customerChangeDue: null == customerChangeDue
          ? _value.customerChangeDue
          : customerChangeDue // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptType: freezed == receiptType
          ? _value.receiptType
          : receiptType // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerType: freezed == customerType
          ? _value.customerType
          : customerType // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ticketName: freezed == ticketName
          ? _value.ticketName
          : ticketName // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncome: null == isIncome
          ? _value.isIncome
          : isIncome // ignore: cast_nullable_to_non_nullable
              as bool,
      isExpense: null == isExpense
          ? _value.isExpense
          : isExpense // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefunded: null == isRefunded
          ? _value.isRefunded
          : isRefunded // ignore: cast_nullable_to_non_nullable
              as bool,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerTin: freezed == customerTin
          ? _value.customerTin
          : customerTin // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      customerBhfId: freezed == customerBhfId
          ? _value.customerBhfId
          : customerBhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      sarTyCd: freezed == sarTyCd
          ? _value.sarTyCd
          : sarTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptNumber: freezed == receiptNumber
          ? _value.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      totalReceiptNumber: freezed == totalReceiptNumber
          ? _value.totalReceiptNumber
          : totalReceiptNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {this.id,
      this.reference,
      this.categoryId,
      this.transactionNumber,
      this.branchId = null,
      this.status = null,
      this.transactionType = null,
      this.subTotal = 0.0,
      this.paymentType,
      this.cashReceived = 0.0,
      this.customerChangeDue = 0.0,
      this.createdAt = null,
      this.receiptType,
      this.updatedAt,
      this.customerId = null,
      this.customerType,
      this.note,
      this.lastTouched,
      this.ticketName,
      this.deletedAt,
      this.supplierId,
      this.ebmSynced = false,
      this.isIncome = false,
      this.isExpense = false,
      this.isRefunded = false,
      this.customerName,
      this.customerTin,
      this.remark,
      this.customerBhfId,
      this.sarTyCd,
      this.receiptNumber,
      this.totalReceiptNumber,
      this.invoiceNumber});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int? id;
  @override
  final String? reference;
  @override
  final String? categoryId;
  @override
  final String? transactionNumber;
  @override
  @JsonKey()
  final int? branchId;
  @override
  @JsonKey()
  final String? status;
  @override
  @JsonKey()
  final String? transactionType;
  @override
  @JsonKey()
  final double subTotal;
  @override
  final String? paymentType;
  @override
  @JsonKey()
  final double cashReceived;
  @override
  @JsonKey()
  final double customerChangeDue;
  @override
  @JsonKey()
  final String? createdAt;
  @override
  final String? receiptType;
  @override
  final String? updatedAt;
  @override
  @JsonKey()
  final int? customerId;
  @override
  final String? customerType;
  @override
  final String? note;
  @override
  final DateTime? lastTouched;
  @override
  final String? ticketName;
  @override
  final DateTime? deletedAt;
  @override
  final int? supplierId;
  @override
  @JsonKey()
  final bool ebmSynced;
  @override
  @JsonKey()
  final bool isIncome;
  @override
  @JsonKey()
  final bool isExpense;
  @override
  @JsonKey()
  final bool isRefunded;
  @override
  final String? customerName;
  @override
  final String? customerTin;
  @override
  final String? remark;
  @override
  final String? customerBhfId;
  @override
  final String? sarTyCd;
  @override
  final int? receiptNumber;
  @override
  final int? totalReceiptNumber;
  @override
  final int? invoiceNumber;

  @override
  String toString() {
    return 'Transaction(id: $id, reference: $reference, categoryId: $categoryId, transactionNumber: $transactionNumber, branchId: $branchId, status: $status, transactionType: $transactionType, subTotal: $subTotal, paymentType: $paymentType, cashReceived: $cashReceived, customerChangeDue: $customerChangeDue, createdAt: $createdAt, receiptType: $receiptType, updatedAt: $updatedAt, customerId: $customerId, customerType: $customerType, note: $note, lastTouched: $lastTouched, ticketName: $ticketName, deletedAt: $deletedAt, supplierId: $supplierId, ebmSynced: $ebmSynced, isIncome: $isIncome, isExpense: $isExpense, isRefunded: $isRefunded, customerName: $customerName, customerTin: $customerTin, remark: $remark, customerBhfId: $customerBhfId, sarTyCd: $sarTyCd, receiptNumber: $receiptNumber, totalReceiptNumber: $totalReceiptNumber, invoiceNumber: $invoiceNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.transactionNumber, transactionNumber) ||
                other.transactionNumber == transactionNumber) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.cashReceived, cashReceived) ||
                other.cashReceived == cashReceived) &&
            (identical(other.customerChangeDue, customerChangeDue) ||
                other.customerChangeDue == customerChangeDue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.receiptType, receiptType) ||
                other.receiptType == receiptType) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerType, customerType) ||
                other.customerType == customerType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.ticketName, ticketName) ||
                other.ticketName == ticketName) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.ebmSynced, ebmSynced) ||
                other.ebmSynced == ebmSynced) &&
            (identical(other.isIncome, isIncome) ||
                other.isIncome == isIncome) &&
            (identical(other.isExpense, isExpense) ||
                other.isExpense == isExpense) &&
            (identical(other.isRefunded, isRefunded) ||
                other.isRefunded == isRefunded) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerTin, customerTin) ||
                other.customerTin == customerTin) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.customerBhfId, customerBhfId) ||
                other.customerBhfId == customerBhfId) &&
            (identical(other.sarTyCd, sarTyCd) || other.sarTyCd == sarTyCd) &&
            (identical(other.receiptNumber, receiptNumber) ||
                other.receiptNumber == receiptNumber) &&
            (identical(other.totalReceiptNumber, totalReceiptNumber) ||
                other.totalReceiptNumber == totalReceiptNumber) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        reference,
        categoryId,
        transactionNumber,
        branchId,
        status,
        transactionType,
        subTotal,
        paymentType,
        cashReceived,
        customerChangeDue,
        createdAt,
        receiptType,
        updatedAt,
        customerId,
        customerType,
        note,
        lastTouched,
        ticketName,
        deletedAt,
        supplierId,
        ebmSynced,
        isIncome,
        isExpense,
        isRefunded,
        customerName,
        customerTin,
        remark,
        customerBhfId,
        sarTyCd,
        receiptNumber,
        totalReceiptNumber,
        invoiceNumber
      ]);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {final int? id,
      final String? reference,
      final String? categoryId,
      final String? transactionNumber,
      final int? branchId,
      final String? status,
      final String? transactionType,
      final double subTotal,
      final String? paymentType,
      final double cashReceived,
      final double customerChangeDue,
      final String? createdAt,
      final String? receiptType,
      final String? updatedAt,
      final int? customerId,
      final String? customerType,
      final String? note,
      final DateTime? lastTouched,
      final String? ticketName,
      final DateTime? deletedAt,
      final int? supplierId,
      final bool ebmSynced,
      final bool isIncome,
      final bool isExpense,
      final bool isRefunded,
      final String? customerName,
      final String? customerTin,
      final String? remark,
      final String? customerBhfId,
      final String? sarTyCd,
      final int? receiptNumber,
      final int? totalReceiptNumber,
      final int? invoiceNumber}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int? get id;
  @override
  String? get reference;
  @override
  String? get categoryId;
  @override
  String? get transactionNumber;
  @override
  int? get branchId;
  @override
  String? get status;
  @override
  String? get transactionType;
  @override
  double get subTotal;
  @override
  String? get paymentType;
  @override
  double get cashReceived;
  @override
  double get customerChangeDue;
  @override
  String? get createdAt;
  @override
  String? get receiptType;
  @override
  String? get updatedAt;
  @override
  int? get customerId;
  @override
  String? get customerType;
  @override
  String? get note;
  @override
  DateTime? get lastTouched;
  @override
  String? get ticketName;
  @override
  DateTime? get deletedAt;
  @override
  int? get supplierId;
  @override
  bool get ebmSynced;
  @override
  bool get isIncome;
  @override
  bool get isExpense;
  @override
  bool get isRefunded;
  @override
  String? get customerName;
  @override
  String? get customerTin;
  @override
  String? get remark;
  @override
  String? get customerBhfId;
  @override
  String? get sarTyCd;
  @override
  int? get receiptNumber;
  @override
  int? get totalReceiptNumber;
  @override
  int? get invoiceNumber;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
