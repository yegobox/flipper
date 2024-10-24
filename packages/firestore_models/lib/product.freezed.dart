// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get taxId => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get expiryDate => throw _privateConstructorUsedError;
  String? get barCode => throw _privateConstructorUsedError;
  bool get nfcEnabled => throw _privateConstructorUsedError;
  int? get bindedToTenantId => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  bool get searchMatch => throw _privateConstructorUsedError; // Ignored field
  String? get spplrNm => throw _privateConstructorUsedError;
  bool? get isComposite => throw _privateConstructorUsedError;
  List<Composite> get composites => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? description,
      String? taxId,
      String color,
      int? businessId,
      int? branchId,
      String? supplierId,
      int? categoryId,
      String? createdAt,
      String? unit,
      String? imageUrl,
      String? expiryDate,
      String? barCode,
      bool nfcEnabled,
      int? bindedToTenantId,
      bool isFavorite,
      DateTime? lastTouched,
      DateTime? deletedAt,
      @JsonKey(includeToJson: false) bool searchMatch,
      String? spplrNm,
      bool? isComposite,
      List<Composite> composites});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? taxId = freezed,
    Object? color = null,
    Object? businessId = freezed,
    Object? branchId = freezed,
    Object? supplierId = freezed,
    Object? categoryId = freezed,
    Object? createdAt = freezed,
    Object? unit = freezed,
    Object? imageUrl = freezed,
    Object? expiryDate = freezed,
    Object? barCode = freezed,
    Object? nfcEnabled = null,
    Object? bindedToTenantId = freezed,
    Object? isFavorite = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? searchMatch = null,
    Object? spplrNm = freezed,
    Object? isComposite = freezed,
    Object? composites = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _value.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      barCode: freezed == barCode
          ? _value.barCode
          : barCode // ignore: cast_nullable_to_non_nullable
              as String?,
      nfcEnabled: null == nfcEnabled
          ? _value.nfcEnabled
          : nfcEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      bindedToTenantId: freezed == bindedToTenantId
          ? _value.bindedToTenantId
          : bindedToTenantId // ignore: cast_nullable_to_non_nullable
              as int?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchMatch: null == searchMatch
          ? _value.searchMatch
          : searchMatch // ignore: cast_nullable_to_non_nullable
              as bool,
      spplrNm: freezed == spplrNm
          ? _value.spplrNm
          : spplrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      isComposite: freezed == isComposite
          ? _value.isComposite
          : isComposite // ignore: cast_nullable_to_non_nullable
              as bool?,
      composites: null == composites
          ? _value.composites
          : composites // ignore: cast_nullable_to_non_nullable
              as List<Composite>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? description,
      String? taxId,
      String color,
      int? businessId,
      int? branchId,
      String? supplierId,
      int? categoryId,
      String? createdAt,
      String? unit,
      String? imageUrl,
      String? expiryDate,
      String? barCode,
      bool nfcEnabled,
      int? bindedToTenantId,
      bool isFavorite,
      DateTime? lastTouched,
      DateTime? deletedAt,
      @JsonKey(includeToJson: false) bool searchMatch,
      String? spplrNm,
      bool? isComposite,
      List<Composite> composites});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? taxId = freezed,
    Object? color = null,
    Object? businessId = freezed,
    Object? branchId = freezed,
    Object? supplierId = freezed,
    Object? categoryId = freezed,
    Object? createdAt = freezed,
    Object? unit = freezed,
    Object? imageUrl = freezed,
    Object? expiryDate = freezed,
    Object? barCode = freezed,
    Object? nfcEnabled = null,
    Object? bindedToTenantId = freezed,
    Object? isFavorite = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? searchMatch = null,
    Object? spplrNm = freezed,
    Object? isComposite = freezed,
    Object? composites = null,
  }) {
    return _then(_$ProductImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _value.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      barCode: freezed == barCode
          ? _value.barCode
          : barCode // ignore: cast_nullable_to_non_nullable
              as String?,
      nfcEnabled: null == nfcEnabled
          ? _value.nfcEnabled
          : nfcEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      bindedToTenantId: freezed == bindedToTenantId
          ? _value.bindedToTenantId
          : bindedToTenantId // ignore: cast_nullable_to_non_nullable
              as int?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchMatch: null == searchMatch
          ? _value.searchMatch
          : searchMatch // ignore: cast_nullable_to_non_nullable
              as bool,
      spplrNm: freezed == spplrNm
          ? _value.spplrNm
          : spplrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      isComposite: freezed == isComposite
          ? _value.isComposite
          : isComposite // ignore: cast_nullable_to_non_nullable
              as bool?,
      composites: null == composites
          ? _value._composites
          : composites // ignore: cast_nullable_to_non_nullable
              as List<Composite>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  _$ProductImpl(
      {this.id,
      this.name,
      this.description,
      this.taxId,
      this.color = "#e74c3c",
      this.businessId,
      this.branchId,
      this.supplierId,
      this.categoryId,
      this.createdAt,
      this.unit,
      this.imageUrl,
      this.expiryDate,
      this.barCode,
      this.nfcEnabled = false,
      this.bindedToTenantId,
      this.isFavorite = false,
      this.lastTouched,
      this.deletedAt,
      @JsonKey(includeToJson: false) this.searchMatch = false,
      this.spplrNm,
      this.isComposite = false,
      final List<Composite> composites = const <Composite>[]})
      : _composites = composites;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? taxId;
  @override
  @JsonKey()
  final String color;
  @override
  final int? businessId;
  @override
  final int? branchId;
  @override
  final String? supplierId;
  @override
  final int? categoryId;
  @override
  final String? createdAt;
  @override
  final String? unit;
  @override
  final String? imageUrl;
  @override
  final String? expiryDate;
  @override
  final String? barCode;
  @override
  @JsonKey()
  final bool nfcEnabled;
  @override
  final int? bindedToTenantId;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey(includeToJson: false)
  final bool searchMatch;
// Ignored field
  @override
  final String? spplrNm;
  @override
  @JsonKey()
  final bool? isComposite;
  final List<Composite> _composites;
  @override
  @JsonKey()
  List<Composite> get composites {
    if (_composites is EqualUnmodifiableListView) return _composites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_composites);
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, taxId: $taxId, color: $color, businessId: $businessId, branchId: $branchId, supplierId: $supplierId, categoryId: $categoryId, createdAt: $createdAt, unit: $unit, imageUrl: $imageUrl, expiryDate: $expiryDate, barCode: $barCode, nfcEnabled: $nfcEnabled, bindedToTenantId: $bindedToTenantId, isFavorite: $isFavorite, lastTouched: $lastTouched, deletedAt: $deletedAt, searchMatch: $searchMatch, spplrNm: $spplrNm, isComposite: $isComposite, composites: $composites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.barCode, barCode) || other.barCode == barCode) &&
            (identical(other.nfcEnabled, nfcEnabled) ||
                other.nfcEnabled == nfcEnabled) &&
            (identical(other.bindedToTenantId, bindedToTenantId) ||
                other.bindedToTenantId == bindedToTenantId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.searchMatch, searchMatch) ||
                other.searchMatch == searchMatch) &&
            (identical(other.spplrNm, spplrNm) || other.spplrNm == spplrNm) &&
            (identical(other.isComposite, isComposite) ||
                other.isComposite == isComposite) &&
            const DeepCollectionEquality()
                .equals(other._composites, _composites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        taxId,
        color,
        businessId,
        branchId,
        supplierId,
        categoryId,
        createdAt,
        unit,
        imageUrl,
        expiryDate,
        barCode,
        nfcEnabled,
        bindedToTenantId,
        isFavorite,
        lastTouched,
        deletedAt,
        searchMatch,
        spplrNm,
        isComposite,
        const DeepCollectionEquality().hash(_composites)
      ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  factory _Product(
      {final int? id,
      final String? name,
      final String? description,
      final String? taxId,
      final String color,
      final int? businessId,
      final int? branchId,
      final String? supplierId,
      final int? categoryId,
      final String? createdAt,
      final String? unit,
      final String? imageUrl,
      final String? expiryDate,
      final String? barCode,
      final bool nfcEnabled,
      final int? bindedToTenantId,
      final bool isFavorite,
      final DateTime? lastTouched,
      final DateTime? deletedAt,
      @JsonKey(includeToJson: false) final bool searchMatch,
      final String? spplrNm,
      final bool? isComposite,
      final List<Composite> composites}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get taxId;
  @override
  String get color;
  @override
  int? get businessId;
  @override
  int? get branchId;
  @override
  String? get supplierId;
  @override
  int? get categoryId;
  @override
  String? get createdAt;
  @override
  String? get unit;
  @override
  String? get imageUrl;
  @override
  String? get expiryDate;
  @override
  String? get barCode;
  @override
  bool get nfcEnabled;
  @override
  int? get bindedToTenantId;
  @override
  bool get isFavorite;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(includeToJson: false)
  bool get searchMatch; // Ignored field
  @override
  String? get spplrNm;
  @override
  bool? get isComposite;
  @override
  List<Composite> get composites;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
