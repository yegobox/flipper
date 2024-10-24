// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return _Receipt.fromJson(json);
}

/// @nodoc
mixin _$Receipt {
  int? get id => throw _privateConstructorUsedError; // Receipt identification
  int? get rcptNo => throw _privateConstructorUsedError;
  int? get totRcptNo => throw _privateConstructorUsedError;
  int? get invcNo => throw _privateConstructorUsedError;
  int? get invoiceNumber => throw _privateConstructorUsedError;
  String? get receiptType =>
      throw _privateConstructorUsedError; // Result information
  String? get resultCd => throw _privateConstructorUsedError;
  String? get resultMsg => throw _privateConstructorUsedError;
  String? get resultDt => throw _privateConstructorUsedError; // Technical data
  String? get intrlData => throw _privateConstructorUsedError;
  String? get rcptSign => throw _privateConstructorUsedError;
  String? get vsdcRcptPbctDate => throw _privateConstructorUsedError;
  String? get sdcId => throw _privateConstructorUsedError;
  String? get mrcNo => throw _privateConstructorUsedError;
  String? get qrCode => throw _privateConstructorUsedError; // Relationships
  int? get branchId => throw _privateConstructorUsedError;
  int? get transactionId => throw _privateConstructorUsedError; // Timestamps
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get whenCreated => throw _privateConstructorUsedError;

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptCopyWith<Receipt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptCopyWith<$Res> {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) then) =
      _$ReceiptCopyWithImpl<$Res, Receipt>;
  @useResult
  $Res call(
      {int? id,
      int? rcptNo,
      int? totRcptNo,
      int? invcNo,
      int? invoiceNumber,
      String? receiptType,
      String? resultCd,
      String? resultMsg,
      String? resultDt,
      String? intrlData,
      String? rcptSign,
      String? vsdcRcptPbctDate,
      String? sdcId,
      String? mrcNo,
      String? qrCode,
      int? branchId,
      int? transactionId,
      DateTime? lastTouched,
      DateTime? whenCreated});
}

/// @nodoc
class _$ReceiptCopyWithImpl<$Res, $Val extends Receipt>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? rcptNo = freezed,
    Object? totRcptNo = freezed,
    Object? invcNo = freezed,
    Object? invoiceNumber = freezed,
    Object? receiptType = freezed,
    Object? resultCd = freezed,
    Object? resultMsg = freezed,
    Object? resultDt = freezed,
    Object? intrlData = freezed,
    Object? rcptSign = freezed,
    Object? vsdcRcptPbctDate = freezed,
    Object? sdcId = freezed,
    Object? mrcNo = freezed,
    Object? qrCode = freezed,
    Object? branchId = freezed,
    Object? transactionId = freezed,
    Object? lastTouched = freezed,
    Object? whenCreated = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      rcptNo: freezed == rcptNo
          ? _value.rcptNo
          : rcptNo // ignore: cast_nullable_to_non_nullable
              as int?,
      totRcptNo: freezed == totRcptNo
          ? _value.totRcptNo
          : totRcptNo // ignore: cast_nullable_to_non_nullable
              as int?,
      invcNo: freezed == invcNo
          ? _value.invcNo
          : invcNo // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      receiptType: freezed == receiptType
          ? _value.receiptType
          : receiptType // ignore: cast_nullable_to_non_nullable
              as String?,
      resultCd: freezed == resultCd
          ? _value.resultCd
          : resultCd // ignore: cast_nullable_to_non_nullable
              as String?,
      resultMsg: freezed == resultMsg
          ? _value.resultMsg
          : resultMsg // ignore: cast_nullable_to_non_nullable
              as String?,
      resultDt: freezed == resultDt
          ? _value.resultDt
          : resultDt // ignore: cast_nullable_to_non_nullable
              as String?,
      intrlData: freezed == intrlData
          ? _value.intrlData
          : intrlData // ignore: cast_nullable_to_non_nullable
              as String?,
      rcptSign: freezed == rcptSign
          ? _value.rcptSign
          : rcptSign // ignore: cast_nullable_to_non_nullable
              as String?,
      vsdcRcptPbctDate: freezed == vsdcRcptPbctDate
          ? _value.vsdcRcptPbctDate
          : vsdcRcptPbctDate // ignore: cast_nullable_to_non_nullable
              as String?,
      sdcId: freezed == sdcId
          ? _value.sdcId
          : sdcId // ignore: cast_nullable_to_non_nullable
              as String?,
      mrcNo: freezed == mrcNo
          ? _value.mrcNo
          : mrcNo // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      whenCreated: freezed == whenCreated
          ? _value.whenCreated
          : whenCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiptImplCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$$ReceiptImplCopyWith(
          _$ReceiptImpl value, $Res Function(_$ReceiptImpl) then) =
      __$$ReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? rcptNo,
      int? totRcptNo,
      int? invcNo,
      int? invoiceNumber,
      String? receiptType,
      String? resultCd,
      String? resultMsg,
      String? resultDt,
      String? intrlData,
      String? rcptSign,
      String? vsdcRcptPbctDate,
      String? sdcId,
      String? mrcNo,
      String? qrCode,
      int? branchId,
      int? transactionId,
      DateTime? lastTouched,
      DateTime? whenCreated});
}

/// @nodoc
class __$$ReceiptImplCopyWithImpl<$Res>
    extends _$ReceiptCopyWithImpl<$Res, _$ReceiptImpl>
    implements _$$ReceiptImplCopyWith<$Res> {
  __$$ReceiptImplCopyWithImpl(
      _$ReceiptImpl _value, $Res Function(_$ReceiptImpl) _then)
      : super(_value, _then);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? rcptNo = freezed,
    Object? totRcptNo = freezed,
    Object? invcNo = freezed,
    Object? invoiceNumber = freezed,
    Object? receiptType = freezed,
    Object? resultCd = freezed,
    Object? resultMsg = freezed,
    Object? resultDt = freezed,
    Object? intrlData = freezed,
    Object? rcptSign = freezed,
    Object? vsdcRcptPbctDate = freezed,
    Object? sdcId = freezed,
    Object? mrcNo = freezed,
    Object? qrCode = freezed,
    Object? branchId = freezed,
    Object? transactionId = freezed,
    Object? lastTouched = freezed,
    Object? whenCreated = freezed,
  }) {
    return _then(_$ReceiptImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      rcptNo: freezed == rcptNo
          ? _value.rcptNo
          : rcptNo // ignore: cast_nullable_to_non_nullable
              as int?,
      totRcptNo: freezed == totRcptNo
          ? _value.totRcptNo
          : totRcptNo // ignore: cast_nullable_to_non_nullable
              as int?,
      invcNo: freezed == invcNo
          ? _value.invcNo
          : invcNo // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      receiptType: freezed == receiptType
          ? _value.receiptType
          : receiptType // ignore: cast_nullable_to_non_nullable
              as String?,
      resultCd: freezed == resultCd
          ? _value.resultCd
          : resultCd // ignore: cast_nullable_to_non_nullable
              as String?,
      resultMsg: freezed == resultMsg
          ? _value.resultMsg
          : resultMsg // ignore: cast_nullable_to_non_nullable
              as String?,
      resultDt: freezed == resultDt
          ? _value.resultDt
          : resultDt // ignore: cast_nullable_to_non_nullable
              as String?,
      intrlData: freezed == intrlData
          ? _value.intrlData
          : intrlData // ignore: cast_nullable_to_non_nullable
              as String?,
      rcptSign: freezed == rcptSign
          ? _value.rcptSign
          : rcptSign // ignore: cast_nullable_to_non_nullable
              as String?,
      vsdcRcptPbctDate: freezed == vsdcRcptPbctDate
          ? _value.vsdcRcptPbctDate
          : vsdcRcptPbctDate // ignore: cast_nullable_to_non_nullable
              as String?,
      sdcId: freezed == sdcId
          ? _value.sdcId
          : sdcId // ignore: cast_nullable_to_non_nullable
              as String?,
      mrcNo: freezed == mrcNo
          ? _value.mrcNo
          : mrcNo // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      whenCreated: freezed == whenCreated
          ? _value.whenCreated
          : whenCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptImpl extends _Receipt {
  const _$ReceiptImpl(
      {this.id,
      this.rcptNo,
      this.totRcptNo,
      this.invcNo,
      this.invoiceNumber,
      this.receiptType,
      this.resultCd,
      this.resultMsg,
      this.resultDt,
      this.intrlData,
      this.rcptSign,
      this.vsdcRcptPbctDate,
      this.sdcId,
      this.mrcNo,
      this.qrCode,
      this.branchId,
      this.transactionId,
      this.lastTouched,
      this.whenCreated})
      : super._();

  factory _$ReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptImplFromJson(json);

  @override
  final int? id;
// Receipt identification
  @override
  final int? rcptNo;
  @override
  final int? totRcptNo;
  @override
  final int? invcNo;
  @override
  final int? invoiceNumber;
  @override
  final String? receiptType;
// Result information
  @override
  final String? resultCd;
  @override
  final String? resultMsg;
  @override
  final String? resultDt;
// Technical data
  @override
  final String? intrlData;
  @override
  final String? rcptSign;
  @override
  final String? vsdcRcptPbctDate;
  @override
  final String? sdcId;
  @override
  final String? mrcNo;
  @override
  final String? qrCode;
// Relationships
  @override
  final int? branchId;
  @override
  final int? transactionId;
// Timestamps
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? whenCreated;

  @override
  String toString() {
    return 'Receipt(id: $id, rcptNo: $rcptNo, totRcptNo: $totRcptNo, invcNo: $invcNo, invoiceNumber: $invoiceNumber, receiptType: $receiptType, resultCd: $resultCd, resultMsg: $resultMsg, resultDt: $resultDt, intrlData: $intrlData, rcptSign: $rcptSign, vsdcRcptPbctDate: $vsdcRcptPbctDate, sdcId: $sdcId, mrcNo: $mrcNo, qrCode: $qrCode, branchId: $branchId, transactionId: $transactionId, lastTouched: $lastTouched, whenCreated: $whenCreated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rcptNo, rcptNo) || other.rcptNo == rcptNo) &&
            (identical(other.totRcptNo, totRcptNo) ||
                other.totRcptNo == totRcptNo) &&
            (identical(other.invcNo, invcNo) || other.invcNo == invcNo) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.receiptType, receiptType) ||
                other.receiptType == receiptType) &&
            (identical(other.resultCd, resultCd) ||
                other.resultCd == resultCd) &&
            (identical(other.resultMsg, resultMsg) ||
                other.resultMsg == resultMsg) &&
            (identical(other.resultDt, resultDt) ||
                other.resultDt == resultDt) &&
            (identical(other.intrlData, intrlData) ||
                other.intrlData == intrlData) &&
            (identical(other.rcptSign, rcptSign) ||
                other.rcptSign == rcptSign) &&
            (identical(other.vsdcRcptPbctDate, vsdcRcptPbctDate) ||
                other.vsdcRcptPbctDate == vsdcRcptPbctDate) &&
            (identical(other.sdcId, sdcId) || other.sdcId == sdcId) &&
            (identical(other.mrcNo, mrcNo) || other.mrcNo == mrcNo) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.whenCreated, whenCreated) ||
                other.whenCreated == whenCreated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        rcptNo,
        totRcptNo,
        invcNo,
        invoiceNumber,
        receiptType,
        resultCd,
        resultMsg,
        resultDt,
        intrlData,
        rcptSign,
        vsdcRcptPbctDate,
        sdcId,
        mrcNo,
        qrCode,
        branchId,
        transactionId,
        lastTouched,
        whenCreated
      ]);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      __$$ReceiptImplCopyWithImpl<_$ReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptImplToJson(
      this,
    );
  }
}

abstract class _Receipt extends Receipt {
  const factory _Receipt(
      {final int? id,
      final int? rcptNo,
      final int? totRcptNo,
      final int? invcNo,
      final int? invoiceNumber,
      final String? receiptType,
      final String? resultCd,
      final String? resultMsg,
      final String? resultDt,
      final String? intrlData,
      final String? rcptSign,
      final String? vsdcRcptPbctDate,
      final String? sdcId,
      final String? mrcNo,
      final String? qrCode,
      final int? branchId,
      final int? transactionId,
      final DateTime? lastTouched,
      final DateTime? whenCreated}) = _$ReceiptImpl;
  const _Receipt._() : super._();

  factory _Receipt.fromJson(Map<String, dynamic> json) = _$ReceiptImpl.fromJson;

  @override
  int? get id; // Receipt identification
  @override
  int? get rcptNo;
  @override
  int? get totRcptNo;
  @override
  int? get invcNo;
  @override
  int? get invoiceNumber;
  @override
  String? get receiptType; // Result information
  @override
  String? get resultCd;
  @override
  String? get resultMsg;
  @override
  String? get resultDt; // Technical data
  @override
  String? get intrlData;
  @override
  String? get rcptSign;
  @override
  String? get vsdcRcptPbctDate;
  @override
  String? get sdcId;
  @override
  String? get mrcNo;
  @override
  String? get qrCode; // Relationships
  @override
  int? get branchId;
  @override
  int? get transactionId; // Timestamps
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get whenCreated;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
