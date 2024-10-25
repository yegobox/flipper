// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  int? get id => throw _privateConstructorUsedError;
  String? get custNm => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get telNo => throw _privateConstructorUsedError;
  String? get adrs => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get custNo => throw _privateConstructorUsedError;
  String? get custTin => throw _privateConstructorUsedError;
  String? get regrNm => throw _privateConstructorUsedError;
  String? get regrId => throw _privateConstructorUsedError;
  String get modrNm => throw _privateConstructorUsedError;
  String? get modrId => throw _privateConstructorUsedError;
  bool get ebmSynced => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int? get tin => throw _privateConstructorUsedError;
  String? get bhfId => throw _privateConstructorUsedError;
  String? get useYn => throw _privateConstructorUsedError;
  String? get customerType => throw _privateConstructorUsedError;

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call(
      {int? id,
      String? custNm,
      String? email,
      String? telNo,
      String? adrs,
      int? branchId,
      DateTime? updatedAt,
      String? custNo,
      String? custTin,
      String? regrNm,
      String? regrId,
      String modrNm,
      String? modrId,
      bool ebmSynced,
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? tin,
      String? bhfId,
      String? useYn,
      String? customerType});
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? custNm = freezed,
    Object? email = freezed,
    Object? telNo = freezed,
    Object? adrs = freezed,
    Object? branchId = freezed,
    Object? updatedAt = freezed,
    Object? custNo = freezed,
    Object? custTin = freezed,
    Object? regrNm = freezed,
    Object? regrId = freezed,
    Object? modrNm = null,
    Object? modrId = freezed,
    Object? ebmSynced = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? useYn = freezed,
    Object? customerType = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      custNm: freezed == custNm
          ? _value.custNm
          : custNm // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      telNo: freezed == telNo
          ? _value.telNo
          : telNo // ignore: cast_nullable_to_non_nullable
              as String?,
      adrs: freezed == adrs
          ? _value.adrs
          : adrs // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      custNo: freezed == custNo
          ? _value.custNo
          : custNo // ignore: cast_nullable_to_non_nullable
              as String?,
      custTin: freezed == custTin
          ? _value.custTin
          : custTin // ignore: cast_nullable_to_non_nullable
              as String?,
      regrNm: freezed == regrNm
          ? _value.regrNm
          : regrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      regrId: freezed == regrId
          ? _value.regrId
          : regrId // ignore: cast_nullable_to_non_nullable
              as String?,
      modrNm: null == modrNm
          ? _value.modrNm
          : modrNm // ignore: cast_nullable_to_non_nullable
              as String,
      modrId: freezed == modrId
          ? _value.modrId
          : modrId // ignore: cast_nullable_to_non_nullable
              as String?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      useYn: freezed == useYn
          ? _value.useYn
          : useYn // ignore: cast_nullable_to_non_nullable
              as String?,
      customerType: freezed == customerType
          ? _value.customerType
          : customerType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
          _$CustomerImpl value, $Res Function(_$CustomerImpl) then) =
      __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? custNm,
      String? email,
      String? telNo,
      String? adrs,
      int? branchId,
      DateTime? updatedAt,
      String? custNo,
      String? custTin,
      String? regrNm,
      String? regrId,
      String modrNm,
      String? modrId,
      bool ebmSynced,
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? tin,
      String? bhfId,
      String? useYn,
      String? customerType});
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
      _$CustomerImpl _value, $Res Function(_$CustomerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? custNm = freezed,
    Object? email = freezed,
    Object? telNo = freezed,
    Object? adrs = freezed,
    Object? branchId = freezed,
    Object? updatedAt = freezed,
    Object? custNo = freezed,
    Object? custTin = freezed,
    Object? regrNm = freezed,
    Object? regrId = freezed,
    Object? modrNm = null,
    Object? modrId = freezed,
    Object? ebmSynced = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? useYn = freezed,
    Object? customerType = freezed,
  }) {
    return _then(_$CustomerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      custNm: freezed == custNm
          ? _value.custNm
          : custNm // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      telNo: freezed == telNo
          ? _value.telNo
          : telNo // ignore: cast_nullable_to_non_nullable
              as String?,
      adrs: freezed == adrs
          ? _value.adrs
          : adrs // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      custNo: freezed == custNo
          ? _value.custNo
          : custNo // ignore: cast_nullable_to_non_nullable
              as String?,
      custTin: freezed == custTin
          ? _value.custTin
          : custTin // ignore: cast_nullable_to_non_nullable
              as String?,
      regrNm: freezed == regrNm
          ? _value.regrNm
          : regrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      regrId: freezed == regrId
          ? _value.regrId
          : regrId // ignore: cast_nullable_to_non_nullable
              as String?,
      modrNm: null == modrNm
          ? _value.modrNm
          : modrNm // ignore: cast_nullable_to_non_nullable
              as String,
      modrId: freezed == modrId
          ? _value.modrId
          : modrId // ignore: cast_nullable_to_non_nullable
              as String?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      useYn: freezed == useYn
          ? _value.useYn
          : useYn // ignore: cast_nullable_to_non_nullable
              as String?,
      customerType: freezed == customerType
          ? _value.customerType
          : customerType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl(
      {this.id,
      this.custNm,
      this.email,
      this.telNo,
      this.adrs,
      this.branchId,
      this.updatedAt,
      this.custNo,
      this.custTin,
      this.regrNm,
      this.regrId,
      this.modrNm = "284746303937",
      this.modrId,
      this.ebmSynced = false,
      this.lastTouched,
      this.deletedAt,
      this.tin,
      this.bhfId,
      this.useYn,
      this.customerType});

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final int? id;
  @override
  final String? custNm;
  @override
  final String? email;
  @override
  final String? telNo;
  @override
  final String? adrs;
  @override
  final int? branchId;
  @override
  final DateTime? updatedAt;
  @override
  final String? custNo;
  @override
  final String? custTin;
  @override
  final String? regrNm;
  @override
  final String? regrId;
  @override
  @JsonKey()
  final String modrNm;
  @override
  final String? modrId;
  @override
  @JsonKey()
  final bool ebmSynced;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;
  @override
  final int? tin;
  @override
  final String? bhfId;
  @override
  final String? useYn;
  @override
  final String? customerType;

  @override
  String toString() {
    return 'Customer(id: $id, custNm: $custNm, email: $email, telNo: $telNo, adrs: $adrs, branchId: $branchId, updatedAt: $updatedAt, custNo: $custNo, custTin: $custTin, regrNm: $regrNm, regrId: $regrId, modrNm: $modrNm, modrId: $modrId, ebmSynced: $ebmSynced, lastTouched: $lastTouched, deletedAt: $deletedAt, tin: $tin, bhfId: $bhfId, useYn: $useYn, customerType: $customerType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.custNm, custNm) || other.custNm == custNm) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.telNo, telNo) || other.telNo == telNo) &&
            (identical(other.adrs, adrs) || other.adrs == adrs) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.custNo, custNo) || other.custNo == custNo) &&
            (identical(other.custTin, custTin) || other.custTin == custTin) &&
            (identical(other.regrNm, regrNm) || other.regrNm == regrNm) &&
            (identical(other.regrId, regrId) || other.regrId == regrId) &&
            (identical(other.modrNm, modrNm) || other.modrNm == modrNm) &&
            (identical(other.modrId, modrId) || other.modrId == modrId) &&
            (identical(other.ebmSynced, ebmSynced) ||
                other.ebmSynced == ebmSynced) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.tin, tin) || other.tin == tin) &&
            (identical(other.bhfId, bhfId) || other.bhfId == bhfId) &&
            (identical(other.useYn, useYn) || other.useYn == useYn) &&
            (identical(other.customerType, customerType) ||
                other.customerType == customerType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        custNm,
        email,
        telNo,
        adrs,
        branchId,
        updatedAt,
        custNo,
        custTin,
        regrNm,
        regrId,
        modrNm,
        modrId,
        ebmSynced,
        lastTouched,
        deletedAt,
        tin,
        bhfId,
        useYn,
        customerType
      ]);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(
      this,
    );
  }
}

abstract class _Customer implements Customer {
  const factory _Customer(
      {final int? id,
      final String? custNm,
      final String? email,
      final String? telNo,
      final String? adrs,
      final int? branchId,
      final DateTime? updatedAt,
      final String? custNo,
      final String? custTin,
      final String? regrNm,
      final String? regrId,
      final String modrNm,
      final String? modrId,
      final bool ebmSynced,
      final DateTime? lastTouched,
      final DateTime? deletedAt,
      final int? tin,
      final String? bhfId,
      final String? useYn,
      final String? customerType}) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  int? get id;
  @override
  String? get custNm;
  @override
  String? get email;
  @override
  String? get telNo;
  @override
  String? get adrs;
  @override
  int? get branchId;
  @override
  DateTime? get updatedAt;
  @override
  String? get custNo;
  @override
  String? get custTin;
  @override
  String? get regrNm;
  @override
  String? get regrId;
  @override
  String get modrNm;
  @override
  String? get modrId;
  @override
  bool get ebmSynced;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;
  @override
  int? get tin;
  @override
  String? get bhfId;
  @override
  String? get useYn;
  @override
  String? get customerType;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
