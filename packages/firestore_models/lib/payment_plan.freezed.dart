// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentPlan _$PaymentPlanFromJson(Map<String, dynamic> json) {
  return _PaymentPlan.fromJson(json);
}

/// @nodoc
mixin _$PaymentPlan {
  int? get id => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  String? get selectedPlan => throw _privateConstructorUsedError;
  int? get additionalDevices => throw _privateConstructorUsedError;
  bool? get isYearlyPlan => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  bool? get paymentCompletedByUser => throw _privateConstructorUsedError;
  int? get payStackCustomerId => throw _privateConstructorUsedError;
  String? get rule => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get customerCode => throw _privateConstructorUsedError;
  String? get payStackPlanId => throw _privateConstructorUsedError;

  /// Serializes this PaymentPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentPlanCopyWith<PaymentPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentPlanCopyWith<$Res> {
  factory $PaymentPlanCopyWith(
          PaymentPlan value, $Res Function(PaymentPlan) then) =
      _$PaymentPlanCopyWithImpl<$Res, PaymentPlan>;
  @useResult
  $Res call(
      {int? id,
      int? businessId,
      String? selectedPlan,
      int? additionalDevices,
      bool? isYearlyPlan,
      double? totalPrice,
      DateTime? createdAt,
      bool? paymentCompletedByUser,
      int? payStackCustomerId,
      String? rule,
      String? paymentMethod,
      String? customerCode,
      String? payStackPlanId});
}

/// @nodoc
class _$PaymentPlanCopyWithImpl<$Res, $Val extends PaymentPlan>
    implements $PaymentPlanCopyWith<$Res> {
  _$PaymentPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? businessId = freezed,
    Object? selectedPlan = freezed,
    Object? additionalDevices = freezed,
    Object? isYearlyPlan = freezed,
    Object? totalPrice = freezed,
    Object? createdAt = freezed,
    Object? paymentCompletedByUser = freezed,
    Object? payStackCustomerId = freezed,
    Object? rule = freezed,
    Object? paymentMethod = freezed,
    Object? customerCode = freezed,
    Object? payStackPlanId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedPlan: freezed == selectedPlan
          ? _value.selectedPlan
          : selectedPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalDevices: freezed == additionalDevices
          ? _value.additionalDevices
          : additionalDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      isYearlyPlan: freezed == isYearlyPlan
          ? _value.isYearlyPlan
          : isYearlyPlan // ignore: cast_nullable_to_non_nullable
              as bool?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentCompletedByUser: freezed == paymentCompletedByUser
          ? _value.paymentCompletedByUser
          : paymentCompletedByUser // ignore: cast_nullable_to_non_nullable
              as bool?,
      payStackCustomerId: freezed == payStackCustomerId
          ? _value.payStackCustomerId
          : payStackCustomerId // ignore: cast_nullable_to_non_nullable
              as int?,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCode: freezed == customerCode
          ? _value.customerCode
          : customerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      payStackPlanId: freezed == payStackPlanId
          ? _value.payStackPlanId
          : payStackPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentPlanImplCopyWith<$Res>
    implements $PaymentPlanCopyWith<$Res> {
  factory _$$PaymentPlanImplCopyWith(
          _$PaymentPlanImpl value, $Res Function(_$PaymentPlanImpl) then) =
      __$$PaymentPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? businessId,
      String? selectedPlan,
      int? additionalDevices,
      bool? isYearlyPlan,
      double? totalPrice,
      DateTime? createdAt,
      bool? paymentCompletedByUser,
      int? payStackCustomerId,
      String? rule,
      String? paymentMethod,
      String? customerCode,
      String? payStackPlanId});
}

/// @nodoc
class __$$PaymentPlanImplCopyWithImpl<$Res>
    extends _$PaymentPlanCopyWithImpl<$Res, _$PaymentPlanImpl>
    implements _$$PaymentPlanImplCopyWith<$Res> {
  __$$PaymentPlanImplCopyWithImpl(
      _$PaymentPlanImpl _value, $Res Function(_$PaymentPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? businessId = freezed,
    Object? selectedPlan = freezed,
    Object? additionalDevices = freezed,
    Object? isYearlyPlan = freezed,
    Object? totalPrice = freezed,
    Object? createdAt = freezed,
    Object? paymentCompletedByUser = freezed,
    Object? payStackCustomerId = freezed,
    Object? rule = freezed,
    Object? paymentMethod = freezed,
    Object? customerCode = freezed,
    Object? payStackPlanId = freezed,
  }) {
    return _then(_$PaymentPlanImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedPlan: freezed == selectedPlan
          ? _value.selectedPlan
          : selectedPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalDevices: freezed == additionalDevices
          ? _value.additionalDevices
          : additionalDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      isYearlyPlan: freezed == isYearlyPlan
          ? _value.isYearlyPlan
          : isYearlyPlan // ignore: cast_nullable_to_non_nullable
              as bool?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentCompletedByUser: freezed == paymentCompletedByUser
          ? _value.paymentCompletedByUser
          : paymentCompletedByUser // ignore: cast_nullable_to_non_nullable
              as bool?,
      payStackCustomerId: freezed == payStackCustomerId
          ? _value.payStackCustomerId
          : payStackCustomerId // ignore: cast_nullable_to_non_nullable
              as int?,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCode: freezed == customerCode
          ? _value.customerCode
          : customerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      payStackPlanId: freezed == payStackPlanId
          ? _value.payStackPlanId
          : payStackPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentPlanImpl implements _PaymentPlan {
  const _$PaymentPlanImpl(
      {this.id,
      this.businessId,
      this.selectedPlan,
      this.additionalDevices,
      this.isYearlyPlan,
      this.totalPrice,
      this.createdAt,
      this.paymentCompletedByUser = false,
      this.payStackCustomerId,
      this.rule,
      this.paymentMethod,
      this.customerCode,
      this.payStackPlanId});

  factory _$PaymentPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentPlanImplFromJson(json);

  @override
  final int? id;
  @override
  final int? businessId;
  @override
  final String? selectedPlan;
  @override
  final int? additionalDevices;
  @override
  final bool? isYearlyPlan;
  @override
  final double? totalPrice;
  @override
  final DateTime? createdAt;
  @override
  @JsonKey()
  final bool? paymentCompletedByUser;
  @override
  final int? payStackCustomerId;
  @override
  final String? rule;
  @override
  final String? paymentMethod;
  @override
  final String? customerCode;
  @override
  final String? payStackPlanId;

  @override
  String toString() {
    return 'PaymentPlan(id: $id, businessId: $businessId, selectedPlan: $selectedPlan, additionalDevices: $additionalDevices, isYearlyPlan: $isYearlyPlan, totalPrice: $totalPrice, createdAt: $createdAt, paymentCompletedByUser: $paymentCompletedByUser, payStackCustomerId: $payStackCustomerId, rule: $rule, paymentMethod: $paymentMethod, customerCode: $customerCode, payStackPlanId: $payStackPlanId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.selectedPlan, selectedPlan) ||
                other.selectedPlan == selectedPlan) &&
            (identical(other.additionalDevices, additionalDevices) ||
                other.additionalDevices == additionalDevices) &&
            (identical(other.isYearlyPlan, isYearlyPlan) ||
                other.isYearlyPlan == isYearlyPlan) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.paymentCompletedByUser, paymentCompletedByUser) ||
                other.paymentCompletedByUser == paymentCompletedByUser) &&
            (identical(other.payStackCustomerId, payStackCustomerId) ||
                other.payStackCustomerId == payStackCustomerId) &&
            (identical(other.rule, rule) || other.rule == rule) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.payStackPlanId, payStackPlanId) ||
                other.payStackPlanId == payStackPlanId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      businessId,
      selectedPlan,
      additionalDevices,
      isYearlyPlan,
      totalPrice,
      createdAt,
      paymentCompletedByUser,
      payStackCustomerId,
      rule,
      paymentMethod,
      customerCode,
      payStackPlanId);

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      __$$PaymentPlanImplCopyWithImpl<_$PaymentPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentPlanImplToJson(
      this,
    );
  }
}

abstract class _PaymentPlan implements PaymentPlan {
  const factory _PaymentPlan(
      {final int? id,
      final int? businessId,
      final String? selectedPlan,
      final int? additionalDevices,
      final bool? isYearlyPlan,
      final double? totalPrice,
      final DateTime? createdAt,
      final bool? paymentCompletedByUser,
      final int? payStackCustomerId,
      final String? rule,
      final String? paymentMethod,
      final String? customerCode,
      final String? payStackPlanId}) = _$PaymentPlanImpl;

  factory _PaymentPlan.fromJson(Map<String, dynamic> json) =
      _$PaymentPlanImpl.fromJson;

  @override
  int? get id;
  @override
  int? get businessId;
  @override
  String? get selectedPlan;
  @override
  int? get additionalDevices;
  @override
  bool? get isYearlyPlan;
  @override
  double? get totalPrice;
  @override
  DateTime? get createdAt;
  @override
  bool? get paymentCompletedByUser;
  @override
  int? get payStackCustomerId;
  @override
  String? get rule;
  @override
  String? get paymentMethod;
  @override
  String? get customerCode;
  @override
  String? get payStackPlanId;

  /// Create a copy of PaymentPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPlanImplCopyWith<_$PaymentPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
