// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Branch extends Branch {
  @override
  final String id;
  @override
  final String businessId;
  @override
  final String createdAt;
  @override
  final String name;
  @override
  final String mapLatitude;
  @override
  final String mapLongitude;
  @override
  final String updatedAt;
  @override
  final String description;
  @override
  final bool active;
  @override
  final String location;

  factory _$Branch([void Function(BranchBuilder) updates]) =>
      (new BranchBuilder()..update(updates)).build();

  _$Branch._(
      {this.id,
      this.businessId,
      this.createdAt,
      this.name,
      this.mapLatitude,
      this.mapLongitude,
      this.updatedAt,
      this.description,
      this.active,
      this.location})
      : super._() {
    if (businessId == null) {
      throw new BuiltValueNullFieldError('Branch', 'businessId');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Branch', 'createdAt');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Branch', 'name');
    }
    if (mapLatitude == null) {
      throw new BuiltValueNullFieldError('Branch', 'mapLatitude');
    }
    if (mapLongitude == null) {
      throw new BuiltValueNullFieldError('Branch', 'mapLongitude');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Branch', 'updatedAt');
    }
  }

  @override
  Branch rebuild(void Function(BranchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BranchBuilder toBuilder() => new BranchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Branch &&
        id == other.id &&
        businessId == other.businessId &&
        createdAt == other.createdAt &&
        name == other.name &&
        mapLatitude == other.mapLatitude &&
        mapLongitude == other.mapLongitude &&
        updatedAt == other.updatedAt &&
        description == other.description &&
        active == other.active &&
        location == other.location;
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
                                    $jc($jc(0, id.hashCode),
                                        businessId.hashCode),
                                    createdAt.hashCode),
                                name.hashCode),
                            mapLatitude.hashCode),
                        mapLongitude.hashCode),
                    updatedAt.hashCode),
                description.hashCode),
            active.hashCode),
        location.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Branch')
          ..add('id', id)
          ..add('businessId', businessId)
          ..add('createdAt', createdAt)
          ..add('name', name)
          ..add('mapLatitude', mapLatitude)
          ..add('mapLongitude', mapLongitude)
          ..add('updatedAt', updatedAt)
          ..add('description', description)
          ..add('active', active)
          ..add('location', location))
        .toString();
  }
}

class BranchBuilder implements Builder<Branch, BranchBuilder> {
  _$Branch _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _mapLatitude;
  String get mapLatitude => _$this._mapLatitude;
  set mapLatitude(String mapLatitude) => _$this._mapLatitude = mapLatitude;

  String _mapLongitude;
  String get mapLongitude => _$this._mapLongitude;
  set mapLongitude(String mapLongitude) => _$this._mapLongitude = mapLongitude;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  String _location;
  String get location => _$this._location;
  set location(String location) => _$this._location = location;

  BranchBuilder();

  BranchBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _businessId = _$v.businessId;
      _createdAt = _$v.createdAt;
      _name = _$v.name;
      _mapLatitude = _$v.mapLatitude;
      _mapLongitude = _$v.mapLongitude;
      _updatedAt = _$v.updatedAt;
      _description = _$v.description;
      _active = _$v.active;
      _location = _$v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Branch other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Branch;
  }

  @override
  void update(void Function(BranchBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Branch build() {
    final _$result = _$v ??
        new _$Branch._(
            id: id,
            businessId: businessId,
            createdAt: createdAt,
            name: name,
            mapLatitude: mapLatitude,
            mapLongitude: mapLongitude,
            updatedAt: updatedAt,
            description: description,
            active: active,
            location: location);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
