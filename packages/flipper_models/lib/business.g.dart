// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Business> _$businessSerializer = new _$BusinessSerializer();

class _$BusinessSerializer implements StructuredSerializer<Business> {
  @override
  final Iterable<Type> types = const [Business, _$Business];
  @override
  final String wireName = 'Business';

  @override
  Iterable<Object> serialize(Serializers serializers, Business object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
      'currency',
      serializers.serialize(object.currency,
          specifiedType: const FullType(String)),
      'categoryId',
      serializers.serialize(object.categoryId,
          specifiedType: const FullType(String)),
      'typeId',
      serializers.serialize(object.typeId,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'country',
      serializers.serialize(object.country,
          specifiedType: const FullType(String)),
    ];
    if (object.latitude != null) {
      result
        ..add('latitude')
        ..add(serializers.serialize(object.latitude,
            specifiedType: const FullType(String)));
    }
    if (object.longitude != null) {
      result
        ..add('longitude')
        ..add(serializers.serialize(object.longitude,
            specifiedType: const FullType(String)));
    }
    if (object.userId != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(object.userId,
            specifiedType: const FullType(String)));
    }
    if (object.timeZone != null) {
      result
        ..add('timeZone')
        ..add(serializers.serialize(object.timeZone,
            specifiedType: const FullType(String)));
    }
    if (object.createdAt != null) {
      result
        ..add('createdAt')
        ..add(serializers.serialize(object.createdAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updatedAt')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    if (object.businessUrl != null) {
      result
        ..add('businessUrl')
        ..add(serializers.serialize(object.businessUrl,
            specifiedType: const FullType(String)));
    }
    if (object.hexColor != null) {
      result
        ..add('hexColor')
        ..add(serializers.serialize(object.hexColor,
            specifiedType: const FullType(String)));
    }
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    if (object.type != null) {
      result
        ..add('type')
        ..add(serializers.serialize(object.type,
            specifiedType: const FullType(String)));
    }
    if (object.table != null) {
      result
        ..add('table')
        ..add(serializers.serialize(object.table,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Business deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BusinessBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'active':
          result.active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'currency':
          result.currency = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'categoryId':
          result.categoryId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'typeId':
          result.typeId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'timeZone':
          result.timeZone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'businessUrl':
          result.businessUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'hexColor':
          result.hexColor = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Business extends Business {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool active;
  @override
  final String currency;
  @override
  final String categoryId;
  @override
  final String latitude;
  @override
  final String longitude;
  @override
  final String userId;
  @override
  final String typeId;
  @override
  final String timeZone;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final BuiltList<String> channels;
  @override
  final String country;
  @override
  final String businessUrl;
  @override
  final String hexColor;
  @override
  final String image;
  @override
  final String type;
  @override
  final String table;

  factory _$Business([void Function(BusinessBuilder) updates]) =>
      (new BusinessBuilder()..update(updates)).build();

  _$Business._(
      {this.id,
      this.name,
      this.active,
      this.currency,
      this.categoryId,
      this.latitude,
      this.longitude,
      this.userId,
      this.typeId,
      this.timeZone,
      this.createdAt,
      this.updatedAt,
      this.channels,
      this.country,
      this.businessUrl,
      this.hexColor,
      this.image,
      this.type,
      this.table})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Business', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Business', 'name');
    }
    if (active == null) {
      throw new BuiltValueNullFieldError('Business', 'active');
    }
    if (currency == null) {
      throw new BuiltValueNullFieldError('Business', 'currency');
    }
    if (categoryId == null) {
      throw new BuiltValueNullFieldError('Business', 'categoryId');
    }
    if (typeId == null) {
      throw new BuiltValueNullFieldError('Business', 'typeId');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Business', 'channels');
    }
    if (country == null) {
      throw new BuiltValueNullFieldError('Business', 'country');
    }
  }

  @override
  Business rebuild(void Function(BusinessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BusinessBuilder toBuilder() => new BusinessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Business &&
        id == other.id &&
        name == other.name &&
        active == other.active &&
        currency == other.currency &&
        categoryId == other.categoryId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        userId == other.userId &&
        typeId == other.typeId &&
        timeZone == other.timeZone &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        channels == other.channels &&
        country == other.country &&
        businessUrl == other.businessUrl &&
        hexColor == other.hexColor &&
        image == other.image &&
        type == other.type &&
        table == other.table;
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
                                                                            name
                                                                                .hashCode),
                                                                        active
                                                                            .hashCode),
                                                                    currency
                                                                        .hashCode),
                                                                categoryId
                                                                    .hashCode),
                                                            latitude.hashCode),
                                                        longitude.hashCode),
                                                    userId.hashCode),
                                                typeId.hashCode),
                                            timeZone.hashCode),
                                        createdAt.hashCode),
                                    updatedAt.hashCode),
                                channels.hashCode),
                            country.hashCode),
                        businessUrl.hashCode),
                    hexColor.hashCode),
                image.hashCode),
            type.hashCode),
        table.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Business')
          ..add('id', id)
          ..add('name', name)
          ..add('active', active)
          ..add('currency', currency)
          ..add('categoryId', categoryId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('userId', userId)
          ..add('typeId', typeId)
          ..add('timeZone', timeZone)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('channels', channels)
          ..add('country', country)
          ..add('businessUrl', businessUrl)
          ..add('hexColor', hexColor)
          ..add('image', image)
          ..add('type', type)
          ..add('table', table))
        .toString();
  }
}

class BusinessBuilder implements Builder<Business, BusinessBuilder> {
  _$Business _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  String _currency;
  String get currency => _$this._currency;
  set currency(String currency) => _$this._currency = currency;

  String _categoryId;
  String get categoryId => _$this._categoryId;
  set categoryId(String categoryId) => _$this._categoryId = categoryId;

  String _latitude;
  String get latitude => _$this._latitude;
  set latitude(String latitude) => _$this._latitude = latitude;

  String _longitude;
  String get longitude => _$this._longitude;
  set longitude(String longitude) => _$this._longitude = longitude;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _typeId;
  String get typeId => _$this._typeId;
  set typeId(String typeId) => _$this._typeId = typeId;

  String _timeZone;
  String get timeZone => _$this._timeZone;
  set timeZone(String timeZone) => _$this._timeZone = timeZone;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  String _country;
  String get country => _$this._country;
  set country(String country) => _$this._country = country;

  String _businessUrl;
  String get businessUrl => _$this._businessUrl;
  set businessUrl(String businessUrl) => _$this._businessUrl = businessUrl;

  String _hexColor;
  String get hexColor => _$this._hexColor;
  set hexColor(String hexColor) => _$this._hexColor = hexColor;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  BusinessBuilder();

  BusinessBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _active = _$v.active;
      _currency = _$v.currency;
      _categoryId = _$v.categoryId;
      _latitude = _$v.latitude;
      _longitude = _$v.longitude;
      _userId = _$v.userId;
      _typeId = _$v.typeId;
      _timeZone = _$v.timeZone;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _channels = _$v.channels?.toBuilder();
      _country = _$v.country;
      _businessUrl = _$v.businessUrl;
      _hexColor = _$v.hexColor;
      _image = _$v.image;
      _type = _$v.type;
      _table = _$v.table;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Business other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Business;
  }

  @override
  void update(void Function(BusinessBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Business build() {
    _$Business _$result;
    try {
      _$result = _$v ??
          new _$Business._(
              id: id,
              name: name,
              active: active,
              currency: currency,
              categoryId: categoryId,
              latitude: latitude,
              longitude: longitude,
              userId: userId,
              typeId: typeId,
              timeZone: timeZone,
              createdAt: createdAt,
              updatedAt: updatedAt,
              channels: channels.build(),
              country: country,
              businessUrl: businessUrl,
              hexColor: hexColor,
              image: image,
              type: type,
              table: table);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Business', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
