// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Customer> _$customerSerializer = new _$CustomerSerializer();

class _$CustomerSerializer implements StructuredSerializer<Customer> {
  @override
  final Iterable<Type> types = const [Customer, _$Customer];
  @override
  final String wireName = 'Customer';

  @override
  Iterable<Object> serialize(Serializers serializers, Customer object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'totalPoints',
      serializers.serialize(object.totalPoints,
          specifiedType: const FullType(double)),
      'totalVisit',
      serializers.serialize(object.totalVisit,
          specifiedType: const FullType(int)),
      'firstVisit',
      serializers.serialize(object.firstVisit,
          specifiedType: const FullType(String)),
      'totalSpent',
      serializers.serialize(object.totalSpent,
          specifiedType: const FullType(double)),
      'phoneNumber',
      serializers.serialize(object.phoneNumber,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.address != null) {
      result
        ..add('address')
        ..add(serializers.serialize(object.address,
            specifiedType: const FullType(String)));
    }
    if (object.city != null) {
      result
        ..add('city')
        ..add(serializers.serialize(object.city,
            specifiedType: const FullType(String)));
    }
    if (object.region != null) {
      result
        ..add('region')
        ..add(serializers.serialize(object.region,
            specifiedType: const FullType(String)));
    }
    if (object.postalCode != null) {
      result
        ..add('postalCode')
        ..add(serializers.serialize(object.postalCode,
            specifiedType: const FullType(String)));
    }
    if (object.countryCode != null) {
      result
        ..add('countryCode')
        ..add(serializers.serialize(object.countryCode,
            specifiedType: const FullType(String)));
    }
    if (object.customerCode != null) {
      result
        ..add('customerCode')
        ..add(serializers.serialize(object.customerCode,
            specifiedType: const FullType(String)));
    }
    if (object.note != null) {
      result
        ..add('note')
        ..add(serializers.serialize(object.note,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updatedAt')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Customer deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CustomerBuilder();

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
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'totalPoints':
          result.totalPoints = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'totalVisit':
          result.totalVisit = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'firstVisit':
          result.firstVisit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'totalSpent':
          result.totalSpent = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'region':
          result.region = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'countryCode':
          result.countryCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'customerCode':
          result.customerCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
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
      }
    }

    return result.build();
  }
}

class _$Customer extends Customer {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final double totalPoints;
  @override
  final int totalVisit;
  @override
  final String firstVisit;
  @override
  final double totalSpent;
  @override
  final String phoneNumber;
  @override
  final String address;
  @override
  final String city;
  @override
  final String region;
  @override
  final String postalCode;
  @override
  final String countryCode;
  @override
  final String customerCode;
  @override
  final String note;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final BuiltList<String> channels;

  factory _$Customer([void Function(CustomerBuilder) updates]) =>
      (new CustomerBuilder()..update(updates)).build();

  _$Customer._(
      {this.id,
      this.name,
      this.email,
      this.totalPoints,
      this.totalVisit,
      this.firstVisit,
      this.totalSpent,
      this.phoneNumber,
      this.address,
      this.city,
      this.region,
      this.postalCode,
      this.countryCode,
      this.customerCode,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Customer', 'id');
    }
    if (totalPoints == null) {
      throw new BuiltValueNullFieldError('Customer', 'totalPoints');
    }
    if (totalVisit == null) {
      throw new BuiltValueNullFieldError('Customer', 'totalVisit');
    }
    if (firstVisit == null) {
      throw new BuiltValueNullFieldError('Customer', 'firstVisit');
    }
    if (totalSpent == null) {
      throw new BuiltValueNullFieldError('Customer', 'totalSpent');
    }
    if (phoneNumber == null) {
      throw new BuiltValueNullFieldError('Customer', 'phoneNumber');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Customer', 'createdAt');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Customer', 'channels');
    }
  }

  @override
  Customer rebuild(void Function(CustomerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerBuilder toBuilder() => new CustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Customer &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        totalPoints == other.totalPoints &&
        totalVisit == other.totalVisit &&
        firstVisit == other.firstVisit &&
        totalSpent == other.totalSpent &&
        phoneNumber == other.phoneNumber &&
        address == other.address &&
        city == other.city &&
        region == other.region &&
        postalCode == other.postalCode &&
        countryCode == other.countryCode &&
        customerCode == other.customerCode &&
        note == other.note &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        channels == other.channels;
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
                                                                            0,
                                                                            id
                                                                                .hashCode),
                                                                        name
                                                                            .hashCode),
                                                                    email
                                                                        .hashCode),
                                                                totalPoints
                                                                    .hashCode),
                                                            totalVisit
                                                                .hashCode),
                                                        firstVisit.hashCode),
                                                    totalSpent.hashCode),
                                                phoneNumber.hashCode),
                                            address.hashCode),
                                        city.hashCode),
                                    region.hashCode),
                                postalCode.hashCode),
                            countryCode.hashCode),
                        customerCode.hashCode),
                    note.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Customer')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('totalPoints', totalPoints)
          ..add('totalVisit', totalVisit)
          ..add('firstVisit', firstVisit)
          ..add('totalSpent', totalSpent)
          ..add('phoneNumber', phoneNumber)
          ..add('address', address)
          ..add('city', city)
          ..add('region', region)
          ..add('postalCode', postalCode)
          ..add('countryCode', countryCode)
          ..add('customerCode', customerCode)
          ..add('note', note)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('channels', channels))
        .toString();
  }
}

class CustomerBuilder implements Builder<Customer, CustomerBuilder> {
  _$Customer _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  double _totalPoints;
  double get totalPoints => _$this._totalPoints;
  set totalPoints(double totalPoints) => _$this._totalPoints = totalPoints;

  int _totalVisit;
  int get totalVisit => _$this._totalVisit;
  set totalVisit(int totalVisit) => _$this._totalVisit = totalVisit;

  String _firstVisit;
  String get firstVisit => _$this._firstVisit;
  set firstVisit(String firstVisit) => _$this._firstVisit = firstVisit;

  double _totalSpent;
  double get totalSpent => _$this._totalSpent;
  set totalSpent(double totalSpent) => _$this._totalSpent = totalSpent;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _city;
  String get city => _$this._city;
  set city(String city) => _$this._city = city;

  String _region;
  String get region => _$this._region;
  set region(String region) => _$this._region = region;

  String _postalCode;
  String get postalCode => _$this._postalCode;
  set postalCode(String postalCode) => _$this._postalCode = postalCode;

  String _countryCode;
  String get countryCode => _$this._countryCode;
  set countryCode(String countryCode) => _$this._countryCode = countryCode;

  String _customerCode;
  String get customerCode => _$this._customerCode;
  set customerCode(String customerCode) => _$this._customerCode = customerCode;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

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

  CustomerBuilder();

  CustomerBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _email = _$v.email;
      _totalPoints = _$v.totalPoints;
      _totalVisit = _$v.totalVisit;
      _firstVisit = _$v.firstVisit;
      _totalSpent = _$v.totalSpent;
      _phoneNumber = _$v.phoneNumber;
      _address = _$v.address;
      _city = _$v.city;
      _region = _$v.region;
      _postalCode = _$v.postalCode;
      _countryCode = _$v.countryCode;
      _customerCode = _$v.customerCode;
      _note = _$v.note;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Customer other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Customer;
  }

  @override
  void update(void Function(CustomerBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Customer build() {
    _$Customer _$result;
    try {
      _$result = _$v ??
          new _$Customer._(
              id: id,
              name: name,
              email: email,
              totalPoints: totalPoints,
              totalVisit: totalVisit,
              firstVisit: firstVisit,
              totalSpent: totalSpent,
              phoneNumber: phoneNumber,
              address: address,
              city: city,
              region: region,
              postalCode: postalCode,
              countryCode: countryCode,
              customerCode: customerCode,
              note: note,
              createdAt: createdAt,
              updatedAt: updatedAt,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Customer', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
