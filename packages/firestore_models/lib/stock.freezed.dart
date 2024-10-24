// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Stock _$StockFromJson(Map<String, dynamic> json) {
  return _Stock.fromJson(json);
}

/// @nodoc
mixin _$Stock {
  int? get id => throw _privateConstructorUsedError;
  int? get tin => throw _privateConstructorUsedError;
  String? get bhfId => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  double get currentStock => throw _privateConstructorUsedError;
  double get lowStock => throw _privateConstructorUsedError;
  bool? get canTrackingStock => throw _privateConstructorUsedError;
  bool? get showLowStockAlert => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  bool? get active =>
      throw _privateConstructorUsedError; // the value of stock is currentStock * retailPrice
  double get value => throw _privateConstructorUsedError; // RRA fields
  double get rsdQty => throw _privateConstructorUsedError;
  double get supplyPrice => throw _privateConstructorUsedError;
  double get retailPrice => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Sync status fields
  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool get ebmSynced => throw _privateConstructorUsedError;

  /// by default it is set to true because as soon we save in realm we auto-save in sqlite
  /// which means we don't need to re-sync, but when received
  bool get cloudSynced => throw _privateConstructorUsedError; // Relationships
  Variant? get variant => throw _privateConstructorUsedError;
  double? get initialStock => throw _privateConstructorUsedError;

  /// Serializes this Stock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockCopyWith<Stock> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockCopyWith<$Res> {
  factory $StockCopyWith(Stock value, $Res Function(Stock) then) =
      _$StockCopyWithImpl<$Res, Stock>;
  @useResult
  $Res call(
      {int? id,
      int? tin,
      String? bhfId,
      int? branchId,
      int? variantId,
      double currentStock,
      double lowStock,
      bool? canTrackingStock,
      bool? showLowStockAlert,
      int? productId,
      bool? active,
      double value,
      double rsdQty,
      double supplyPrice,
      double retailPrice,
      DateTime? lastTouched,
      DateTime? deletedAt,
      bool ebmSynced,
      bool cloudSynced,
      Variant? variant,
      double? initialStock});

  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class _$StockCopyWithImpl<$Res, $Val extends Stock>
    implements $StockCopyWith<$Res> {
  _$StockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? branchId = freezed,
    Object? variantId = freezed,
    Object? currentStock = null,
    Object? lowStock = null,
    Object? canTrackingStock = freezed,
    Object? showLowStockAlert = freezed,
    Object? productId = freezed,
    Object? active = freezed,
    Object? value = null,
    Object? rsdQty = null,
    Object? supplyPrice = null,
    Object? retailPrice = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? ebmSynced = null,
    Object? cloudSynced = null,
    Object? variant = freezed,
    Object? initialStock = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      lowStock: null == lowStock
          ? _value.lowStock
          : lowStock // ignore: cast_nullable_to_non_nullable
              as double,
      canTrackingStock: freezed == canTrackingStock
          ? _value.canTrackingStock
          : canTrackingStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      showLowStockAlert: freezed == showLowStockAlert
          ? _value.showLowStockAlert
          : showLowStockAlert // ignore: cast_nullable_to_non_nullable
              as bool?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      rsdQty: null == rsdQty
          ? _value.rsdQty
          : rsdQty // ignore: cast_nullable_to_non_nullable
              as double,
      supplyPrice: null == supplyPrice
          ? _value.supplyPrice
          : supplyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      retailPrice: null == retailPrice
          ? _value.retailPrice
          : retailPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudSynced: null == cloudSynced
          ? _value.cloudSynced
          : cloudSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as Variant?,
      initialStock: freezed == initialStock
          ? _value.initialStock
          : initialStock // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VariantCopyWith<$Res>? get variant {
    if (_value.variant == null) {
      return null;
    }

    return $VariantCopyWith<$Res>(_value.variant!, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockImplCopyWith<$Res> implements $StockCopyWith<$Res> {
  factory _$$StockImplCopyWith(
          _$StockImpl value, $Res Function(_$StockImpl) then) =
      __$$StockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? tin,
      String? bhfId,
      int? branchId,
      int? variantId,
      double currentStock,
      double lowStock,
      bool? canTrackingStock,
      bool? showLowStockAlert,
      int? productId,
      bool? active,
      double value,
      double rsdQty,
      double supplyPrice,
      double retailPrice,
      DateTime? lastTouched,
      DateTime? deletedAt,
      bool ebmSynced,
      bool cloudSynced,
      Variant? variant,
      double? initialStock});

  @override
  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class __$$StockImplCopyWithImpl<$Res>
    extends _$StockCopyWithImpl<$Res, _$StockImpl>
    implements _$$StockImplCopyWith<$Res> {
  __$$StockImplCopyWithImpl(
      _$StockImpl _value, $Res Function(_$StockImpl) _then)
      : super(_value, _then);

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? branchId = freezed,
    Object? variantId = freezed,
    Object? currentStock = null,
    Object? lowStock = null,
    Object? canTrackingStock = freezed,
    Object? showLowStockAlert = freezed,
    Object? productId = freezed,
    Object? active = freezed,
    Object? value = null,
    Object? rsdQty = null,
    Object? supplyPrice = null,
    Object? retailPrice = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? ebmSynced = null,
    Object? cloudSynced = null,
    Object? variant = freezed,
    Object? initialStock = freezed,
  }) {
    return _then(_$StockImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      lowStock: null == lowStock
          ? _value.lowStock
          : lowStock // ignore: cast_nullable_to_non_nullable
              as double,
      canTrackingStock: freezed == canTrackingStock
          ? _value.canTrackingStock
          : canTrackingStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      showLowStockAlert: freezed == showLowStockAlert
          ? _value.showLowStockAlert
          : showLowStockAlert // ignore: cast_nullable_to_non_nullable
              as bool?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      rsdQty: null == rsdQty
          ? _value.rsdQty
          : rsdQty // ignore: cast_nullable_to_non_nullable
              as double,
      supplyPrice: null == supplyPrice
          ? _value.supplyPrice
          : supplyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      retailPrice: null == retailPrice
          ? _value.retailPrice
          : retailPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudSynced: null == cloudSynced
          ? _value.cloudSynced
          : cloudSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as Variant?,
      initialStock: freezed == initialStock
          ? _value.initialStock
          : initialStock // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockImpl extends _Stock {
  const _$StockImpl(
      {this.id,
      this.tin,
      this.bhfId,
      this.branchId,
      this.variantId,
      this.currentStock = 0.0,
      this.lowStock = 0.0,
      this.canTrackingStock = true,
      this.showLowStockAlert = true,
      this.productId,
      this.active,
      this.value = 0.0,
      this.rsdQty = 0.0,
      this.supplyPrice = 0.0,
      this.retailPrice = 0.0,
      this.lastTouched,
      this.deletedAt,
      this.ebmSynced = false,
      this.cloudSynced = true,
      this.variant,
      this.initialStock})
      : super._();

  factory _$StockImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockImplFromJson(json);

  @override
  final int? id;
  @override
  final int? tin;
  @override
  final String? bhfId;
  @override
  final int? branchId;
  @override
  final int? variantId;
  @override
  @JsonKey()
  final double currentStock;
  @override
  @JsonKey()
  final double lowStock;
  @override
  @JsonKey()
  final bool? canTrackingStock;
  @override
  @JsonKey()
  final bool? showLowStockAlert;
  @override
  final int? productId;
  @override
  final bool? active;
// the value of stock is currentStock * retailPrice
  @override
  @JsonKey()
  final double value;
// RRA fields
  @override
  @JsonKey()
  final double rsdQty;
  @override
  @JsonKey()
  final double supplyPrice;
  @override
  @JsonKey()
  final double retailPrice;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;

  /// Sync status fields
  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  @override
  @JsonKey()
  final bool ebmSynced;

  /// by default it is set to true because as soon we save in realm we auto-save in sqlite
  /// which means we don't need to re-sync, but when received
  @override
  @JsonKey()
  final bool cloudSynced;
// Relationships
  @override
  final Variant? variant;
  @override
  final double? initialStock;

  @override
  String toString() {
    return 'Stock(id: $id, tin: $tin, bhfId: $bhfId, branchId: $branchId, variantId: $variantId, currentStock: $currentStock, lowStock: $lowStock, canTrackingStock: $canTrackingStock, showLowStockAlert: $showLowStockAlert, productId: $productId, active: $active, value: $value, rsdQty: $rsdQty, supplyPrice: $supplyPrice, retailPrice: $retailPrice, lastTouched: $lastTouched, deletedAt: $deletedAt, ebmSynced: $ebmSynced, cloudSynced: $cloudSynced, variant: $variant, initialStock: $initialStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tin, tin) || other.tin == tin) &&
            (identical(other.bhfId, bhfId) || other.bhfId == bhfId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.lowStock, lowStock) ||
                other.lowStock == lowStock) &&
            (identical(other.canTrackingStock, canTrackingStock) ||
                other.canTrackingStock == canTrackingStock) &&
            (identical(other.showLowStockAlert, showLowStockAlert) ||
                other.showLowStockAlert == showLowStockAlert) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.rsdQty, rsdQty) || other.rsdQty == rsdQty) &&
            (identical(other.supplyPrice, supplyPrice) ||
                other.supplyPrice == supplyPrice) &&
            (identical(other.retailPrice, retailPrice) ||
                other.retailPrice == retailPrice) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.ebmSynced, ebmSynced) ||
                other.ebmSynced == ebmSynced) &&
            (identical(other.cloudSynced, cloudSynced) ||
                other.cloudSynced == cloudSynced) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.initialStock, initialStock) ||
                other.initialStock == initialStock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        tin,
        bhfId,
        branchId,
        variantId,
        currentStock,
        lowStock,
        canTrackingStock,
        showLowStockAlert,
        productId,
        active,
        value,
        rsdQty,
        supplyPrice,
        retailPrice,
        lastTouched,
        deletedAt,
        ebmSynced,
        cloudSynced,
        variant,
        initialStock
      ]);

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      __$$StockImplCopyWithImpl<_$StockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockImplToJson(
      this,
    );
  }
}

abstract class _Stock extends Stock {
  const factory _Stock(
      {final int? id,
      final int? tin,
      final String? bhfId,
      final int? branchId,
      final int? variantId,
      final double currentStock,
      final double lowStock,
      final bool? canTrackingStock,
      final bool? showLowStockAlert,
      final int? productId,
      final bool? active,
      final double value,
      final double rsdQty,
      final double supplyPrice,
      final double retailPrice,
      final DateTime? lastTouched,
      final DateTime? deletedAt,
      final bool ebmSynced,
      final bool cloudSynced,
      final Variant? variant,
      final double? initialStock}) = _$StockImpl;
  const _Stock._() : super._();

  factory _Stock.fromJson(Map<String, dynamic> json) = _$StockImpl.fromJson;

  @override
  int? get id;
  @override
  int? get tin;
  @override
  String? get bhfId;
  @override
  int? get branchId;
  @override
  int? get variantId;
  @override
  double get currentStock;
  @override
  double get lowStock;
  @override
  bool? get canTrackingStock;
  @override
  bool? get showLowStockAlert;
  @override
  int? get productId;
  @override
  bool? get active; // the value of stock is currentStock * retailPrice
  @override
  double get value; // RRA fields
  @override
  double get rsdQty;
  @override
  double get supplyPrice;
  @override
  double get retailPrice;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;

  /// Sync status fields
  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  @override
  bool get ebmSynced;

  /// by default it is set to true because as soon we save in realm we auto-save in sqlite
  /// which means we don't need to re-sync, but when received
  @override
  bool get cloudSynced; // Relationships
  @override
  Variant? get variant;
  @override
  double? get initialStock;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
