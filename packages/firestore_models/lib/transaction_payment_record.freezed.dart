// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_payment_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionPaymentRecord _$TransactionPaymentRecordFromJson(
    Map<String, dynamic> json) {
  return _TransactionPaymentRecord.fromJson(json);
}

/// @nodoc
mixin _$TransactionPaymentRecord {
  int? get id => throw _privateConstructorUsedError;
  int? get transactionId => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionPaymentRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionPaymentRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionPaymentRecordCopyWith<TransactionPaymentRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionPaymentRecordCopyWith<$Res> {
  factory $TransactionPaymentRecordCopyWith(TransactionPaymentRecord value,
          $Res Function(TransactionPaymentRecord) then) =
      _$TransactionPaymentRecordCopyWithImpl<$Res, TransactionPaymentRecord>;
  @useResult
  $Res call(
      {int? id,
      int? transactionId,
      double? amount,
      String? paymentMethod,
      DateTime? createdAt});
}

/// @nodoc
class _$TransactionPaymentRecordCopyWithImpl<$Res,
        $Val extends TransactionPaymentRecord>
    implements $TransactionPaymentRecordCopyWith<$Res> {
  _$TransactionPaymentRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionPaymentRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transactionId = freezed,
    Object? amount = freezed,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionPaymentRecordImplCopyWith<$Res>
    implements $TransactionPaymentRecordCopyWith<$Res> {
  factory _$$TransactionPaymentRecordImplCopyWith(
          _$TransactionPaymentRecordImpl value,
          $Res Function(_$TransactionPaymentRecordImpl) then) =
      __$$TransactionPaymentRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? transactionId,
      double? amount,
      String? paymentMethod,
      DateTime? createdAt});
}

/// @nodoc
class __$$TransactionPaymentRecordImplCopyWithImpl<$Res>
    extends _$TransactionPaymentRecordCopyWithImpl<$Res,
        _$TransactionPaymentRecordImpl>
    implements _$$TransactionPaymentRecordImplCopyWith<$Res> {
  __$$TransactionPaymentRecordImplCopyWithImpl(
      _$TransactionPaymentRecordImpl _value,
      $Res Function(_$TransactionPaymentRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionPaymentRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transactionId = freezed,
    Object? amount = freezed,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TransactionPaymentRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionPaymentRecordImpl implements _TransactionPaymentRecord {
  _$TransactionPaymentRecordImpl(
      {this.id,
      this.transactionId,
      this.amount = 0.0,
      this.paymentMethod,
      this.createdAt});

  factory _$TransactionPaymentRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionPaymentRecordImplFromJson(json);

  @override
  final int? id;
  @override
  final int? transactionId;
  @override
  @JsonKey()
  final double? amount;
  @override
  final String? paymentMethod;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TransactionPaymentRecord(id: $id, transactionId: $transactionId, amount: $amount, paymentMethod: $paymentMethod, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionPaymentRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, transactionId, amount, paymentMethod, createdAt);

  /// Create a copy of TransactionPaymentRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionPaymentRecordImplCopyWith<_$TransactionPaymentRecordImpl>
      get copyWith => __$$TransactionPaymentRecordImplCopyWithImpl<
          _$TransactionPaymentRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionPaymentRecordImplToJson(
      this,
    );
  }
}

abstract class _TransactionPaymentRecord implements TransactionPaymentRecord {
  factory _TransactionPaymentRecord(
      {final int? id,
      final int? transactionId,
      final double? amount,
      final String? paymentMethod,
      final DateTime? createdAt}) = _$TransactionPaymentRecordImpl;

  factory _TransactionPaymentRecord.fromJson(Map<String, dynamic> json) =
      _$TransactionPaymentRecordImpl.fromJson;

  @override
  int? get id;
  @override
  int? get transactionId;
  @override
  double? get amount;
  @override
  String? get paymentMethod;
  @override
  DateTime? get createdAt;

  /// Create a copy of TransactionPaymentRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionPaymentRecordImplCopyWith<_$TransactionPaymentRecordImpl>
      get copyWith => throw _privateConstructorUsedError;
}
