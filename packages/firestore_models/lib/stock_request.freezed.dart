// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) {
  return _StockRequest.fromJson(json);
}

/// @nodoc
mixin _$StockRequest {
  int? get id => throw _privateConstructorUsedError;
  int? get mainBranchId => throw _privateConstructorUsedError;
  int? get subBranchId => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  String? get status => throw _privateConstructorUsedError;
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  String? get deliveryNote => throw _privateConstructorUsedError;
  String? get orderNote => throw _privateConstructorUsedError;
  bool? get customerReceivedOrder => throw _privateConstructorUsedError;
  bool? get driverRequestDeliveryConfirmation =>
      throw _privateConstructorUsedError;
  int? get driverId => throw _privateConstructorUsedError;
  List<TransactionItem> get items => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StockRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockRequestCopyWith<StockRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockRequestCopyWith<$Res> {
  factory $StockRequestCopyWith(
          StockRequest value, $Res Function(StockRequest) then) =
      _$StockRequestCopyWithImpl<$Res, StockRequest>;
  @useResult
  $Res call(
      {int? id,
      int? mainBranchId,
      int? subBranchId,
      DateTime? createdAt,
      String? status,
      DateTime? deliveryDate,
      String? deliveryNote,
      String? orderNote,
      bool? customerReceivedOrder,
      bool? driverRequestDeliveryConfirmation,
      int? driverId,
      List<TransactionItem> items,
      DateTime? updatedAt});
}

/// @nodoc
class _$StockRequestCopyWithImpl<$Res, $Val extends StockRequest>
    implements $StockRequestCopyWith<$Res> {
  _$StockRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mainBranchId = freezed,
    Object? subBranchId = freezed,
    Object? createdAt = freezed,
    Object? status = freezed,
    Object? deliveryDate = freezed,
    Object? deliveryNote = freezed,
    Object? orderNote = freezed,
    Object? customerReceivedOrder = freezed,
    Object? driverRequestDeliveryConfirmation = freezed,
    Object? driverId = freezed,
    Object? items = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mainBranchId: freezed == mainBranchId
          ? _value.mainBranchId
          : mainBranchId // ignore: cast_nullable_to_non_nullable
              as int?,
      subBranchId: freezed == subBranchId
          ? _value.subBranchId
          : subBranchId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryNote: freezed == deliveryNote
          ? _value.deliveryNote
          : deliveryNote // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNote: freezed == orderNote
          ? _value.orderNote
          : orderNote // ignore: cast_nullable_to_non_nullable
              as String?,
      customerReceivedOrder: freezed == customerReceivedOrder
          ? _value.customerReceivedOrder
          : customerReceivedOrder // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverRequestDeliveryConfirmation: freezed ==
              driverRequestDeliveryConfirmation
          ? _value.driverRequestDeliveryConfirmation
          : driverRequestDeliveryConfirmation // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransactionItem>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockRequestImplCopyWith<$Res>
    implements $StockRequestCopyWith<$Res> {
  factory _$$StockRequestImplCopyWith(
          _$StockRequestImpl value, $Res Function(_$StockRequestImpl) then) =
      __$$StockRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? mainBranchId,
      int? subBranchId,
      DateTime? createdAt,
      String? status,
      DateTime? deliveryDate,
      String? deliveryNote,
      String? orderNote,
      bool? customerReceivedOrder,
      bool? driverRequestDeliveryConfirmation,
      int? driverId,
      List<TransactionItem> items,
      DateTime? updatedAt});
}

/// @nodoc
class __$$StockRequestImplCopyWithImpl<$Res>
    extends _$StockRequestCopyWithImpl<$Res, _$StockRequestImpl>
    implements _$$StockRequestImplCopyWith<$Res> {
  __$$StockRequestImplCopyWithImpl(
      _$StockRequestImpl _value, $Res Function(_$StockRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mainBranchId = freezed,
    Object? subBranchId = freezed,
    Object? createdAt = freezed,
    Object? status = freezed,
    Object? deliveryDate = freezed,
    Object? deliveryNote = freezed,
    Object? orderNote = freezed,
    Object? customerReceivedOrder = freezed,
    Object? driverRequestDeliveryConfirmation = freezed,
    Object? driverId = freezed,
    Object? items = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StockRequestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mainBranchId: freezed == mainBranchId
          ? _value.mainBranchId
          : mainBranchId // ignore: cast_nullable_to_non_nullable
              as int?,
      subBranchId: freezed == subBranchId
          ? _value.subBranchId
          : subBranchId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryNote: freezed == deliveryNote
          ? _value.deliveryNote
          : deliveryNote // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNote: freezed == orderNote
          ? _value.orderNote
          : orderNote // ignore: cast_nullable_to_non_nullable
              as String?,
      customerReceivedOrder: freezed == customerReceivedOrder
          ? _value.customerReceivedOrder
          : customerReceivedOrder // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverRequestDeliveryConfirmation: freezed ==
              driverRequestDeliveryConfirmation
          ? _value.driverRequestDeliveryConfirmation
          : driverRequestDeliveryConfirmation // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransactionItem>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockRequestImpl implements _StockRequest {
  const _$StockRequestImpl(
      {this.id,
      this.mainBranchId,
      this.subBranchId,
      this.createdAt,
      this.status,
      this.deliveryDate,
      this.deliveryNote,
      this.orderNote,
      this.customerReceivedOrder = false,
      this.driverRequestDeliveryConfirmation = false,
      this.driverId,
      final List<TransactionItem> items = const [],
      this.updatedAt})
      : _items = items;

  factory _$StockRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockRequestImplFromJson(json);

  @override
  final int? id;
  @override
  final int? mainBranchId;
  @override
  final int? subBranchId;
  @override
  final DateTime? createdAt;
// e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  @override
  final String? status;
  @override
  final DateTime? deliveryDate;
  @override
  final String? deliveryNote;
  @override
  final String? orderNote;
  @override
  @JsonKey()
  final bool? customerReceivedOrder;
  @override
  @JsonKey()
  final bool? driverRequestDeliveryConfirmation;
  @override
  final int? driverId;
  final List<TransactionItem> _items;
  @override
  @JsonKey()
  List<TransactionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StockRequest(id: $id, mainBranchId: $mainBranchId, subBranchId: $subBranchId, createdAt: $createdAt, status: $status, deliveryDate: $deliveryDate, deliveryNote: $deliveryNote, orderNote: $orderNote, customerReceivedOrder: $customerReceivedOrder, driverRequestDeliveryConfirmation: $driverRequestDeliveryConfirmation, driverId: $driverId, items: $items, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mainBranchId, mainBranchId) ||
                other.mainBranchId == mainBranchId) &&
            (identical(other.subBranchId, subBranchId) ||
                other.subBranchId == subBranchId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.deliveryNote, deliveryNote) ||
                other.deliveryNote == deliveryNote) &&
            (identical(other.orderNote, orderNote) ||
                other.orderNote == orderNote) &&
            (identical(other.customerReceivedOrder, customerReceivedOrder) ||
                other.customerReceivedOrder == customerReceivedOrder) &&
            (identical(other.driverRequestDeliveryConfirmation,
                    driverRequestDeliveryConfirmation) ||
                other.driverRequestDeliveryConfirmation ==
                    driverRequestDeliveryConfirmation) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mainBranchId,
      subBranchId,
      createdAt,
      status,
      deliveryDate,
      deliveryNote,
      orderNote,
      customerReceivedOrder,
      driverRequestDeliveryConfirmation,
      driverId,
      const DeepCollectionEquality().hash(_items),
      updatedAt);

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockRequestImplCopyWith<_$StockRequestImpl> get copyWith =>
      __$$StockRequestImplCopyWithImpl<_$StockRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockRequestImplToJson(
      this,
    );
  }
}

abstract class _StockRequest implements StockRequest {
  const factory _StockRequest(
      {final int? id,
      final int? mainBranchId,
      final int? subBranchId,
      final DateTime? createdAt,
      final String? status,
      final DateTime? deliveryDate,
      final String? deliveryNote,
      final String? orderNote,
      final bool? customerReceivedOrder,
      final bool? driverRequestDeliveryConfirmation,
      final int? driverId,
      final List<TransactionItem> items,
      final DateTime? updatedAt}) = _$StockRequestImpl;

  factory _StockRequest.fromJson(Map<String, dynamic> json) =
      _$StockRequestImpl.fromJson;

  @override
  int? get id;
  @override
  int? get mainBranchId;
  @override
  int? get subBranchId;
  @override
  DateTime?
      get createdAt; // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  @override
  String? get status;
  @override
  DateTime? get deliveryDate;
  @override
  String? get deliveryNote;
  @override
  String? get orderNote;
  @override
  bool? get customerReceivedOrder;
  @override
  bool? get driverRequestDeliveryConfirmation;
  @override
  int? get driverId;
  @override
  List<TransactionItem> get items;
  @override
  DateTime? get updatedAt;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockRequestImplCopyWith<_$StockRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
