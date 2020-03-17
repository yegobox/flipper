// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final int userId;
  final String username;
  final String token;
  final String email;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  UserTableData(
      {@required this.id,
      @required this.userId,
      this.username,
      this.token,
      this.email,
      this.avatar,
      this.createdAt,
      this.updatedAt});
  factory UserTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return UserTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      username: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}username']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      avatar:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      token: serializer.fromJson<String>(json['token']),
      email: serializer.fromJson<String>(json['email']),
      avatar: serializer.fromJson<String>(json['avatar']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'username': serializer.toJson<String>(username),
      'token': serializer.toJson<String>(token),
      'email': serializer.toJson<String>(email),
      'avatar': serializer.toJson<String>(avatar),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  UserTableCompanion createCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  UserTableData copyWith(
          {int id,
          int userId,
          String username,
          String token,
          String email,
          String avatar,
          DateTime createdAt,
          DateTime updatedAt}) =>
      UserTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        token: token ?? this.token,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('token: $token, ')
          ..write('email: $email, ')
          ..write('avatar: $avatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(
              username.hashCode,
              $mrjc(
                  token.hashCode,
                  $mrjc(
                      email.hashCode,
                      $mrjc(avatar.hashCode,
                          $mrjc(createdAt.hashCode, updatedAt.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.token == this.token &&
          other.email == this.email &&
          other.avatar == this.avatar &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> username;
  final Value<String> token;
  final Value<String> email;
  final Value<String> avatar;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.token = const Value.absent(),
    this.email = const Value.absent(),
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    @required int userId,
    this.username = const Value.absent(),
    this.token = const Value.absent(),
    this.email = const Value.absent(),
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId);
  UserTableCompanion copyWith(
      {Value<int> id,
      Value<int> userId,
      Value<String> username,
      Value<String> token,
      Value<String> email,
      Value<String> avatar,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return UserTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      token: token ?? this.token,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $UserTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  GeneratedTextColumn _username;
  @override
  GeneratedTextColumn get username => _username ??= _constructUsername();
  GeneratedTextColumn _constructUsername() {
    return GeneratedTextColumn(
      'username',
      $tableName,
      true,
    );
  }

  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  GeneratedTextColumn _token;
  @override
  GeneratedTextColumn get token => _token ??= _constructToken();
  GeneratedTextColumn _constructToken() {
    return GeneratedTextColumn(
      'token',
      $tableName,
      true,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      true,
    );
  }

  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  GeneratedTextColumn _avatar;
  @override
  GeneratedTextColumn get avatar => _avatar ??= _constructAvatar();
  GeneratedTextColumn _constructAvatar() {
    return GeneratedTextColumn(
      'avatar',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, username, token, email, avatar, createdAt, updatedAt];
  @override
  $UserTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'user_table';
  @override
  final String actualTableName = 'user_table';
  @override
  VerificationContext validateIntegrity(UserTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.username.present) {
      context.handle(_usernameMeta,
          username.isAcceptableValue(d.username.value, _usernameMeta));
    }
    if (d.token.present) {
      context.handle(
          _tokenMeta, token.isAcceptableValue(d.token.value, _tokenMeta));
    }
    if (d.email.present) {
      context.handle(
          _emailMeta, email.isAcceptableValue(d.email.value, _emailMeta));
    }
    if (d.avatar.present) {
      context.handle(
          _avatarMeta, avatar.isAcceptableValue(d.avatar.value, _avatarMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UserTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(UserTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<int, IntType>(d.userId.value);
    }
    if (d.username.present) {
      map['username'] = Variable<String, StringType>(d.username.value);
    }
    if (d.token.present) {
      map['token'] = Variable<String, StringType>(d.token.value);
    }
    if (d.email.present) {
      map['email'] = Variable<String, StringType>(d.email.value);
    }
    if (d.avatar.present) {
      map['avatar'] = Variable<String, StringType>(d.avatar.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(_db, alias);
  }
}

class BusinessTableData extends DataClass
    implements Insertable<BusinessTableData> {
  final int idLocal;
  final String id;
  final String name;
  final bool active;
  final String userId;
  final String typeId;
  final String categoryId;
  final String country;
  final String currency;
  final String timeZone;
  final double longitude;
  final double latitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  BusinessTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.name,
      @required this.active,
      @required this.userId,
      @required this.typeId,
      this.categoryId,
      this.country,
      this.currency,
      this.timeZone,
      this.longitude,
      this.latitude,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory BusinessTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BusinessTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      active:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}active']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      typeId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}type_id']),
      categoryId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      country:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}country']),
      currency: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}currency']),
      timeZone: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}time_zone']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory BusinessTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BusinessTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      active: serializer.fromJson<bool>(json['active']),
      userId: serializer.fromJson<String>(json['userId']),
      typeId: serializer.fromJson<String>(json['typeId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      country: serializer.fromJson<String>(json['country']),
      currency: serializer.fromJson<String>(json['currency']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      longitude: serializer.fromJson<double>(json['longitude']),
      latitude: serializer.fromJson<double>(json['latitude']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
      'userId': serializer.toJson<String>(userId),
      'typeId': serializer.toJson<String>(typeId),
      'categoryId': serializer.toJson<String>(categoryId),
      'country': serializer.toJson<String>(country),
      'currency': serializer.toJson<String>(currency),
      'timeZone': serializer.toJson<String>(timeZone),
      'longitude': serializer.toJson<double>(longitude),
      'latitude': serializer.toJson<double>(latitude),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  BusinessTableCompanion createCompanion(bool nullToAbsent) {
    return BusinessTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      active:
          active == null && nullToAbsent ? const Value.absent() : Value(active),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      typeId:
          typeId == null && nullToAbsent ? const Value.absent() : Value(typeId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      timeZone: timeZone == null && nullToAbsent
          ? const Value.absent()
          : Value(timeZone),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  BusinessTableData copyWith(
          {int idLocal,
          String id,
          String name,
          bool active,
          String userId,
          String typeId,
          String categoryId,
          String country,
          String currency,
          String timeZone,
          double longitude,
          double latitude,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      BusinessTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        name: name ?? this.name,
        active: active ?? this.active,
        userId: userId ?? this.userId,
        typeId: typeId ?? this.typeId,
        categoryId: categoryId ?? this.categoryId,
        country: country ?? this.country,
        currency: currency ?? this.currency,
        timeZone: timeZone ?? this.timeZone,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('BusinessTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('active: $active, ')
          ..write('userId: $userId, ')
          ..write('typeId: $typeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('country: $country, ')
          ..write('currency: $currency, ')
          ..write('timeZone: $timeZone, ')
          ..write('longitude: $longitude, ')
          ..write('latitude: $latitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  active.hashCode,
                  $mrjc(
                      userId.hashCode,
                      $mrjc(
                          typeId.hashCode,
                          $mrjc(
                              categoryId.hashCode,
                              $mrjc(
                                  country.hashCode,
                                  $mrjc(
                                      currency.hashCode,
                                      $mrjc(
                                          timeZone.hashCode,
                                          $mrjc(
                                              longitude.hashCode,
                                              $mrjc(
                                                  latitude.hashCode,
                                                  $mrjc(
                                                      createdAt.hashCode,
                                                      $mrjc(
                                                          updatedAt.hashCode,
                                                          deletedAt
                                                              .hashCode)))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BusinessTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.name == this.name &&
          other.active == this.active &&
          other.userId == this.userId &&
          other.typeId == this.typeId &&
          other.categoryId == this.categoryId &&
          other.country == this.country &&
          other.currency == this.currency &&
          other.timeZone == this.timeZone &&
          other.longitude == this.longitude &&
          other.latitude == this.latitude &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class BusinessTableCompanion extends UpdateCompanion<BusinessTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> name;
  final Value<bool> active;
  final Value<String> userId;
  final Value<String> typeId;
  final Value<String> categoryId;
  final Value<String> country;
  final Value<String> currency;
  final Value<String> timeZone;
  final Value<double> longitude;
  final Value<double> latitude;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const BusinessTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
    this.userId = const Value.absent(),
    this.typeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.longitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  BusinessTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String name,
    this.active = const Value.absent(),
    @required String userId,
    @required String typeId,
    this.categoryId = const Value.absent(),
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.longitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        userId = Value(userId),
        typeId = Value(typeId);
  BusinessTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<bool> active,
      Value<String> userId,
      Value<String> typeId,
      Value<String> categoryId,
      Value<String> country,
      Value<String> currency,
      Value<String> timeZone,
      Value<double> longitude,
      Value<double> latitude,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return BusinessTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      userId: userId ?? this.userId,
      typeId: typeId ?? this.typeId,
      categoryId: categoryId ?? this.categoryId,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $BusinessTableTable extends BusinessTable
    with TableInfo<$BusinessTableTable, BusinessTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BusinessTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _activeMeta = const VerificationMeta('active');
  GeneratedBoolColumn _active;
  @override
  GeneratedBoolColumn get active => _active ??= _constructActive();
  GeneratedBoolColumn _constructActive() {
    return GeneratedBoolColumn('active', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  GeneratedTextColumn _typeId;
  @override
  GeneratedTextColumn get typeId => _typeId ??= _constructTypeId();
  GeneratedTextColumn _constructTypeId() {
    return GeneratedTextColumn(
      'type_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedTextColumn _categoryId;
  @override
  GeneratedTextColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedTextColumn _constructCategoryId() {
    return GeneratedTextColumn(
      'category_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _countryMeta = const VerificationMeta('country');
  GeneratedTextColumn _country;
  @override
  GeneratedTextColumn get country => _country ??= _constructCountry();
  GeneratedTextColumn _constructCountry() {
    return GeneratedTextColumn(
      'country',
      $tableName,
      true,
    );
  }

  final VerificationMeta _currencyMeta = const VerificationMeta('currency');
  GeneratedTextColumn _currency;
  @override
  GeneratedTextColumn get currency => _currency ??= _constructCurrency();
  GeneratedTextColumn _constructCurrency() {
    return GeneratedTextColumn(
      'currency',
      $tableName,
      true,
    );
  }

  final VerificationMeta _timeZoneMeta = const VerificationMeta('timeZone');
  GeneratedTextColumn _timeZone;
  @override
  GeneratedTextColumn get timeZone => _timeZone ??= _constructTimeZone();
  GeneratedTextColumn _constructTimeZone() {
    return GeneratedTextColumn(
      'time_zone',
      $tableName,
      true,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  @override
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  @override
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        id,
        name,
        active,
        userId,
        typeId,
        categoryId,
        country,
        currency,
        timeZone,
        longitude,
        latitude,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $BusinessTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'business_table';
  @override
  final String actualTableName = 'business_table';
  @override
  VerificationContext validateIntegrity(BusinessTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.active.present) {
      context.handle(
          _activeMeta, active.isAcceptableValue(d.active.value, _activeMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.typeId.present) {
      context.handle(
          _typeIdMeta, typeId.isAcceptableValue(d.typeId.value, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    }
    if (d.country.present) {
      context.handle(_countryMeta,
          country.isAcceptableValue(d.country.value, _countryMeta));
    }
    if (d.currency.present) {
      context.handle(_currencyMeta,
          currency.isAcceptableValue(d.currency.value, _currencyMeta));
    }
    if (d.timeZone.present) {
      context.handle(_timeZoneMeta,
          timeZone.isAcceptableValue(d.timeZone.value, _timeZoneMeta));
    }
    if (d.longitude.present) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableValue(d.longitude.value, _longitudeMeta));
    }
    if (d.latitude.present) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableValue(d.latitude.value, _latitudeMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  BusinessTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BusinessTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BusinessTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.active.present) {
      map['active'] = Variable<bool, BoolType>(d.active.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.typeId.present) {
      map['type_id'] = Variable<String, StringType>(d.typeId.value);
    }
    if (d.categoryId.present) {
      map['category_id'] = Variable<String, StringType>(d.categoryId.value);
    }
    if (d.country.present) {
      map['country'] = Variable<String, StringType>(d.country.value);
    }
    if (d.currency.present) {
      map['currency'] = Variable<String, StringType>(d.currency.value);
    }
    if (d.timeZone.present) {
      map['time_zone'] = Variable<String, StringType>(d.timeZone.value);
    }
    if (d.longitude.present) {
      map['longitude'] = Variable<double, RealType>(d.longitude.value);
    }
    if (d.latitude.present) {
      map['latitude'] = Variable<double, RealType>(d.latitude.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $BusinessTableTable createAlias(String alias) {
    return $BusinessTableTable(_db, alias);
  }
}

class BranchTableData extends DataClass implements Insertable<BranchTableData> {
  final int id;
  final String name;
  final bool isActive;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  BranchTableData(
      {@required this.id,
      @required this.name,
      @required this.isActive,
      @required this.businessId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory BranchTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BranchTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isActive:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
      businessId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}business_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory BranchTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BranchTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      businessId: serializer.fromJson<String>(json['businessId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'businessId': serializer.toJson<String>(businessId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  BranchTableCompanion createCompanion(bool nullToAbsent) {
    return BranchTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
      businessId: businessId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  BranchTableData copyWith(
          {int id,
          String name,
          bool isActive,
          String businessId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      BranchTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        businessId: businessId ?? this.businessId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('BranchTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('businessId: $businessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              isActive.hashCode,
              $mrjc(
                  businessId.hashCode,
                  $mrjc(createdAt.hashCode,
                      $mrjc(updatedAt.hashCode, deletedAt.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BranchTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.businessId == this.businessId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class BranchTableCompanion extends UpdateCompanion<BranchTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<String> businessId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const BranchTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.businessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  BranchTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isActive = const Value.absent(),
    @required String businessId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : name = Value(name),
        businessId = Value(businessId);
  BranchTableCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<bool> isActive,
      Value<String> businessId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return BranchTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $BranchTableTable extends BranchTable
    with TableInfo<$BranchTableTable, BranchTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BranchTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  GeneratedBoolColumn _isActive;
  @override
  GeneratedBoolColumn get isActive => _isActive ??= _constructIsActive();
  GeneratedBoolColumn _constructIsActive() {
    return GeneratedBoolColumn('is_active', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _businessIdMeta = const VerificationMeta('businessId');
  GeneratedTextColumn _businessId;
  @override
  GeneratedTextColumn get businessId => _businessId ??= _constructBusinessId();
  GeneratedTextColumn _constructBusinessId() {
    return GeneratedTextColumn(
      'business_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isActive, businessId, createdAt, updatedAt, deletedAt];
  @override
  $BranchTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'branch_table';
  @override
  final String actualTableName = 'branch_table';
  @override
  VerificationContext validateIntegrity(BranchTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isActive.present) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableValue(d.isActive.value, _isActiveMeta));
    }
    if (d.businessId.present) {
      context.handle(_businessIdMeta,
          businessId.isAcceptableValue(d.businessId.value, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BranchTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BranchTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BranchTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.isActive.present) {
      map['is_active'] = Variable<bool, BoolType>(d.isActive.value);
    }
    if (d.businessId.present) {
      map['business_id'] = Variable<String, StringType>(d.businessId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $BranchTableTable createAlias(String alias) {
    return $BranchTableTable(_db, alias);
  }
}

class UnitTableData extends DataClass implements Insertable<UnitTableData> {
  final int id;
  final String name;
  final String value;
  final bool focused;
  final DateTime createdAt;
  final DateTime updatedAt;
  UnitTableData(
      {@required this.id,
      @required this.name,
      @required this.value,
      @required this.focused,
      this.createdAt,
      this.updatedAt});
  factory UnitTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return UnitTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      value:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      focused:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}focused']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory UnitTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UnitTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
      focused: serializer.fromJson<bool>(json['focused']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
      'focused': serializer.toJson<bool>(focused),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  UnitTableCompanion createCompanion(bool nullToAbsent) {
    return UnitTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      focused: focused == null && nullToAbsent
          ? const Value.absent()
          : Value(focused),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  UnitTableData copyWith(
          {int id,
          String name,
          String value,
          bool focused,
          DateTime createdAt,
          DateTime updatedAt}) =>
      UnitTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        focused: focused ?? this.focused,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('UnitTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('focused: $focused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              value.hashCode,
              $mrjc(focused.hashCode,
                  $mrjc(createdAt.hashCode, updatedAt.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UnitTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value &&
          other.focused == this.focused &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnitTableCompanion extends UpdateCompanion<UnitTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> value;
  final Value<bool> focused;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnitTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.focused = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnitTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String value,
    @required bool focused,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        value = Value(value),
        focused = Value(focused);
  UnitTableCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> value,
      Value<bool> focused,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return UnitTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      focused: focused ?? this.focused,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $UnitTableTable extends UnitTable
    with TableInfo<$UnitTableTable, UnitTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $UnitTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedTextColumn _value;
  @override
  GeneratedTextColumn get value => _value ??= _constructValue();
  GeneratedTextColumn _constructValue() {
    return GeneratedTextColumn(
      'value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _focusedMeta = const VerificationMeta('focused');
  GeneratedBoolColumn _focused;
  @override
  GeneratedBoolColumn get focused => _focused ??= _constructFocused();
  GeneratedBoolColumn _constructFocused() {
    return GeneratedBoolColumn(
      'focused',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, value, focused, createdAt, updatedAt];
  @override
  $UnitTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'unit_table';
  @override
  final String actualTableName = 'unit_table';
  @override
  VerificationContext validateIntegrity(UnitTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (d.focused.present) {
      context.handle(_focusedMeta,
          focused.isAcceptableValue(d.focused.value, _focusedMeta));
    } else if (isInserting) {
      context.missing(_focusedMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UnitTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(UnitTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.value.present) {
      map['value'] = Variable<String, StringType>(d.value.value);
    }
    if (d.focused.present) {
      map['focused'] = Variable<bool, BoolType>(d.focused.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $UnitTableTable createAlias(String alias) {
    return $UnitTableTable(_db, alias);
  }
}

class CategoryTableData extends DataClass
    implements Insertable<CategoryTableData> {
  final int idLocal;
  final bool focused;
  final String id;
  final String name;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  CategoryTableData(
      {@required this.idLocal,
      @required this.focused,
      @required this.id,
      @required this.name,
      @required this.branchId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory CategoryTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return CategoryTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      focused:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}focused']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory CategoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CategoryTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      focused: serializer.fromJson<bool>(json['focused']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      branchId: serializer.fromJson<String>(json['branchId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'focused': serializer.toJson<bool>(focused),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'branchId': serializer.toJson<String>(branchId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  CategoryTableCompanion createCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      focused: focused == null && nullToAbsent
          ? const Value.absent()
          : Value(focused),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  CategoryTableData copyWith(
          {int idLocal,
          bool focused,
          String id,
          String name,
          String branchId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      CategoryTableData(
        idLocal: idLocal ?? this.idLocal,
        focused: focused ?? this.focused,
        id: id ?? this.id,
        name: name ?? this.name,
        branchId: branchId ?? this.branchId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('focused: $focused, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchId: $branchId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          focused.hashCode,
          $mrjc(
              id.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      branchId.hashCode,
                      $mrjc(createdAt.hashCode,
                          $mrjc(updatedAt.hashCode, deletedAt.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CategoryTableData &&
          other.idLocal == this.idLocal &&
          other.focused == this.focused &&
          other.id == this.id &&
          other.name == this.name &&
          other.branchId == this.branchId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryTableData> {
  final Value<int> idLocal;
  final Value<bool> focused;
  final Value<String> id;
  final Value<String> name;
  final Value<String> branchId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const CategoryTableCompanion({
    this.idLocal = const Value.absent(),
    this.focused = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.branchId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required bool focused,
    @required String id,
    @required String name,
    @required String branchId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : focused = Value(focused),
        id = Value(id),
        name = Value(name),
        branchId = Value(branchId);
  CategoryTableCompanion copyWith(
      {Value<int> idLocal,
      Value<bool> focused,
      Value<String> id,
      Value<String> name,
      Value<String> branchId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return CategoryTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      focused: focused ?? this.focused,
      id: id ?? this.id,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, CategoryTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoryTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _focusedMeta = const VerificationMeta('focused');
  GeneratedBoolColumn _focused;
  @override
  GeneratedBoolColumn get focused => _focused ??= _constructFocused();
  GeneratedBoolColumn _constructFocused() {
    return GeneratedBoolColumn(
      'focused',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _branchIdMeta = const VerificationMeta('branchId');
  GeneratedTextColumn _branchId;
  @override
  GeneratedTextColumn get branchId => _branchId ??= _constructBranchId();
  GeneratedTextColumn _constructBranchId() {
    return GeneratedTextColumn(
      'branch_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [idLocal, focused, id, name, branchId, createdAt, updatedAt, deletedAt];
  @override
  $CategoryTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'category_table';
  @override
  final String actualTableName = 'category_table';
  @override
  VerificationContext validateIntegrity(CategoryTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.focused.present) {
      context.handle(_focusedMeta,
          focused.isAcceptableValue(d.focused.value, _focusedMeta));
    } else if (isInserting) {
      context.missing(_focusedMeta);
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.branchId.present) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableValue(d.branchId.value, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  CategoryTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CategoryTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CategoryTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.focused.present) {
      map['focused'] = Variable<bool, BoolType>(d.focused.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.branchId.present) {
      map['branch_id'] = Variable<String, StringType>(d.branchId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(_db, alias);
  }
}

class ProductTableData extends DataClass
    implements Insertable<ProductTableData> {
  final int idLocal;
  final String id;
  final String name;
  final String picture;
  final bool active;
  final bool hasPicture;
  final bool isDraft;
  final bool isCurrentUpdate;
  final String description;
  final String color;
  final String businessId;
  final String supplierId;
  final String categoryId;
  final String taxId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  ProductTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.name,
      @required this.picture,
      @required this.active,
      @required this.hasPicture,
      @required this.isDraft,
      @required this.isCurrentUpdate,
      this.description,
      this.color,
      @required this.businessId,
      @required this.supplierId,
      @required this.categoryId,
      @required this.taxId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory ProductTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ProductTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      picture:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}picture']),
      active:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}active']),
      hasPicture: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}has_picture']),
      isDraft:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_draft']),
      isCurrentUpdate: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_current_update']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      businessId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}business_id']),
      supplierId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}supplier_id']),
      categoryId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      taxId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}tax_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory ProductTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProductTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      picture: serializer.fromJson<String>(json['picture']),
      active: serializer.fromJson<bool>(json['active']),
      hasPicture: serializer.fromJson<bool>(json['hasPicture']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      isCurrentUpdate: serializer.fromJson<bool>(json['isCurrentUpdate']),
      description: serializer.fromJson<String>(json['description']),
      color: serializer.fromJson<String>(json['color']),
      businessId: serializer.fromJson<String>(json['businessId']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      taxId: serializer.fromJson<String>(json['taxId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'picture': serializer.toJson<String>(picture),
      'active': serializer.toJson<bool>(active),
      'hasPicture': serializer.toJson<bool>(hasPicture),
      'isDraft': serializer.toJson<bool>(isDraft),
      'isCurrentUpdate': serializer.toJson<bool>(isCurrentUpdate),
      'description': serializer.toJson<String>(description),
      'color': serializer.toJson<String>(color),
      'businessId': serializer.toJson<String>(businessId),
      'supplierId': serializer.toJson<String>(supplierId),
      'categoryId': serializer.toJson<String>(categoryId),
      'taxId': serializer.toJson<String>(taxId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  ProductTableCompanion createCompanion(bool nullToAbsent) {
    return ProductTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      active:
          active == null && nullToAbsent ? const Value.absent() : Value(active),
      hasPicture: hasPicture == null && nullToAbsent
          ? const Value.absent()
          : Value(hasPicture),
      isDraft: isDraft == null && nullToAbsent
          ? const Value.absent()
          : Value(isDraft),
      isCurrentUpdate: isCurrentUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(isCurrentUpdate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      businessId: businessId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      taxId:
          taxId == null && nullToAbsent ? const Value.absent() : Value(taxId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  ProductTableData copyWith(
          {int idLocal,
          String id,
          String name,
          String picture,
          bool active,
          bool hasPicture,
          bool isDraft,
          bool isCurrentUpdate,
          String description,
          String color,
          String businessId,
          String supplierId,
          String categoryId,
          String taxId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      ProductTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        name: name ?? this.name,
        picture: picture ?? this.picture,
        active: active ?? this.active,
        hasPicture: hasPicture ?? this.hasPicture,
        isDraft: isDraft ?? this.isDraft,
        isCurrentUpdate: isCurrentUpdate ?? this.isCurrentUpdate,
        description: description ?? this.description,
        color: color ?? this.color,
        businessId: businessId ?? this.businessId,
        supplierId: supplierId ?? this.supplierId,
        categoryId: categoryId ?? this.categoryId,
        taxId: taxId ?? this.taxId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ProductTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('picture: $picture, ')
          ..write('active: $active, ')
          ..write('hasPicture: $hasPicture, ')
          ..write('isDraft: $isDraft, ')
          ..write('isCurrentUpdate: $isCurrentUpdate, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('businessId: $businessId, ')
          ..write('supplierId: $supplierId, ')
          ..write('categoryId: $categoryId, ')
          ..write('taxId: $taxId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  picture.hashCode,
                  $mrjc(
                      active.hashCode,
                      $mrjc(
                          hasPicture.hashCode,
                          $mrjc(
                              isDraft.hashCode,
                              $mrjc(
                                  isCurrentUpdate.hashCode,
                                  $mrjc(
                                      description.hashCode,
                                      $mrjc(
                                          color.hashCode,
                                          $mrjc(
                                              businessId.hashCode,
                                              $mrjc(
                                                  supplierId.hashCode,
                                                  $mrjc(
                                                      categoryId.hashCode,
                                                      $mrjc(
                                                          taxId.hashCode,
                                                          $mrjc(
                                                              createdAt
                                                                  .hashCode,
                                                              $mrjc(
                                                                  updatedAt
                                                                      .hashCode,
                                                                  deletedAt
                                                                      .hashCode)))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ProductTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.name == this.name &&
          other.picture == this.picture &&
          other.active == this.active &&
          other.hasPicture == this.hasPicture &&
          other.isDraft == this.isDraft &&
          other.isCurrentUpdate == this.isCurrentUpdate &&
          other.description == this.description &&
          other.color == this.color &&
          other.businessId == this.businessId &&
          other.supplierId == this.supplierId &&
          other.categoryId == this.categoryId &&
          other.taxId == this.taxId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ProductTableCompanion extends UpdateCompanion<ProductTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> name;
  final Value<String> picture;
  final Value<bool> active;
  final Value<bool> hasPicture;
  final Value<bool> isDraft;
  final Value<bool> isCurrentUpdate;
  final Value<String> description;
  final Value<String> color;
  final Value<String> businessId;
  final Value<String> supplierId;
  final Value<String> categoryId;
  final Value<String> taxId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const ProductTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.picture = const Value.absent(),
    this.active = const Value.absent(),
    this.hasPicture = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.isCurrentUpdate = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.businessId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.taxId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ProductTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String name,
    @required String picture,
    @required bool active,
    @required bool hasPicture,
    @required bool isDraft,
    @required bool isCurrentUpdate,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    @required String businessId,
    @required String supplierId,
    @required String categoryId,
    @required String taxId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        picture = Value(picture),
        active = Value(active),
        hasPicture = Value(hasPicture),
        isDraft = Value(isDraft),
        isCurrentUpdate = Value(isCurrentUpdate),
        businessId = Value(businessId),
        supplierId = Value(supplierId),
        categoryId = Value(categoryId),
        taxId = Value(taxId);
  ProductTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<String> picture,
      Value<bool> active,
      Value<bool> hasPicture,
      Value<bool> isDraft,
      Value<bool> isCurrentUpdate,
      Value<String> description,
      Value<String> color,
      Value<String> businessId,
      Value<String> supplierId,
      Value<String> categoryId,
      Value<String> taxId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return ProductTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      active: active ?? this.active,
      hasPicture: hasPicture ?? this.hasPicture,
      isDraft: isDraft ?? this.isDraft,
      isCurrentUpdate: isCurrentUpdate ?? this.isCurrentUpdate,
      description: description ?? this.description,
      color: color ?? this.color,
      businessId: businessId ?? this.businessId,
      supplierId: supplierId ?? this.supplierId,
      categoryId: categoryId ?? this.categoryId,
      taxId: taxId ?? this.taxId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $ProductTableTable extends ProductTable
    with TableInfo<$ProductTableTable, ProductTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProductTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pictureMeta = const VerificationMeta('picture');
  GeneratedTextColumn _picture;
  @override
  GeneratedTextColumn get picture => _picture ??= _constructPicture();
  GeneratedTextColumn _constructPicture() {
    return GeneratedTextColumn(
      'picture',
      $tableName,
      false,
    );
  }

  final VerificationMeta _activeMeta = const VerificationMeta('active');
  GeneratedBoolColumn _active;
  @override
  GeneratedBoolColumn get active => _active ??= _constructActive();
  GeneratedBoolColumn _constructActive() {
    return GeneratedBoolColumn(
      'active',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hasPictureMeta = const VerificationMeta('hasPicture');
  GeneratedBoolColumn _hasPicture;
  @override
  GeneratedBoolColumn get hasPicture => _hasPicture ??= _constructHasPicture();
  GeneratedBoolColumn _constructHasPicture() {
    return GeneratedBoolColumn(
      'has_picture',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isDraftMeta = const VerificationMeta('isDraft');
  GeneratedBoolColumn _isDraft;
  @override
  GeneratedBoolColumn get isDraft => _isDraft ??= _constructIsDraft();
  GeneratedBoolColumn _constructIsDraft() {
    return GeneratedBoolColumn(
      'is_draft',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isCurrentUpdateMeta =
      const VerificationMeta('isCurrentUpdate');
  GeneratedBoolColumn _isCurrentUpdate;
  @override
  GeneratedBoolColumn get isCurrentUpdate =>
      _isCurrentUpdate ??= _constructIsCurrentUpdate();
  GeneratedBoolColumn _constructIsCurrentUpdate() {
    return GeneratedBoolColumn(
      'is_current_update',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedTextColumn _color;
  @override
  GeneratedTextColumn get color => _color ??= _constructColor();
  GeneratedTextColumn _constructColor() {
    return GeneratedTextColumn('color', $tableName, true,
        defaultValue: Constant("#03bafc"));
  }

  final VerificationMeta _businessIdMeta = const VerificationMeta('businessId');
  GeneratedTextColumn _businessId;
  @override
  GeneratedTextColumn get businessId => _businessId ??= _constructBusinessId();
  GeneratedTextColumn _constructBusinessId() {
    return GeneratedTextColumn(
      'business_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _supplierIdMeta = const VerificationMeta('supplierId');
  GeneratedTextColumn _supplierId;
  @override
  GeneratedTextColumn get supplierId => _supplierId ??= _constructSupplierId();
  GeneratedTextColumn _constructSupplierId() {
    return GeneratedTextColumn(
      'supplier_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedTextColumn _categoryId;
  @override
  GeneratedTextColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedTextColumn _constructCategoryId() {
    return GeneratedTextColumn(
      'category_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _taxIdMeta = const VerificationMeta('taxId');
  GeneratedTextColumn _taxId;
  @override
  GeneratedTextColumn get taxId => _taxId ??= _constructTaxId();
  GeneratedTextColumn _constructTaxId() {
    return GeneratedTextColumn(
      'tax_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        id,
        name,
        picture,
        active,
        hasPicture,
        isDraft,
        isCurrentUpdate,
        description,
        color,
        businessId,
        supplierId,
        categoryId,
        taxId,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $ProductTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'product_table';
  @override
  final String actualTableName = 'product_table';
  @override
  VerificationContext validateIntegrity(ProductTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.picture.present) {
      context.handle(_pictureMeta,
          picture.isAcceptableValue(d.picture.value, _pictureMeta));
    } else if (isInserting) {
      context.missing(_pictureMeta);
    }
    if (d.active.present) {
      context.handle(
          _activeMeta, active.isAcceptableValue(d.active.value, _activeMeta));
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (d.hasPicture.present) {
      context.handle(_hasPictureMeta,
          hasPicture.isAcceptableValue(d.hasPicture.value, _hasPictureMeta));
    } else if (isInserting) {
      context.missing(_hasPictureMeta);
    }
    if (d.isDraft.present) {
      context.handle(_isDraftMeta,
          isDraft.isAcceptableValue(d.isDraft.value, _isDraftMeta));
    } else if (isInserting) {
      context.missing(_isDraftMeta);
    }
    if (d.isCurrentUpdate.present) {
      context.handle(
          _isCurrentUpdateMeta,
          isCurrentUpdate.isAcceptableValue(
              d.isCurrentUpdate.value, _isCurrentUpdateMeta));
    } else if (isInserting) {
      context.missing(_isCurrentUpdateMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    }
    if (d.color.present) {
      context.handle(
          _colorMeta, color.isAcceptableValue(d.color.value, _colorMeta));
    }
    if (d.businessId.present) {
      context.handle(_businessIdMeta,
          businessId.isAcceptableValue(d.businessId.value, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (d.supplierId.present) {
      context.handle(_supplierIdMeta,
          supplierId.isAcceptableValue(d.supplierId.value, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (d.taxId.present) {
      context.handle(
          _taxIdMeta, taxId.isAcceptableValue(d.taxId.value, _taxIdMeta));
    } else if (isInserting) {
      context.missing(_taxIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  ProductTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ProductTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ProductTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.picture.present) {
      map['picture'] = Variable<String, StringType>(d.picture.value);
    }
    if (d.active.present) {
      map['active'] = Variable<bool, BoolType>(d.active.value);
    }
    if (d.hasPicture.present) {
      map['has_picture'] = Variable<bool, BoolType>(d.hasPicture.value);
    }
    if (d.isDraft.present) {
      map['is_draft'] = Variable<bool, BoolType>(d.isDraft.value);
    }
    if (d.isCurrentUpdate.present) {
      map['is_current_update'] =
          Variable<bool, BoolType>(d.isCurrentUpdate.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    if (d.color.present) {
      map['color'] = Variable<String, StringType>(d.color.value);
    }
    if (d.businessId.present) {
      map['business_id'] = Variable<String, StringType>(d.businessId.value);
    }
    if (d.supplierId.present) {
      map['supplier_id'] = Variable<String, StringType>(d.supplierId.value);
    }
    if (d.categoryId.present) {
      map['category_id'] = Variable<String, StringType>(d.categoryId.value);
    }
    if (d.taxId.present) {
      map['tax_id'] = Variable<String, StringType>(d.taxId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $ProductTableTable createAlias(String alias) {
    return $ProductTableTable(_db, alias);
  }
}

class TokenTableData extends DataClass implements Insertable<TokenTableData> {
  final int id;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;
  TokenTableData(
      {@required this.id,
      @required this.token,
      this.createdAt,
      this.updatedAt});
  factory TokenTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TokenTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory TokenTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TokenTableData(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  TokenTableCompanion createCompanion(bool nullToAbsent) {
    return TokenTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  TokenTableData copyWith(
          {int id, String token, DateTime createdAt, DateTime updatedAt}) =>
      TokenTableData(
        id: id ?? this.id,
        token: token ?? this.token,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TokenTableData(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(token.hashCode, $mrjc(createdAt.hashCode, updatedAt.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TokenTableData &&
          other.id == this.id &&
          other.token == this.token &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TokenTableCompanion extends UpdateCompanion<TokenTableData> {
  final Value<int> id;
  final Value<String> token;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TokenTableCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TokenTableCompanion.insert({
    this.id = const Value.absent(),
    @required String token,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : token = Value(token);
  TokenTableCompanion copyWith(
      {Value<int> id,
      Value<String> token,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return TokenTableCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $TokenTableTable extends TokenTable
    with TableInfo<$TokenTableTable, TokenTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $TokenTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  GeneratedTextColumn _token;
  @override
  GeneratedTextColumn get token => _token ??= _constructToken();
  GeneratedTextColumn _constructToken() {
    return GeneratedTextColumn(
      'token',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, token, createdAt, updatedAt];
  @override
  $TokenTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'token_table';
  @override
  final String actualTableName = 'token_table';
  @override
  VerificationContext validateIntegrity(TokenTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.token.present) {
      context.handle(
          _tokenMeta, token.isAcceptableValue(d.token.value, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TokenTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TokenTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TokenTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.token.present) {
      map['token'] = Variable<String, StringType>(d.token.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $TokenTableTable createAlias(String alias) {
    return $TokenTableTable(_db, alias);
  }
}

class BusinessUserTableData extends DataClass
    implements Insertable<BusinessUserTableData> {
  final int id;
  final String userId;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;
  BusinessUserTableData(
      {@required this.id,
      this.userId,
      this.businessId,
      this.createdAt,
      this.updatedAt});
  factory BusinessUserTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BusinessUserTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      businessId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}business_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory BusinessUserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BusinessUserTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      businessId: serializer.fromJson<String>(json['businessId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'businessId': serializer.toJson<String>(businessId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  BusinessUserTableCompanion createCompanion(bool nullToAbsent) {
    return BusinessUserTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      businessId: businessId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  BusinessUserTableData copyWith(
          {int id,
          String userId,
          String businessId,
          DateTime createdAt,
          DateTime updatedAt}) =>
      BusinessUserTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        businessId: businessId ?? this.businessId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('BusinessUserTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('businessId: $businessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(businessId.hashCode,
              $mrjc(createdAt.hashCode, updatedAt.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BusinessUserTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.businessId == this.businessId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BusinessUserTableCompanion
    extends UpdateCompanion<BusinessUserTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> businessId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BusinessUserTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.businessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BusinessUserTableCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.businessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BusinessUserTableCompanion copyWith(
      {Value<int> id,
      Value<String> userId,
      Value<String> businessId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return BusinessUserTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $BusinessUserTableTable extends BusinessUserTable
    with TableInfo<$BusinessUserTableTable, BusinessUserTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BusinessUserTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _businessIdMeta = const VerificationMeta('businessId');
  GeneratedTextColumn _businessId;
  @override
  GeneratedTextColumn get businessId => _businessId ??= _constructBusinessId();
  GeneratedTextColumn _constructBusinessId() {
    return GeneratedTextColumn(
      'business_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, businessId, createdAt, updatedAt];
  @override
  $BusinessUserTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'business_user_table';
  @override
  final String actualTableName = 'business_user_table';
  @override
  VerificationContext validateIntegrity(BusinessUserTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    }
    if (d.businessId.present) {
      context.handle(_businessIdMeta,
          businessId.isAcceptableValue(d.businessId.value, _businessIdMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessUserTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BusinessUserTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BusinessUserTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.businessId.present) {
      map['business_id'] = Variable<String, StringType>(d.businessId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $BusinessUserTableTable createAlias(String alias) {
    return $BusinessUserTableTable(_db, alias);
  }
}

class TabsTableData extends DataClass implements Insertable<TabsTableData> {
  final int id;
  final int tab;
  final DateTime createdAt;
  final DateTime updatedAt;
  TabsTableData({@required this.id, this.tab, this.createdAt, this.updatedAt});
  factory TabsTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TabsTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tab: intType.mapFromDatabaseResponse(data['${effectivePrefix}tab']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory TabsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TabsTableData(
      id: serializer.fromJson<int>(json['id']),
      tab: serializer.fromJson<int>(json['tab']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tab': serializer.toJson<int>(tab),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  TabsTableCompanion createCompanion(bool nullToAbsent) {
    return TabsTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tab: tab == null && nullToAbsent ? const Value.absent() : Value(tab),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  TabsTableData copyWith(
          {int id, int tab, DateTime createdAt, DateTime updatedAt}) =>
      TabsTableData(
        id: id ?? this.id,
        tab: tab ?? this.tab,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TabsTableData(')
          ..write('id: $id, ')
          ..write('tab: $tab, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(tab.hashCode, $mrjc(createdAt.hashCode, updatedAt.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TabsTableData &&
          other.id == this.id &&
          other.tab == this.tab &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TabsTableCompanion extends UpdateCompanion<TabsTableData> {
  final Value<int> id;
  final Value<int> tab;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TabsTableCompanion({
    this.id = const Value.absent(),
    this.tab = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TabsTableCompanion.insert({
    this.id = const Value.absent(),
    this.tab = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TabsTableCompanion copyWith(
      {Value<int> id,
      Value<int> tab,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return TabsTableCompanion(
      id: id ?? this.id,
      tab: tab ?? this.tab,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $TabsTableTable extends TabsTable
    with TableInfo<$TabsTableTable, TabsTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $TabsTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tabMeta = const VerificationMeta('tab');
  GeneratedIntColumn _tab;
  @override
  GeneratedIntColumn get tab => _tab ??= _constructTab();
  GeneratedIntColumn _constructTab() {
    return GeneratedIntColumn(
      'tab',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, tab, createdAt, updatedAt];
  @override
  $TabsTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tabs_table';
  @override
  final String actualTableName = 'tabs_table';
  @override
  VerificationContext validateIntegrity(TabsTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.tab.present) {
      context.handle(_tabMeta, tab.isAcceptableValue(d.tab.value, _tabMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TabsTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TabsTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TabsTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.tab.present) {
      map['tab'] = Variable<int, IntType>(d.tab.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $TabsTableTable createAlias(String alias) {
    return $TabsTableTable(_db, alias);
  }
}

class VariationTableData extends DataClass
    implements Insertable<VariationTableData> {
  final int idLocal;
  final String id;
  final String name;
  final String sku;
  final String unit;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  VariationTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.name,
      this.sku,
      this.unit,
      @required this.productId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory VariationTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return VariationTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      sku: stringType.mapFromDatabaseResponse(data['${effectivePrefix}sku']),
      unit: stringType.mapFromDatabaseResponse(data['${effectivePrefix}unit']),
      productId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory VariationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return VariationTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String>(json['sku']),
      unit: serializer.fromJson<String>(json['unit']),
      productId: serializer.fromJson<String>(json['productId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String>(sku),
      'unit': serializer.toJson<String>(unit),
      'productId': serializer.toJson<String>(productId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  VariationTableCompanion createCompanion(bool nullToAbsent) {
    return VariationTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  VariationTableData copyWith(
          {int idLocal,
          String id,
          String name,
          String sku,
          String unit,
          String productId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      VariationTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        name: name ?? this.name,
        sku: sku ?? this.sku,
        unit: unit ?? this.unit,
        productId: productId ?? this.productId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('VariationTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('unit: $unit, ')
          ..write('productId: $productId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  sku.hashCode,
                  $mrjc(
                      unit.hashCode,
                      $mrjc(
                          productId.hashCode,
                          $mrjc(
                              createdAt.hashCode,
                              $mrjc(updatedAt.hashCode,
                                  deletedAt.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is VariationTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.unit == this.unit &&
          other.productId == this.productId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class VariationTableCompanion extends UpdateCompanion<VariationTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> name;
  final Value<String> sku;
  final Value<String> unit;
  final Value<String> productId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const VariationTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.unit = const Value.absent(),
    this.productId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  VariationTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String name,
    this.sku = const Value.absent(),
    this.unit = const Value.absent(),
    @required String productId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        productId = Value(productId);
  VariationTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<String> sku,
      Value<String> unit,
      Value<String> productId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return VariationTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      unit: unit ?? this.unit,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $VariationTableTable extends VariationTable
    with TableInfo<$VariationTableTable, VariationTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $VariationTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _skuMeta = const VerificationMeta('sku');
  GeneratedTextColumn _sku;
  @override
  GeneratedTextColumn get sku => _sku ??= _constructSku();
  GeneratedTextColumn _constructSku() {
    return GeneratedTextColumn(
      'sku',
      $tableName,
      true,
    );
  }

  final VerificationMeta _unitMeta = const VerificationMeta('unit');
  GeneratedTextColumn _unit;
  @override
  GeneratedTextColumn get unit => _unit ??= _constructUnit();
  GeneratedTextColumn _constructUnit() {
    return GeneratedTextColumn(
      'unit',
      $tableName,
      true,
    );
  }

  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  GeneratedTextColumn _productId;
  @override
  GeneratedTextColumn get productId => _productId ??= _constructProductId();
  GeneratedTextColumn _constructProductId() {
    return GeneratedTextColumn(
      'product_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        id,
        name,
        sku,
        unit,
        productId,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $VariationTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'variation_table';
  @override
  final String actualTableName = 'variation_table';
  @override
  VerificationContext validateIntegrity(VariationTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.sku.present) {
      context.handle(_skuMeta, sku.isAcceptableValue(d.sku.value, _skuMeta));
    }
    if (d.unit.present) {
      context.handle(
          _unitMeta, unit.isAcceptableValue(d.unit.value, _unitMeta));
    }
    if (d.productId.present) {
      context.handle(_productIdMeta,
          productId.isAcceptableValue(d.productId.value, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  VariationTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return VariationTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(VariationTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.sku.present) {
      map['sku'] = Variable<String, StringType>(d.sku.value);
    }
    if (d.unit.present) {
      map['unit'] = Variable<String, StringType>(d.unit.value);
    }
    if (d.productId.present) {
      map['product_id'] = Variable<String, StringType>(d.productId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $VariationTableTable createAlias(String alias) {
    return $VariationTableTable(_db, alias);
  }
}

class StockTableData extends DataClass implements Insertable<StockTableData> {
  final int idLocal;
  final String id;
  final int currentStock;
  final int lowStock;
  final bool canTrackingStock;
  final bool showLowStockAlert;
  final bool isActive;
  final double supplyPrice;
  final double retailPrice;
  final String variantId;
  final String branchId;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  StockTableData(
      {@required this.idLocal,
      @required this.id,
      this.currentStock,
      this.lowStock,
      @required this.canTrackingStock,
      @required this.showLowStockAlert,
      this.isActive,
      this.supplyPrice,
      this.retailPrice,
      @required this.variantId,
      @required this.branchId,
      @required this.productId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory StockTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return StockTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      currentStock: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}current_stock']),
      lowStock:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}low_stock']),
      canTrackingStock: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}can_tracking_stock']),
      showLowStockAlert: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}show_low_stock_alert']),
      isActive:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
      supplyPrice: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}supply_price']),
      retailPrice: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}retail_price']),
      variantId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variant_id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      productId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory StockTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return StockTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      currentStock: serializer.fromJson<int>(json['currentStock']),
      lowStock: serializer.fromJson<int>(json['lowStock']),
      canTrackingStock: serializer.fromJson<bool>(json['canTrackingStock']),
      showLowStockAlert: serializer.fromJson<bool>(json['showLowStockAlert']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      supplyPrice: serializer.fromJson<double>(json['supplyPrice']),
      retailPrice: serializer.fromJson<double>(json['retailPrice']),
      variantId: serializer.fromJson<String>(json['variantId']),
      branchId: serializer.fromJson<String>(json['branchId']),
      productId: serializer.fromJson<String>(json['productId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'currentStock': serializer.toJson<int>(currentStock),
      'lowStock': serializer.toJson<int>(lowStock),
      'canTrackingStock': serializer.toJson<bool>(canTrackingStock),
      'showLowStockAlert': serializer.toJson<bool>(showLowStockAlert),
      'isActive': serializer.toJson<bool>(isActive),
      'supplyPrice': serializer.toJson<double>(supplyPrice),
      'retailPrice': serializer.toJson<double>(retailPrice),
      'variantId': serializer.toJson<String>(variantId),
      'branchId': serializer.toJson<String>(branchId),
      'productId': serializer.toJson<String>(productId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  StockTableCompanion createCompanion(bool nullToAbsent) {
    return StockTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      currentStock: currentStock == null && nullToAbsent
          ? const Value.absent()
          : Value(currentStock),
      lowStock: lowStock == null && nullToAbsent
          ? const Value.absent()
          : Value(lowStock),
      canTrackingStock: canTrackingStock == null && nullToAbsent
          ? const Value.absent()
          : Value(canTrackingStock),
      showLowStockAlert: showLowStockAlert == null && nullToAbsent
          ? const Value.absent()
          : Value(showLowStockAlert),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
      supplyPrice: supplyPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(supplyPrice),
      retailPrice: retailPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(retailPrice),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  StockTableData copyWith(
          {int idLocal,
          String id,
          int currentStock,
          int lowStock,
          bool canTrackingStock,
          bool showLowStockAlert,
          bool isActive,
          double supplyPrice,
          double retailPrice,
          String variantId,
          String branchId,
          String productId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      StockTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        currentStock: currentStock ?? this.currentStock,
        lowStock: lowStock ?? this.lowStock,
        canTrackingStock: canTrackingStock ?? this.canTrackingStock,
        showLowStockAlert: showLowStockAlert ?? this.showLowStockAlert,
        isActive: isActive ?? this.isActive,
        supplyPrice: supplyPrice ?? this.supplyPrice,
        retailPrice: retailPrice ?? this.retailPrice,
        variantId: variantId ?? this.variantId,
        branchId: branchId ?? this.branchId,
        productId: productId ?? this.productId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('StockTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('currentStock: $currentStock, ')
          ..write('lowStock: $lowStock, ')
          ..write('canTrackingStock: $canTrackingStock, ')
          ..write('showLowStockAlert: $showLowStockAlert, ')
          ..write('isActive: $isActive, ')
          ..write('supplyPrice: $supplyPrice, ')
          ..write('retailPrice: $retailPrice, ')
          ..write('variantId: $variantId, ')
          ..write('branchId: $branchId, ')
          ..write('productId: $productId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              currentStock.hashCode,
              $mrjc(
                  lowStock.hashCode,
                  $mrjc(
                      canTrackingStock.hashCode,
                      $mrjc(
                          showLowStockAlert.hashCode,
                          $mrjc(
                              isActive.hashCode,
                              $mrjc(
                                  supplyPrice.hashCode,
                                  $mrjc(
                                      retailPrice.hashCode,
                                      $mrjc(
                                          variantId.hashCode,
                                          $mrjc(
                                              branchId.hashCode,
                                              $mrjc(
                                                  productId.hashCode,
                                                  $mrjc(
                                                      createdAt.hashCode,
                                                      $mrjc(
                                                          updatedAt.hashCode,
                                                          deletedAt
                                                              .hashCode)))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is StockTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.currentStock == this.currentStock &&
          other.lowStock == this.lowStock &&
          other.canTrackingStock == this.canTrackingStock &&
          other.showLowStockAlert == this.showLowStockAlert &&
          other.isActive == this.isActive &&
          other.supplyPrice == this.supplyPrice &&
          other.retailPrice == this.retailPrice &&
          other.variantId == this.variantId &&
          other.branchId == this.branchId &&
          other.productId == this.productId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class StockTableCompanion extends UpdateCompanion<StockTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<int> currentStock;
  final Value<int> lowStock;
  final Value<bool> canTrackingStock;
  final Value<bool> showLowStockAlert;
  final Value<bool> isActive;
  final Value<double> supplyPrice;
  final Value<double> retailPrice;
  final Value<String> variantId;
  final Value<String> branchId;
  final Value<String> productId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const StockTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.lowStock = const Value.absent(),
    this.canTrackingStock = const Value.absent(),
    this.showLowStockAlert = const Value.absent(),
    this.isActive = const Value.absent(),
    this.supplyPrice = const Value.absent(),
    this.retailPrice = const Value.absent(),
    this.variantId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.productId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  StockTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    this.currentStock = const Value.absent(),
    this.lowStock = const Value.absent(),
    this.canTrackingStock = const Value.absent(),
    this.showLowStockAlert = const Value.absent(),
    this.isActive = const Value.absent(),
    this.supplyPrice = const Value.absent(),
    this.retailPrice = const Value.absent(),
    @required String variantId,
    @required String branchId,
    @required String productId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        variantId = Value(variantId),
        branchId = Value(branchId),
        productId = Value(productId);
  StockTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<int> currentStock,
      Value<int> lowStock,
      Value<bool> canTrackingStock,
      Value<bool> showLowStockAlert,
      Value<bool> isActive,
      Value<double> supplyPrice,
      Value<double> retailPrice,
      Value<String> variantId,
      Value<String> branchId,
      Value<String> productId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return StockTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      currentStock: currentStock ?? this.currentStock,
      lowStock: lowStock ?? this.lowStock,
      canTrackingStock: canTrackingStock ?? this.canTrackingStock,
      showLowStockAlert: showLowStockAlert ?? this.showLowStockAlert,
      isActive: isActive ?? this.isActive,
      supplyPrice: supplyPrice ?? this.supplyPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      variantId: variantId ?? this.variantId,
      branchId: branchId ?? this.branchId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $StockTableTable extends StockTable
    with TableInfo<$StockTableTable, StockTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $StockTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  GeneratedIntColumn _currentStock;
  @override
  GeneratedIntColumn get currentStock =>
      _currentStock ??= _constructCurrentStock();
  GeneratedIntColumn _constructCurrentStock() {
    return GeneratedIntColumn('current_stock', $tableName, true,
        defaultValue: Constant(0));
  }

  final VerificationMeta _lowStockMeta = const VerificationMeta('lowStock');
  GeneratedIntColumn _lowStock;
  @override
  GeneratedIntColumn get lowStock => _lowStock ??= _constructLowStock();
  GeneratedIntColumn _constructLowStock() {
    return GeneratedIntColumn('low_stock', $tableName, true,
        defaultValue: Constant(0));
  }

  final VerificationMeta _canTrackingStockMeta =
      const VerificationMeta('canTrackingStock');
  GeneratedBoolColumn _canTrackingStock;
  @override
  GeneratedBoolColumn get canTrackingStock =>
      _canTrackingStock ??= _constructCanTrackingStock();
  GeneratedBoolColumn _constructCanTrackingStock() {
    return GeneratedBoolColumn('can_tracking_stock', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _showLowStockAlertMeta =
      const VerificationMeta('showLowStockAlert');
  GeneratedBoolColumn _showLowStockAlert;
  @override
  GeneratedBoolColumn get showLowStockAlert =>
      _showLowStockAlert ??= _constructShowLowStockAlert();
  GeneratedBoolColumn _constructShowLowStockAlert() {
    return GeneratedBoolColumn('show_low_stock_alert', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  GeneratedBoolColumn _isActive;
  @override
  GeneratedBoolColumn get isActive => _isActive ??= _constructIsActive();
  GeneratedBoolColumn _constructIsActive() {
    return GeneratedBoolColumn('is_active', $tableName, true,
        defaultValue: Constant(false));
  }

  final VerificationMeta _supplyPriceMeta =
      const VerificationMeta('supplyPrice');
  GeneratedRealColumn _supplyPrice;
  @override
  GeneratedRealColumn get supplyPrice =>
      _supplyPrice ??= _constructSupplyPrice();
  GeneratedRealColumn _constructSupplyPrice() {
    return GeneratedRealColumn('supply_price', $tableName, true,
        $customConstraints: 'DECIMAL(6,2)', defaultValue: Constant(0));
  }

  final VerificationMeta _retailPriceMeta =
      const VerificationMeta('retailPrice');
  GeneratedRealColumn _retailPrice;
  @override
  GeneratedRealColumn get retailPrice =>
      _retailPrice ??= _constructRetailPrice();
  GeneratedRealColumn _constructRetailPrice() {
    return GeneratedRealColumn('retail_price', $tableName, true,
        $customConstraints: 'DECIMAL(6,2)', defaultValue: Constant(0));
  }

  final VerificationMeta _variantIdMeta = const VerificationMeta('variantId');
  GeneratedTextColumn _variantId;
  @override
  GeneratedTextColumn get variantId => _variantId ??= _constructVariantId();
  GeneratedTextColumn _constructVariantId() {
    return GeneratedTextColumn(
      'variant_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _branchIdMeta = const VerificationMeta('branchId');
  GeneratedTextColumn _branchId;
  @override
  GeneratedTextColumn get branchId => _branchId ??= _constructBranchId();
  GeneratedTextColumn _constructBranchId() {
    return GeneratedTextColumn(
      'branch_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  GeneratedTextColumn _productId;
  @override
  GeneratedTextColumn get productId => _productId ??= _constructProductId();
  GeneratedTextColumn _constructProductId() {
    return GeneratedTextColumn(
      'product_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        id,
        currentStock,
        lowStock,
        canTrackingStock,
        showLowStockAlert,
        isActive,
        supplyPrice,
        retailPrice,
        variantId,
        branchId,
        productId,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $StockTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'stock_table';
  @override
  final String actualTableName = 'stock_table';
  @override
  VerificationContext validateIntegrity(StockTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.currentStock.present) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableValue(
              d.currentStock.value, _currentStockMeta));
    }
    if (d.lowStock.present) {
      context.handle(_lowStockMeta,
          lowStock.isAcceptableValue(d.lowStock.value, _lowStockMeta));
    }
    if (d.canTrackingStock.present) {
      context.handle(
          _canTrackingStockMeta,
          canTrackingStock.isAcceptableValue(
              d.canTrackingStock.value, _canTrackingStockMeta));
    }
    if (d.showLowStockAlert.present) {
      context.handle(
          _showLowStockAlertMeta,
          showLowStockAlert.isAcceptableValue(
              d.showLowStockAlert.value, _showLowStockAlertMeta));
    }
    if (d.isActive.present) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableValue(d.isActive.value, _isActiveMeta));
    }
    if (d.supplyPrice.present) {
      context.handle(_supplyPriceMeta,
          supplyPrice.isAcceptableValue(d.supplyPrice.value, _supplyPriceMeta));
    }
    if (d.retailPrice.present) {
      context.handle(_retailPriceMeta,
          retailPrice.isAcceptableValue(d.retailPrice.value, _retailPriceMeta));
    }
    if (d.variantId.present) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableValue(d.variantId.value, _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (d.branchId.present) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableValue(d.branchId.value, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (d.productId.present) {
      context.handle(_productIdMeta,
          productId.isAcceptableValue(d.productId.value, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  StockTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return StockTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(StockTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.currentStock.present) {
      map['current_stock'] = Variable<int, IntType>(d.currentStock.value);
    }
    if (d.lowStock.present) {
      map['low_stock'] = Variable<int, IntType>(d.lowStock.value);
    }
    if (d.canTrackingStock.present) {
      map['can_tracking_stock'] =
          Variable<bool, BoolType>(d.canTrackingStock.value);
    }
    if (d.showLowStockAlert.present) {
      map['show_low_stock_alert'] =
          Variable<bool, BoolType>(d.showLowStockAlert.value);
    }
    if (d.isActive.present) {
      map['is_active'] = Variable<bool, BoolType>(d.isActive.value);
    }
    if (d.supplyPrice.present) {
      map['supply_price'] = Variable<double, RealType>(d.supplyPrice.value);
    }
    if (d.retailPrice.present) {
      map['retail_price'] = Variable<double, RealType>(d.retailPrice.value);
    }
    if (d.variantId.present) {
      map['variant_id'] = Variable<String, StringType>(d.variantId.value);
    }
    if (d.branchId.present) {
      map['branch_id'] = Variable<String, StringType>(d.branchId.value);
    }
    if (d.productId.present) {
      map['product_id'] = Variable<String, StringType>(d.productId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $StockTableTable createAlias(String alias) {
    return $StockTableTable(_db, alias);
  }
}

class PriceTableData extends DataClass implements Insertable<PriceTableData> {
  final int id;
  final String value;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  PriceTableData(
      {@required this.id,
      @required this.value,
      this.categoryId,
      this.createdAt,
      this.updatedAt});
  factory PriceTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PriceTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      value:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory PriceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PriceTableData(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<String>(json['value']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<String>(value),
      'categoryId': serializer.toJson<int>(categoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  PriceTableCompanion createCompanion(bool nullToAbsent) {
    return PriceTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  PriceTableData copyWith(
          {int id,
          String value,
          int categoryId,
          DateTime createdAt,
          DateTime updatedAt}) =>
      PriceTableData(
        id: id ?? this.id,
        value: value ?? this.value,
        categoryId: categoryId ?? this.categoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('PriceTableData(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          value.hashCode,
          $mrjc(categoryId.hashCode,
              $mrjc(createdAt.hashCode, updatedAt.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PriceTableData &&
          other.id == this.id &&
          other.value == this.value &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PriceTableCompanion extends UpdateCompanion<PriceTableData> {
  final Value<int> id;
  final Value<String> value;
  final Value<int> categoryId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PriceTableCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PriceTableCompanion.insert({
    this.id = const Value.absent(),
    @required String value,
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : value = Value(value);
  PriceTableCompanion copyWith(
      {Value<int> id,
      Value<String> value,
      Value<int> categoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return PriceTableCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $PriceTableTable extends PriceTable
    with TableInfo<$PriceTableTable, PriceTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PriceTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedTextColumn _value;
  @override
  GeneratedTextColumn get value => _value ??= _constructValue();
  GeneratedTextColumn _constructValue() {
    return GeneratedTextColumn(
      'value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn(
      'category_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, value, categoryId, createdAt, updatedAt];
  @override
  $PriceTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'price_table';
  @override
  final String actualTableName = 'price_table';
  @override
  VerificationContext validateIntegrity(PriceTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PriceTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(PriceTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.value.present) {
      map['value'] = Variable<String, StringType>(d.value.value);
    }
    if (d.categoryId.present) {
      map['category_id'] = Variable<int, IntType>(d.categoryId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $PriceTableTable createAlias(String alias) {
    return $PriceTableTable(_db, alias);
  }
}

class StockHistoryTableData extends DataClass
    implements Insertable<StockHistoryTableData> {
  final int idLocal;
  final int quantity;
  final String note;
  final String id;
  final String reason;
  final String stockId;
  final String variantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  StockHistoryTableData(
      {@required this.idLocal,
      @required this.quantity,
      @required this.note,
      @required this.id,
      @required this.reason,
      @required this.stockId,
      @required this.variantId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory StockHistoryTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return StockHistoryTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      quantity:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}quantity']),
      note: stringType.mapFromDatabaseResponse(data['${effectivePrefix}note']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      reason:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}reason']),
      stockId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}stock_id']),
      variantId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variant_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory StockHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return StockHistoryTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      quantity: serializer.fromJson<int>(json['quantity']),
      note: serializer.fromJson<String>(json['note']),
      id: serializer.fromJson<String>(json['id']),
      reason: serializer.fromJson<String>(json['reason']),
      stockId: serializer.fromJson<String>(json['stockId']),
      variantId: serializer.fromJson<String>(json['variantId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'quantity': serializer.toJson<int>(quantity),
      'note': serializer.toJson<String>(note),
      'id': serializer.toJson<String>(id),
      'reason': serializer.toJson<String>(reason),
      'stockId': serializer.toJson<String>(stockId),
      'variantId': serializer.toJson<String>(variantId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  StockHistoryTableCompanion createCompanion(bool nullToAbsent) {
    return StockHistoryTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      stockId: stockId == null && nullToAbsent
          ? const Value.absent()
          : Value(stockId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  StockHistoryTableData copyWith(
          {int idLocal,
          int quantity,
          String note,
          String id,
          String reason,
          String stockId,
          String variantId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      StockHistoryTableData(
        idLocal: idLocal ?? this.idLocal,
        quantity: quantity ?? this.quantity,
        note: note ?? this.note,
        id: id ?? this.id,
        reason: reason ?? this.reason,
        stockId: stockId ?? this.stockId,
        variantId: variantId ?? this.variantId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('StockHistoryTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('id: $id, ')
          ..write('reason: $reason, ')
          ..write('stockId: $stockId, ')
          ..write('variantId: $variantId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          quantity.hashCode,
          $mrjc(
              note.hashCode,
              $mrjc(
                  id.hashCode,
                  $mrjc(
                      reason.hashCode,
                      $mrjc(
                          stockId.hashCode,
                          $mrjc(
                              variantId.hashCode,
                              $mrjc(
                                  createdAt.hashCode,
                                  $mrjc(updatedAt.hashCode,
                                      deletedAt.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is StockHistoryTableData &&
          other.idLocal == this.idLocal &&
          other.quantity == this.quantity &&
          other.note == this.note &&
          other.id == this.id &&
          other.reason == this.reason &&
          other.stockId == this.stockId &&
          other.variantId == this.variantId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class StockHistoryTableCompanion
    extends UpdateCompanion<StockHistoryTableData> {
  final Value<int> idLocal;
  final Value<int> quantity;
  final Value<String> note;
  final Value<String> id;
  final Value<String> reason;
  final Value<String> stockId;
  final Value<String> variantId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const StockHistoryTableCompanion({
    this.idLocal = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.id = const Value.absent(),
    this.reason = const Value.absent(),
    this.stockId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  StockHistoryTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required int quantity,
    @required String note,
    @required String id,
    @required String reason,
    @required String stockId,
    @required String variantId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : quantity = Value(quantity),
        note = Value(note),
        id = Value(id),
        reason = Value(reason),
        stockId = Value(stockId),
        variantId = Value(variantId);
  StockHistoryTableCompanion copyWith(
      {Value<int> idLocal,
      Value<int> quantity,
      Value<String> note,
      Value<String> id,
      Value<String> reason,
      Value<String> stockId,
      Value<String> variantId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return StockHistoryTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      id: id ?? this.id,
      reason: reason ?? this.reason,
      stockId: stockId ?? this.stockId,
      variantId: variantId ?? this.variantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $StockHistoryTableTable extends StockHistoryTable
    with TableInfo<$StockHistoryTableTable, StockHistoryTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $StockHistoryTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  GeneratedIntColumn _quantity;
  @override
  GeneratedIntColumn get quantity => _quantity ??= _constructQuantity();
  GeneratedIntColumn _constructQuantity() {
    return GeneratedIntColumn(
      'quantity',
      $tableName,
      false,
    );
  }

  final VerificationMeta _noteMeta = const VerificationMeta('note');
  GeneratedTextColumn _note;
  @override
  GeneratedTextColumn get note => _note ??= _constructNote();
  GeneratedTextColumn _constructNote() {
    return GeneratedTextColumn(
      'note',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _reasonMeta = const VerificationMeta('reason');
  GeneratedTextColumn _reason;
  @override
  GeneratedTextColumn get reason => _reason ??= _constructReason();
  GeneratedTextColumn _constructReason() {
    return GeneratedTextColumn(
      'reason',
      $tableName,
      false,
    );
  }

  final VerificationMeta _stockIdMeta = const VerificationMeta('stockId');
  GeneratedTextColumn _stockId;
  @override
  GeneratedTextColumn get stockId => _stockId ??= _constructStockId();
  GeneratedTextColumn _constructStockId() {
    return GeneratedTextColumn(
      'stock_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _variantIdMeta = const VerificationMeta('variantId');
  GeneratedTextColumn _variantId;
  @override
  GeneratedTextColumn get variantId => _variantId ??= _constructVariantId();
  GeneratedTextColumn _constructVariantId() {
    return GeneratedTextColumn(
      'variant_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        quantity,
        note,
        id,
        reason,
        stockId,
        variantId,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $StockHistoryTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'stock_history_table';
  @override
  final String actualTableName = 'stock_history_table';
  @override
  VerificationContext validateIntegrity(StockHistoryTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.quantity.present) {
      context.handle(_quantityMeta,
          quantity.isAcceptableValue(d.quantity.value, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (d.note.present) {
      context.handle(
          _noteMeta, note.isAcceptableValue(d.note.value, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.reason.present) {
      context.handle(
          _reasonMeta, reason.isAcceptableValue(d.reason.value, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (d.stockId.present) {
      context.handle(_stockIdMeta,
          stockId.isAcceptableValue(d.stockId.value, _stockIdMeta));
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (d.variantId.present) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableValue(d.variantId.value, _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  StockHistoryTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return StockHistoryTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(StockHistoryTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.quantity.present) {
      map['quantity'] = Variable<int, IntType>(d.quantity.value);
    }
    if (d.note.present) {
      map['note'] = Variable<String, StringType>(d.note.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.reason.present) {
      map['reason'] = Variable<String, StringType>(d.reason.value);
    }
    if (d.stockId.present) {
      map['stock_id'] = Variable<String, StringType>(d.stockId.value);
    }
    if (d.variantId.present) {
      map['variant_id'] = Variable<String, StringType>(d.variantId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $StockHistoryTableTable createAlias(String alias) {
    return $StockHistoryTableTable(_db, alias);
  }
}

class CartTableData extends DataClass implements Insertable<CartTableData> {
  final int id;
  final String branchId;
  final int count;
  final String orderId;
  final String variationId;
  final String parentName;
  final String variationName;
  final DateTime createdAt;
  final DateTime updatedAt;
  CartTableData(
      {@required this.id,
      @required this.branchId,
      @required this.count,
      @required this.orderId,
      @required this.variationId,
      @required this.parentName,
      @required this.variationName,
      this.createdAt,
      this.updatedAt});
  factory CartTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return CartTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      count: intType.mapFromDatabaseResponse(data['${effectivePrefix}count']),
      orderId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_id']),
      variationId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variation_id']),
      parentName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_name']),
      variationName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variation_name']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory CartTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartTableData(
      id: serializer.fromJson<int>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      count: serializer.fromJson<int>(json['count']),
      orderId: serializer.fromJson<String>(json['orderId']),
      variationId: serializer.fromJson<String>(json['variationId']),
      parentName: serializer.fromJson<String>(json['parentName']),
      variationName: serializer.fromJson<String>(json['variationName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'branchId': serializer.toJson<String>(branchId),
      'count': serializer.toJson<int>(count),
      'orderId': serializer.toJson<String>(orderId),
      'variationId': serializer.toJson<String>(variationId),
      'parentName': serializer.toJson<String>(parentName),
      'variationName': serializer.toJson<String>(variationName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  CartTableCompanion createCompanion(bool nullToAbsent) {
    return CartTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      count:
          count == null && nullToAbsent ? const Value.absent() : Value(count),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      variationId: variationId == null && nullToAbsent
          ? const Value.absent()
          : Value(variationId),
      parentName: parentName == null && nullToAbsent
          ? const Value.absent()
          : Value(parentName),
      variationName: variationName == null && nullToAbsent
          ? const Value.absent()
          : Value(variationName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  CartTableData copyWith(
          {int id,
          String branchId,
          int count,
          String orderId,
          String variationId,
          String parentName,
          String variationName,
          DateTime createdAt,
          DateTime updatedAt}) =>
      CartTableData(
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        count: count ?? this.count,
        orderId: orderId ?? this.orderId,
        variationId: variationId ?? this.variationId,
        parentName: parentName ?? this.parentName,
        variationName: variationName ?? this.variationName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CartTableData(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('count: $count, ')
          ..write('orderId: $orderId, ')
          ..write('variationId: $variationId, ')
          ..write('parentName: $parentName, ')
          ..write('variationName: $variationName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          branchId.hashCode,
          $mrjc(
              count.hashCode,
              $mrjc(
                  orderId.hashCode,
                  $mrjc(
                      variationId.hashCode,
                      $mrjc(
                          parentName.hashCode,
                          $mrjc(
                              variationName.hashCode,
                              $mrjc(createdAt.hashCode,
                                  updatedAt.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CartTableData &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.count == this.count &&
          other.orderId == this.orderId &&
          other.variationId == this.variationId &&
          other.parentName == this.parentName &&
          other.variationName == this.variationName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CartTableCompanion extends UpdateCompanion<CartTableData> {
  final Value<int> id;
  final Value<String> branchId;
  final Value<int> count;
  final Value<String> orderId;
  final Value<String> variationId;
  final Value<String> parentName;
  final Value<String> variationName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CartTableCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.count = const Value.absent(),
    this.orderId = const Value.absent(),
    this.variationId = const Value.absent(),
    this.parentName = const Value.absent(),
    this.variationName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CartTableCompanion.insert({
    this.id = const Value.absent(),
    @required String branchId,
    @required int count,
    @required String orderId,
    @required String variationId,
    @required String parentName,
    @required String variationName,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : branchId = Value(branchId),
        count = Value(count),
        orderId = Value(orderId),
        variationId = Value(variationId),
        parentName = Value(parentName),
        variationName = Value(variationName);
  CartTableCompanion copyWith(
      {Value<int> id,
      Value<String> branchId,
      Value<int> count,
      Value<String> orderId,
      Value<String> variationId,
      Value<String> parentName,
      Value<String> variationName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return CartTableCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      count: count ?? this.count,
      orderId: orderId ?? this.orderId,
      variationId: variationId ?? this.variationId,
      parentName: parentName ?? this.parentName,
      variationName: variationName ?? this.variationName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $CartTableTable extends CartTable
    with TableInfo<$CartTableTable, CartTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CartTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _branchIdMeta = const VerificationMeta('branchId');
  GeneratedTextColumn _branchId;
  @override
  GeneratedTextColumn get branchId => _branchId ??= _constructBranchId();
  GeneratedTextColumn _constructBranchId() {
    return GeneratedTextColumn(
      'branch_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _countMeta = const VerificationMeta('count');
  GeneratedIntColumn _count;
  @override
  GeneratedIntColumn get count => _count ??= _constructCount();
  GeneratedIntColumn _constructCount() {
    return GeneratedIntColumn(
      'count',
      $tableName,
      false,
    );
  }

  final VerificationMeta _orderIdMeta = const VerificationMeta('orderId');
  GeneratedTextColumn _orderId;
  @override
  GeneratedTextColumn get orderId => _orderId ??= _constructOrderId();
  GeneratedTextColumn _constructOrderId() {
    return GeneratedTextColumn(
      'order_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _variationIdMeta =
      const VerificationMeta('variationId');
  GeneratedTextColumn _variationId;
  @override
  GeneratedTextColumn get variationId =>
      _variationId ??= _constructVariationId();
  GeneratedTextColumn _constructVariationId() {
    return GeneratedTextColumn(
      'variation_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _parentNameMeta = const VerificationMeta('parentName');
  GeneratedTextColumn _parentName;
  @override
  GeneratedTextColumn get parentName => _parentName ??= _constructParentName();
  GeneratedTextColumn _constructParentName() {
    return GeneratedTextColumn(
      'parent_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _variationNameMeta =
      const VerificationMeta('variationName');
  GeneratedTextColumn _variationName;
  @override
  GeneratedTextColumn get variationName =>
      _variationName ??= _constructVariationName();
  GeneratedTextColumn _constructVariationName() {
    return GeneratedTextColumn(
      'variation_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        branchId,
        count,
        orderId,
        variationId,
        parentName,
        variationName,
        createdAt,
        updatedAt
      ];
  @override
  $CartTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cart_table';
  @override
  final String actualTableName = 'cart_table';
  @override
  VerificationContext validateIntegrity(CartTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.branchId.present) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableValue(d.branchId.value, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (d.count.present) {
      context.handle(
          _countMeta, count.isAcceptableValue(d.count.value, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (d.orderId.present) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableValue(d.orderId.value, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (d.variationId.present) {
      context.handle(_variationIdMeta,
          variationId.isAcceptableValue(d.variationId.value, _variationIdMeta));
    } else if (isInserting) {
      context.missing(_variationIdMeta);
    }
    if (d.parentName.present) {
      context.handle(_parentNameMeta,
          parentName.isAcceptableValue(d.parentName.value, _parentNameMeta));
    } else if (isInserting) {
      context.missing(_parentNameMeta);
    }
    if (d.variationName.present) {
      context.handle(
          _variationNameMeta,
          variationName.isAcceptableValue(
              d.variationName.value, _variationNameMeta));
    } else if (isInserting) {
      context.missing(_variationNameMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CartTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CartTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.branchId.present) {
      map['branch_id'] = Variable<String, StringType>(d.branchId.value);
    }
    if (d.count.present) {
      map['count'] = Variable<int, IntType>(d.count.value);
    }
    if (d.orderId.present) {
      map['order_id'] = Variable<String, StringType>(d.orderId.value);
    }
    if (d.variationId.present) {
      map['variation_id'] = Variable<String, StringType>(d.variationId.value);
    }
    if (d.parentName.present) {
      map['parent_name'] = Variable<String, StringType>(d.parentName.value);
    }
    if (d.variationName.present) {
      map['variation_name'] =
          Variable<String, StringType>(d.variationName.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $CartTableTable createAlias(String alias) {
    return $CartTableTable(_db, alias);
  }
}

class OrderTableData extends DataClass implements Insertable<OrderTableData> {
  final int id;
  final int userId;
  final String branchId;
  final int orderNUmber;
  final int supplierId;
  final int subTotal;
  final int supplierInvoiceNumber;
  final DateTime deliverDate;
  final int taxRate;
  final int taxAmount;
  final int count;
  final String variantName;
  final int discountRate;
  final int discountAmount;
  final int cashReceived;
  final int saleTotal;
  final int customerSaving;
  final int paymentId;
  final String orderNote;
  final String status;
  final int customerChangeDue;
  OrderTableData(
      {@required this.id,
      @required this.userId,
      @required this.branchId,
      this.orderNUmber,
      this.supplierId,
      this.subTotal,
      this.supplierInvoiceNumber,
      this.deliverDate,
      this.taxRate,
      this.taxAmount,
      @required this.count,
      this.variantName,
      this.discountRate,
      this.discountAmount,
      this.cashReceived,
      this.saleTotal,
      this.customerSaving,
      this.paymentId,
      this.orderNote,
      @required this.status,
      this.customerChangeDue});
  factory OrderTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return OrderTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      orderNUmber: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_n_umber']),
      supplierId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}supplier_id']),
      subTotal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sub_total']),
      supplierInvoiceNumber: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}supplier_invoice_number']),
      deliverDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}deliver_date']),
      taxRate:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tax_rate']),
      taxAmount:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tax_amount']),
      count: intType.mapFromDatabaseResponse(data['${effectivePrefix}count']),
      variantName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variant_name']),
      discountRate: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}discount_rate']),
      discountAmount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}discount_amount']),
      cashReceived: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cash_received']),
      saleTotal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sale_total']),
      customerSaving: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}customer_saving']),
      paymentId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}payment_id']),
      orderNote: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_note']),
      status:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
      customerChangeDue: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}customer_change_due']),
    );
  }
  factory OrderTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OrderTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      branchId: serializer.fromJson<String>(json['branchId']),
      orderNUmber: serializer.fromJson<int>(json['orderNUmber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      subTotal: serializer.fromJson<int>(json['subTotal']),
      supplierInvoiceNumber:
          serializer.fromJson<int>(json['supplierInvoiceNumber']),
      deliverDate: serializer.fromJson<DateTime>(json['deliverDate']),
      taxRate: serializer.fromJson<int>(json['taxRate']),
      taxAmount: serializer.fromJson<int>(json['taxAmount']),
      count: serializer.fromJson<int>(json['count']),
      variantName: serializer.fromJson<String>(json['variantName']),
      discountRate: serializer.fromJson<int>(json['discountRate']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      cashReceived: serializer.fromJson<int>(json['cashReceived']),
      saleTotal: serializer.fromJson<int>(json['saleTotal']),
      customerSaving: serializer.fromJson<int>(json['customerSaving']),
      paymentId: serializer.fromJson<int>(json['paymentId']),
      orderNote: serializer.fromJson<String>(json['orderNote']),
      status: serializer.fromJson<String>(json['status']),
      customerChangeDue: serializer.fromJson<int>(json['customerChangeDue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'branchId': serializer.toJson<String>(branchId),
      'orderNUmber': serializer.toJson<int>(orderNUmber),
      'supplierId': serializer.toJson<int>(supplierId),
      'subTotal': serializer.toJson<int>(subTotal),
      'supplierInvoiceNumber': serializer.toJson<int>(supplierInvoiceNumber),
      'deliverDate': serializer.toJson<DateTime>(deliverDate),
      'taxRate': serializer.toJson<int>(taxRate),
      'taxAmount': serializer.toJson<int>(taxAmount),
      'count': serializer.toJson<int>(count),
      'variantName': serializer.toJson<String>(variantName),
      'discountRate': serializer.toJson<int>(discountRate),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'cashReceived': serializer.toJson<int>(cashReceived),
      'saleTotal': serializer.toJson<int>(saleTotal),
      'customerSaving': serializer.toJson<int>(customerSaving),
      'paymentId': serializer.toJson<int>(paymentId),
      'orderNote': serializer.toJson<String>(orderNote),
      'status': serializer.toJson<String>(status),
      'customerChangeDue': serializer.toJson<int>(customerChangeDue),
    };
  }

  @override
  OrderTableCompanion createCompanion(bool nullToAbsent) {
    return OrderTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      orderNUmber: orderNUmber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNUmber),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      subTotal: subTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(subTotal),
      supplierInvoiceNumber: supplierInvoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierInvoiceNumber),
      deliverDate: deliverDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliverDate),
      taxRate: taxRate == null && nullToAbsent
          ? const Value.absent()
          : Value(taxRate),
      taxAmount: taxAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(taxAmount),
      count:
          count == null && nullToAbsent ? const Value.absent() : Value(count),
      variantName: variantName == null && nullToAbsent
          ? const Value.absent()
          : Value(variantName),
      discountRate: discountRate == null && nullToAbsent
          ? const Value.absent()
          : Value(discountRate),
      discountAmount: discountAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAmount),
      cashReceived: cashReceived == null && nullToAbsent
          ? const Value.absent()
          : Value(cashReceived),
      saleTotal: saleTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(saleTotal),
      customerSaving: customerSaving == null && nullToAbsent
          ? const Value.absent()
          : Value(customerSaving),
      paymentId: paymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentId),
      orderNote: orderNote == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNote),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      customerChangeDue: customerChangeDue == null && nullToAbsent
          ? const Value.absent()
          : Value(customerChangeDue),
    );
  }

  OrderTableData copyWith(
          {int id,
          int userId,
          String branchId,
          int orderNUmber,
          int supplierId,
          int subTotal,
          int supplierInvoiceNumber,
          DateTime deliverDate,
          int taxRate,
          int taxAmount,
          int count,
          String variantName,
          int discountRate,
          int discountAmount,
          int cashReceived,
          int saleTotal,
          int customerSaving,
          int paymentId,
          String orderNote,
          String status,
          int customerChangeDue}) =>
      OrderTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        branchId: branchId ?? this.branchId,
        orderNUmber: orderNUmber ?? this.orderNUmber,
        supplierId: supplierId ?? this.supplierId,
        subTotal: subTotal ?? this.subTotal,
        supplierInvoiceNumber:
            supplierInvoiceNumber ?? this.supplierInvoiceNumber,
        deliverDate: deliverDate ?? this.deliverDate,
        taxRate: taxRate ?? this.taxRate,
        taxAmount: taxAmount ?? this.taxAmount,
        count: count ?? this.count,
        variantName: variantName ?? this.variantName,
        discountRate: discountRate ?? this.discountRate,
        discountAmount: discountAmount ?? this.discountAmount,
        cashReceived: cashReceived ?? this.cashReceived,
        saleTotal: saleTotal ?? this.saleTotal,
        customerSaving: customerSaving ?? this.customerSaving,
        paymentId: paymentId ?? this.paymentId,
        orderNote: orderNote ?? this.orderNote,
        status: status ?? this.status,
        customerChangeDue: customerChangeDue ?? this.customerChangeDue,
      );
  @override
  String toString() {
    return (StringBuffer('OrderTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('branchId: $branchId, ')
          ..write('orderNUmber: $orderNUmber, ')
          ..write('supplierId: $supplierId, ')
          ..write('subTotal: $subTotal, ')
          ..write('supplierInvoiceNumber: $supplierInvoiceNumber, ')
          ..write('deliverDate: $deliverDate, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('count: $count, ')
          ..write('variantName: $variantName, ')
          ..write('discountRate: $discountRate, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('cashReceived: $cashReceived, ')
          ..write('saleTotal: $saleTotal, ')
          ..write('customerSaving: $customerSaving, ')
          ..write('paymentId: $paymentId, ')
          ..write('orderNote: $orderNote, ')
          ..write('status: $status, ')
          ..write('customerChangeDue: $customerChangeDue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(
              branchId.hashCode,
              $mrjc(
                  orderNUmber.hashCode,
                  $mrjc(
                      supplierId.hashCode,
                      $mrjc(
                          subTotal.hashCode,
                          $mrjc(
                              supplierInvoiceNumber.hashCode,
                              $mrjc(
                                  deliverDate.hashCode,
                                  $mrjc(
                                      taxRate.hashCode,
                                      $mrjc(
                                          taxAmount.hashCode,
                                          $mrjc(
                                              count.hashCode,
                                              $mrjc(
                                                  variantName.hashCode,
                                                  $mrjc(
                                                      discountRate.hashCode,
                                                      $mrjc(
                                                          discountAmount
                                                              .hashCode,
                                                          $mrjc(
                                                              cashReceived
                                                                  .hashCode,
                                                              $mrjc(
                                                                  saleTotal
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      customerSaving
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          paymentId
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              orderNote.hashCode,
                                                                              $mrjc(status.hashCode, customerChangeDue.hashCode)))))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OrderTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.branchId == this.branchId &&
          other.orderNUmber == this.orderNUmber &&
          other.supplierId == this.supplierId &&
          other.subTotal == this.subTotal &&
          other.supplierInvoiceNumber == this.supplierInvoiceNumber &&
          other.deliverDate == this.deliverDate &&
          other.taxRate == this.taxRate &&
          other.taxAmount == this.taxAmount &&
          other.count == this.count &&
          other.variantName == this.variantName &&
          other.discountRate == this.discountRate &&
          other.discountAmount == this.discountAmount &&
          other.cashReceived == this.cashReceived &&
          other.saleTotal == this.saleTotal &&
          other.customerSaving == this.customerSaving &&
          other.paymentId == this.paymentId &&
          other.orderNote == this.orderNote &&
          other.status == this.status &&
          other.customerChangeDue == this.customerChangeDue);
}

class OrderTableCompanion extends UpdateCompanion<OrderTableData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> branchId;
  final Value<int> orderNUmber;
  final Value<int> supplierId;
  final Value<int> subTotal;
  final Value<int> supplierInvoiceNumber;
  final Value<DateTime> deliverDate;
  final Value<int> taxRate;
  final Value<int> taxAmount;
  final Value<int> count;
  final Value<String> variantName;
  final Value<int> discountRate;
  final Value<int> discountAmount;
  final Value<int> cashReceived;
  final Value<int> saleTotal;
  final Value<int> customerSaving;
  final Value<int> paymentId;
  final Value<String> orderNote;
  final Value<String> status;
  final Value<int> customerChangeDue;
  const OrderTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.orderNUmber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.supplierInvoiceNumber = const Value.absent(),
    this.deliverDate = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.count = const Value.absent(),
    this.variantName = const Value.absent(),
    this.discountRate = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.cashReceived = const Value.absent(),
    this.saleTotal = const Value.absent(),
    this.customerSaving = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.orderNote = const Value.absent(),
    this.status = const Value.absent(),
    this.customerChangeDue = const Value.absent(),
  });
  OrderTableCompanion.insert({
    this.id = const Value.absent(),
    @required int userId,
    @required String branchId,
    this.orderNUmber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.supplierInvoiceNumber = const Value.absent(),
    this.deliverDate = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.count = const Value.absent(),
    this.variantName = const Value.absent(),
    this.discountRate = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.cashReceived = const Value.absent(),
    this.saleTotal = const Value.absent(),
    this.customerSaving = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.orderNote = const Value.absent(),
    this.status = const Value.absent(),
    this.customerChangeDue = const Value.absent(),
  })  : userId = Value(userId),
        branchId = Value(branchId);
  OrderTableCompanion copyWith(
      {Value<int> id,
      Value<int> userId,
      Value<String> branchId,
      Value<int> orderNUmber,
      Value<int> supplierId,
      Value<int> subTotal,
      Value<int> supplierInvoiceNumber,
      Value<DateTime> deliverDate,
      Value<int> taxRate,
      Value<int> taxAmount,
      Value<int> count,
      Value<String> variantName,
      Value<int> discountRate,
      Value<int> discountAmount,
      Value<int> cashReceived,
      Value<int> saleTotal,
      Value<int> customerSaving,
      Value<int> paymentId,
      Value<String> orderNote,
      Value<String> status,
      Value<int> customerChangeDue}) {
    return OrderTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      branchId: branchId ?? this.branchId,
      orderNUmber: orderNUmber ?? this.orderNUmber,
      supplierId: supplierId ?? this.supplierId,
      subTotal: subTotal ?? this.subTotal,
      supplierInvoiceNumber:
          supplierInvoiceNumber ?? this.supplierInvoiceNumber,
      deliverDate: deliverDate ?? this.deliverDate,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      count: count ?? this.count,
      variantName: variantName ?? this.variantName,
      discountRate: discountRate ?? this.discountRate,
      discountAmount: discountAmount ?? this.discountAmount,
      cashReceived: cashReceived ?? this.cashReceived,
      saleTotal: saleTotal ?? this.saleTotal,
      customerSaving: customerSaving ?? this.customerSaving,
      paymentId: paymentId ?? this.paymentId,
      orderNote: orderNote ?? this.orderNote,
      status: status ?? this.status,
      customerChangeDue: customerChangeDue ?? this.customerChangeDue,
    );
  }
}

class $OrderTableTable extends OrderTable
    with TableInfo<$OrderTableTable, OrderTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $OrderTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _branchIdMeta = const VerificationMeta('branchId');
  GeneratedTextColumn _branchId;
  @override
  GeneratedTextColumn get branchId => _branchId ??= _constructBranchId();
  GeneratedTextColumn _constructBranchId() {
    return GeneratedTextColumn(
      'branch_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _orderNUmberMeta =
      const VerificationMeta('orderNUmber');
  GeneratedIntColumn _orderNUmber;
  @override
  GeneratedIntColumn get orderNUmber =>
      _orderNUmber ??= _constructOrderNUmber();
  GeneratedIntColumn _constructOrderNUmber() {
    return GeneratedIntColumn(
      'order_n_umber',
      $tableName,
      true,
    );
  }

  final VerificationMeta _supplierIdMeta = const VerificationMeta('supplierId');
  GeneratedIntColumn _supplierId;
  @override
  GeneratedIntColumn get supplierId => _supplierId ??= _constructSupplierId();
  GeneratedIntColumn _constructSupplierId() {
    return GeneratedIntColumn(
      'supplier_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _subTotalMeta = const VerificationMeta('subTotal');
  GeneratedIntColumn _subTotal;
  @override
  GeneratedIntColumn get subTotal => _subTotal ??= _constructSubTotal();
  GeneratedIntColumn _constructSubTotal() {
    return GeneratedIntColumn(
      'sub_total',
      $tableName,
      true,
    );
  }

  final VerificationMeta _supplierInvoiceNumberMeta =
      const VerificationMeta('supplierInvoiceNumber');
  GeneratedIntColumn _supplierInvoiceNumber;
  @override
  GeneratedIntColumn get supplierInvoiceNumber =>
      _supplierInvoiceNumber ??= _constructSupplierInvoiceNumber();
  GeneratedIntColumn _constructSupplierInvoiceNumber() {
    return GeneratedIntColumn(
      'supplier_invoice_number',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deliverDateMeta =
      const VerificationMeta('deliverDate');
  GeneratedDateTimeColumn _deliverDate;
  @override
  GeneratedDateTimeColumn get deliverDate =>
      _deliverDate ??= _constructDeliverDate();
  GeneratedDateTimeColumn _constructDeliverDate() {
    return GeneratedDateTimeColumn(
      'deliver_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _taxRateMeta = const VerificationMeta('taxRate');
  GeneratedIntColumn _taxRate;
  @override
  GeneratedIntColumn get taxRate => _taxRate ??= _constructTaxRate();
  GeneratedIntColumn _constructTaxRate() {
    return GeneratedIntColumn(
      'tax_rate',
      $tableName,
      true,
    );
  }

  final VerificationMeta _taxAmountMeta = const VerificationMeta('taxAmount');
  GeneratedIntColumn _taxAmount;
  @override
  GeneratedIntColumn get taxAmount => _taxAmount ??= _constructTaxAmount();
  GeneratedIntColumn _constructTaxAmount() {
    return GeneratedIntColumn(
      'tax_amount',
      $tableName,
      true,
    );
  }

  final VerificationMeta _countMeta = const VerificationMeta('count');
  GeneratedIntColumn _count;
  @override
  GeneratedIntColumn get count => _count ??= _constructCount();
  GeneratedIntColumn _constructCount() {
    return GeneratedIntColumn('count', $tableName, false,
        defaultValue: Constant(1));
  }

  final VerificationMeta _variantNameMeta =
      const VerificationMeta('variantName');
  GeneratedTextColumn _variantName;
  @override
  GeneratedTextColumn get variantName =>
      _variantName ??= _constructVariantName();
  GeneratedTextColumn _constructVariantName() {
    return GeneratedTextColumn(
      'variant_name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _discountRateMeta =
      const VerificationMeta('discountRate');
  GeneratedIntColumn _discountRate;
  @override
  GeneratedIntColumn get discountRate =>
      _discountRate ??= _constructDiscountRate();
  GeneratedIntColumn _constructDiscountRate() {
    return GeneratedIntColumn(
      'discount_rate',
      $tableName,
      true,
    );
  }

  final VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  GeneratedIntColumn _discountAmount;
  @override
  GeneratedIntColumn get discountAmount =>
      _discountAmount ??= _constructDiscountAmount();
  GeneratedIntColumn _constructDiscountAmount() {
    return GeneratedIntColumn(
      'discount_amount',
      $tableName,
      true,
    );
  }

  final VerificationMeta _cashReceivedMeta =
      const VerificationMeta('cashReceived');
  GeneratedIntColumn _cashReceived;
  @override
  GeneratedIntColumn get cashReceived =>
      _cashReceived ??= _constructCashReceived();
  GeneratedIntColumn _constructCashReceived() {
    return GeneratedIntColumn(
      'cash_received',
      $tableName,
      true,
    );
  }

  final VerificationMeta _saleTotalMeta = const VerificationMeta('saleTotal');
  GeneratedIntColumn _saleTotal;
  @override
  GeneratedIntColumn get saleTotal => _saleTotal ??= _constructSaleTotal();
  GeneratedIntColumn _constructSaleTotal() {
    return GeneratedIntColumn(
      'sale_total',
      $tableName,
      true,
    );
  }

  final VerificationMeta _customerSavingMeta =
      const VerificationMeta('customerSaving');
  GeneratedIntColumn _customerSaving;
  @override
  GeneratedIntColumn get customerSaving =>
      _customerSaving ??= _constructCustomerSaving();
  GeneratedIntColumn _constructCustomerSaving() {
    return GeneratedIntColumn(
      'customer_saving',
      $tableName,
      true,
    );
  }

  final VerificationMeta _paymentIdMeta = const VerificationMeta('paymentId');
  GeneratedIntColumn _paymentId;
  @override
  GeneratedIntColumn get paymentId => _paymentId ??= _constructPaymentId();
  GeneratedIntColumn _constructPaymentId() {
    return GeneratedIntColumn(
      'payment_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _orderNoteMeta = const VerificationMeta('orderNote');
  GeneratedTextColumn _orderNote;
  @override
  GeneratedTextColumn get orderNote => _orderNote ??= _constructOrderNote();
  GeneratedTextColumn _constructOrderNote() {
    return GeneratedTextColumn(
      'order_note',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedTextColumn _status;
  @override
  GeneratedTextColumn get status => _status ??= _constructStatus();
  GeneratedTextColumn _constructStatus() {
    return GeneratedTextColumn('status', $tableName, false,
        defaultValue: Constant("draft"));
  }

  final VerificationMeta _customerChangeDueMeta =
      const VerificationMeta('customerChangeDue');
  GeneratedIntColumn _customerChangeDue;
  @override
  GeneratedIntColumn get customerChangeDue =>
      _customerChangeDue ??= _constructCustomerChangeDue();
  GeneratedIntColumn _constructCustomerChangeDue() {
    return GeneratedIntColumn(
      'customer_change_due',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        branchId,
        orderNUmber,
        supplierId,
        subTotal,
        supplierInvoiceNumber,
        deliverDate,
        taxRate,
        taxAmount,
        count,
        variantName,
        discountRate,
        discountAmount,
        cashReceived,
        saleTotal,
        customerSaving,
        paymentId,
        orderNote,
        status,
        customerChangeDue
      ];
  @override
  $OrderTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'order_table';
  @override
  final String actualTableName = 'order_table';
  @override
  VerificationContext validateIntegrity(OrderTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.branchId.present) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableValue(d.branchId.value, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (d.orderNUmber.present) {
      context.handle(_orderNUmberMeta,
          orderNUmber.isAcceptableValue(d.orderNUmber.value, _orderNUmberMeta));
    }
    if (d.supplierId.present) {
      context.handle(_supplierIdMeta,
          supplierId.isAcceptableValue(d.supplierId.value, _supplierIdMeta));
    }
    if (d.subTotal.present) {
      context.handle(_subTotalMeta,
          subTotal.isAcceptableValue(d.subTotal.value, _subTotalMeta));
    }
    if (d.supplierInvoiceNumber.present) {
      context.handle(
          _supplierInvoiceNumberMeta,
          supplierInvoiceNumber.isAcceptableValue(
              d.supplierInvoiceNumber.value, _supplierInvoiceNumberMeta));
    }
    if (d.deliverDate.present) {
      context.handle(_deliverDateMeta,
          deliverDate.isAcceptableValue(d.deliverDate.value, _deliverDateMeta));
    }
    if (d.taxRate.present) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableValue(d.taxRate.value, _taxRateMeta));
    }
    if (d.taxAmount.present) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableValue(d.taxAmount.value, _taxAmountMeta));
    }
    if (d.count.present) {
      context.handle(
          _countMeta, count.isAcceptableValue(d.count.value, _countMeta));
    }
    if (d.variantName.present) {
      context.handle(_variantNameMeta,
          variantName.isAcceptableValue(d.variantName.value, _variantNameMeta));
    }
    if (d.discountRate.present) {
      context.handle(
          _discountRateMeta,
          discountRate.isAcceptableValue(
              d.discountRate.value, _discountRateMeta));
    }
    if (d.discountAmount.present) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableValue(
              d.discountAmount.value, _discountAmountMeta));
    }
    if (d.cashReceived.present) {
      context.handle(
          _cashReceivedMeta,
          cashReceived.isAcceptableValue(
              d.cashReceived.value, _cashReceivedMeta));
    }
    if (d.saleTotal.present) {
      context.handle(_saleTotalMeta,
          saleTotal.isAcceptableValue(d.saleTotal.value, _saleTotalMeta));
    }
    if (d.customerSaving.present) {
      context.handle(
          _customerSavingMeta,
          customerSaving.isAcceptableValue(
              d.customerSaving.value, _customerSavingMeta));
    }
    if (d.paymentId.present) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableValue(d.paymentId.value, _paymentIdMeta));
    }
    if (d.orderNote.present) {
      context.handle(_orderNoteMeta,
          orderNote.isAcceptableValue(d.orderNote.value, _orderNoteMeta));
    }
    if (d.status.present) {
      context.handle(
          _statusMeta, status.isAcceptableValue(d.status.value, _statusMeta));
    }
    if (d.customerChangeDue.present) {
      context.handle(
          _customerChangeDueMeta,
          customerChangeDue.isAcceptableValue(
              d.customerChangeDue.value, _customerChangeDueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return OrderTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(OrderTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<int, IntType>(d.userId.value);
    }
    if (d.branchId.present) {
      map['branch_id'] = Variable<String, StringType>(d.branchId.value);
    }
    if (d.orderNUmber.present) {
      map['order_n_umber'] = Variable<int, IntType>(d.orderNUmber.value);
    }
    if (d.supplierId.present) {
      map['supplier_id'] = Variable<int, IntType>(d.supplierId.value);
    }
    if (d.subTotal.present) {
      map['sub_total'] = Variable<int, IntType>(d.subTotal.value);
    }
    if (d.supplierInvoiceNumber.present) {
      map['supplier_invoice_number'] =
          Variable<int, IntType>(d.supplierInvoiceNumber.value);
    }
    if (d.deliverDate.present) {
      map['deliver_date'] =
          Variable<DateTime, DateTimeType>(d.deliverDate.value);
    }
    if (d.taxRate.present) {
      map['tax_rate'] = Variable<int, IntType>(d.taxRate.value);
    }
    if (d.taxAmount.present) {
      map['tax_amount'] = Variable<int, IntType>(d.taxAmount.value);
    }
    if (d.count.present) {
      map['count'] = Variable<int, IntType>(d.count.value);
    }
    if (d.variantName.present) {
      map['variant_name'] = Variable<String, StringType>(d.variantName.value);
    }
    if (d.discountRate.present) {
      map['discount_rate'] = Variable<int, IntType>(d.discountRate.value);
    }
    if (d.discountAmount.present) {
      map['discount_amount'] = Variable<int, IntType>(d.discountAmount.value);
    }
    if (d.cashReceived.present) {
      map['cash_received'] = Variable<int, IntType>(d.cashReceived.value);
    }
    if (d.saleTotal.present) {
      map['sale_total'] = Variable<int, IntType>(d.saleTotal.value);
    }
    if (d.customerSaving.present) {
      map['customer_saving'] = Variable<int, IntType>(d.customerSaving.value);
    }
    if (d.paymentId.present) {
      map['payment_id'] = Variable<int, IntType>(d.paymentId.value);
    }
    if (d.orderNote.present) {
      map['order_note'] = Variable<String, StringType>(d.orderNote.value);
    }
    if (d.status.present) {
      map['status'] = Variable<String, StringType>(d.status.value);
    }
    if (d.customerChangeDue.present) {
      map['customer_change_due'] =
          Variable<int, IntType>(d.customerChangeDue.value);
    }
    return map;
  }

  @override
  $OrderTableTable createAlias(String alias) {
    return $OrderTableTable(_db, alias);
  }
}

class ColorTableData extends DataClass implements Insertable<ColorTableData> {
  final int id;
  final String name;
  final bool isActive;
  ColorTableData(
      {@required this.id, @required this.name, @required this.isActive});
  factory ColorTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return ColorTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isActive:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
    );
  }
  factory ColorTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ColorTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  @override
  ColorTableCompanion createCompanion(bool nullToAbsent) {
    return ColorTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
    );
  }

  ColorTableData copyWith({int id, String name, bool isActive}) =>
      ColorTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('ColorTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, isActive.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ColorTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class ColorTableCompanion extends UpdateCompanion<ColorTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  const ColorTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ColorTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  ColorTableCompanion copyWith(
      {Value<int> id, Value<String> name, Value<bool> isActive}) {
    return ColorTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}

class $ColorTableTable extends ColorTable
    with TableInfo<$ColorTableTable, ColorTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ColorTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  GeneratedBoolColumn _isActive;
  @override
  GeneratedBoolColumn get isActive => _isActive ??= _constructIsActive();
  GeneratedBoolColumn _constructIsActive() {
    return GeneratedBoolColumn('is_active', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, isActive];
  @override
  $ColorTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'color_table';
  @override
  final String actualTableName = 'color_table';
  @override
  VerificationContext validateIntegrity(ColorTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isActive.present) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableValue(d.isActive.value, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ColorTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ColorTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ColorTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.isActive.present) {
      map['is_active'] = Variable<bool, BoolType>(d.isActive.value);
    }
    return map;
  }

  @override
  $ColorTableTable createAlias(String alias) {
    return $ColorTableTable(_db, alias);
  }
}

class ActionsTableData extends DataClass
    implements Insertable<ActionsTableData> {
  final int id;
  final bool isLocked;
  final String name;
  ActionsTableData(
      {@required this.id, @required this.isLocked, @required this.name});
  factory ActionsTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final stringType = db.typeSystem.forDartType<String>();
    return ActionsTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      isLocked:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_locked']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory ActionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ActionsTableData(
      id: serializer.fromJson<int>(json['id']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isLocked': serializer.toJson<bool>(isLocked),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  ActionsTableCompanion createCompanion(bool nullToAbsent) {
    return ActionsTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      isLocked: isLocked == null && nullToAbsent
          ? const Value.absent()
          : Value(isLocked),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  ActionsTableData copyWith({int id, bool isLocked, String name}) =>
      ActionsTableData(
        id: id ?? this.id,
        isLocked: isLocked ?? this.isLocked,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ActionsTableData(')
          ..write('id: $id, ')
          ..write('isLocked: $isLocked, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(isLocked.hashCode, name.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ActionsTableData &&
          other.id == this.id &&
          other.isLocked == this.isLocked &&
          other.name == this.name);
}

class ActionsTableCompanion extends UpdateCompanion<ActionsTableData> {
  final Value<int> id;
  final Value<bool> isLocked;
  final Value<String> name;
  const ActionsTableCompanion({
    this.id = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.name = const Value.absent(),
  });
  ActionsTableCompanion.insert({
    this.id = const Value.absent(),
    this.isLocked = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  ActionsTableCompanion copyWith(
      {Value<int> id, Value<bool> isLocked, Value<String> name}) {
    return ActionsTableCompanion(
      id: id ?? this.id,
      isLocked: isLocked ?? this.isLocked,
      name: name ?? this.name,
    );
  }
}

class $ActionsTableTable extends ActionsTable
    with TableInfo<$ActionsTableTable, ActionsTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ActionsTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _isLockedMeta = const VerificationMeta('isLocked');
  GeneratedBoolColumn _isLocked;
  @override
  GeneratedBoolColumn get isLocked => _isLocked ??= _constructIsLocked();
  GeneratedBoolColumn _constructIsLocked() {
    return GeneratedBoolColumn('is_locked', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, isLocked, name];
  @override
  $ActionsTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'actions_table';
  @override
  final String actualTableName = 'actions_table';
  @override
  VerificationContext validateIntegrity(ActionsTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.isLocked.present) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableValue(d.isLocked.value, _isLockedMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionsTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ActionsTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ActionsTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.isLocked.present) {
      map['is_locked'] = Variable<bool, BoolType>(d.isLocked.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $ActionsTableTable createAlias(String alias) {
    return $ActionsTableTable(_db, alias);
  }
}

class ReasonTableData extends DataClass implements Insertable<ReasonTableData> {
  final int id;
  final String name;
  final String action;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  ReasonTableData(
      {@required this.id,
      @required this.name,
      @required this.action,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory ReasonTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ReasonTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      action:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}action']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  factory ReasonTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ReasonTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      action: serializer.fromJson<String>(json['action']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'action': serializer.toJson<String>(action),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  @override
  ReasonTableCompanion createCompanion(bool nullToAbsent) {
    return ReasonTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      action:
          action == null && nullToAbsent ? const Value.absent() : Value(action),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  ReasonTableData copyWith(
          {int id,
          String name,
          String action,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      ReasonTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        action: action ?? this.action,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ReasonTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              action.hashCode,
              $mrjc(createdAt.hashCode,
                  $mrjc(updatedAt.hashCode, deletedAt.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ReasonTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.action == this.action &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ReasonTableCompanion extends UpdateCompanion<ReasonTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> action;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const ReasonTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ReasonTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String action,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : name = Value(name),
        action = Value(action);
  ReasonTableCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> action,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return ReasonTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class $ReasonTableTable extends ReasonTable
    with TableInfo<$ReasonTableTable, ReasonTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ReasonTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _actionMeta = const VerificationMeta('action');
  GeneratedTextColumn _action;
  @override
  GeneratedTextColumn get action => _action ??= _constructAction();
  GeneratedTextColumn _constructAction() {
    return GeneratedTextColumn(
      'action',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedTextColumn _deletedAt;
  @override
  GeneratedTextColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedTextColumn _constructDeletedAt() {
    return GeneratedTextColumn('deleted_at', $tableName, true,
        defaultValue: Constant("null"));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, action, createdAt, updatedAt, deletedAt];
  @override
  $ReasonTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reason_table';
  @override
  final String actualTableName = 'reason_table';
  @override
  VerificationContext validateIntegrity(ReasonTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.action.present) {
      context.handle(
          _actionMeta, action.isAcceptableValue(d.action.value, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReasonTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ReasonTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ReasonTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.action.present) {
      map['action'] = Variable<String, StringType>(d.action.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<String, StringType>(d.deletedAt.value);
    }
    return map;
  }

  @override
  $ReasonTableTable createAlias(String alias) {
    return $ReasonTableTable(_db, alias);
  }
}

class TaxTableData extends DataClass implements Insertable<TaxTableData> {
  final int idLocal;
  final String name;
  final bool isDefault;
  final double percentage;
  final String id;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;
  TaxTableData(
      {@required this.idLocal,
      @required this.name,
      @required this.isDefault,
      @required this.percentage,
      @required this.id,
      @required this.businessId,
      this.createdAt,
      this.updatedAt});
  factory TaxTableData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TaxTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isDefault: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_default']),
      percentage: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}percentage']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      businessId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}business_id']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory TaxTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TaxTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      percentage: serializer.fromJson<double>(json['percentage']),
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
      'percentage': serializer.toJson<double>(percentage),
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  TaxTableCompanion createCompanion(bool nullToAbsent) {
    return TaxTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isDefault: isDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(isDefault),
      percentage: percentage == null && nullToAbsent
          ? const Value.absent()
          : Value(percentage),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      businessId: businessId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  TaxTableData copyWith(
          {int idLocal,
          String name,
          bool isDefault,
          double percentage,
          String id,
          String businessId,
          DateTime createdAt,
          DateTime updatedAt}) =>
      TaxTableData(
        idLocal: idLocal ?? this.idLocal,
        name: name ?? this.name,
        isDefault: isDefault ?? this.isDefault,
        percentage: percentage ?? this.percentage,
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TaxTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('percentage: $percentage, ')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              isDefault.hashCode,
              $mrjc(
                  percentage.hashCode,
                  $mrjc(
                      id.hashCode,
                      $mrjc(businessId.hashCode,
                          $mrjc(createdAt.hashCode, updatedAt.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TaxTableData &&
          other.idLocal == this.idLocal &&
          other.name == this.name &&
          other.isDefault == this.isDefault &&
          other.percentage == this.percentage &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaxTableCompanion extends UpdateCompanion<TaxTableData> {
  final Value<int> idLocal;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<double> percentage;
  final Value<String> id;
  final Value<String> businessId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaxTableCompanion({
    this.idLocal = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.percentage = const Value.absent(),
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaxTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String name,
    @required bool isDefault,
    this.percentage = const Value.absent(),
    @required String id,
    @required String businessId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        isDefault = Value(isDefault),
        id = Value(id),
        businessId = Value(businessId);
  TaxTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> name,
      Value<bool> isDefault,
      Value<double> percentage,
      Value<String> id,
      Value<String> businessId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return TaxTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      percentage: percentage ?? this.percentage,
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $TaxTableTable extends TaxTable
    with TableInfo<$TaxTableTable, TaxTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $TaxTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isDefaultMeta = const VerificationMeta('isDefault');
  GeneratedBoolColumn _isDefault;
  @override
  GeneratedBoolColumn get isDefault => _isDefault ??= _constructIsDefault();
  GeneratedBoolColumn _constructIsDefault() {
    return GeneratedBoolColumn(
      'is_default',
      $tableName,
      false,
    );
  }

  final VerificationMeta _percentageMeta = const VerificationMeta('percentage');
  GeneratedRealColumn _percentage;
  @override
  GeneratedRealColumn get percentage => _percentage ??= _constructPercentage();
  GeneratedRealColumn _constructPercentage() {
    return GeneratedRealColumn('percentage', $tableName, false,
        defaultValue: Constant(18.0.toDouble()));
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _businessIdMeta = const VerificationMeta('businessId');
  GeneratedTextColumn _businessId;
  @override
  GeneratedTextColumn get businessId => _businessId ??= _constructBusinessId();
  GeneratedTextColumn _constructBusinessId() {
    return GeneratedTextColumn(
      'business_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn('created_at', $tableName, true,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        idLocal,
        name,
        isDefault,
        percentage,
        id,
        businessId,
        createdAt,
        updatedAt
      ];
  @override
  $TaxTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tax_table';
  @override
  final String actualTableName = 'tax_table';
  @override
  VerificationContext validateIntegrity(TaxTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isDefault.present) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableValue(d.isDefault.value, _isDefaultMeta));
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (d.percentage.present) {
      context.handle(_percentageMeta,
          percentage.isAcceptableValue(d.percentage.value, _percentageMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.businessId.present) {
      context.handle(_businessIdMeta,
          businessId.isAcceptableValue(d.businessId.value, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  TaxTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TaxTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TaxTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.isDefault.present) {
      map['is_default'] = Variable<bool, BoolType>(d.isDefault.value);
    }
    if (d.percentage.present) {
      map['percentage'] = Variable<double, RealType>(d.percentage.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.businessId.present) {
      map['business_id'] = Variable<String, StringType>(d.businessId.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $TaxTableTable createAlias(String alias) {
    return $TaxTableTable(_db, alias);
  }
}

class BranchProductTableData extends DataClass
    implements Insertable<BranchProductTableData> {
  final int idLocal;
  final String id;
  final String productId;
  final String branchId;
  BranchProductTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.productId,
      @required this.branchId});
  factory BranchProductTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return BranchProductTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      productId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
    );
  }
  factory BranchProductTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BranchProductTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      branchId: serializer.fromJson<String>(json['branchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'branchId': serializer.toJson<String>(branchId),
    };
  }

  @override
  BranchProductTableCompanion createCompanion(bool nullToAbsent) {
    return BranchProductTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
    );
  }

  BranchProductTableData copyWith(
          {int idLocal, String id, String productId, String branchId}) =>
      BranchProductTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        productId: productId ?? this.productId,
        branchId: branchId ?? this.branchId,
      );
  @override
  String toString() {
    return (StringBuffer('BranchProductTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('branchId: $branchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(idLocal.hashCode,
      $mrjc(id.hashCode, $mrjc(productId.hashCode, branchId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BranchProductTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.branchId == this.branchId);
}

class BranchProductTableCompanion
    extends UpdateCompanion<BranchProductTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> productId;
  final Value<String> branchId;
  const BranchProductTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.branchId = const Value.absent(),
  });
  BranchProductTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String productId,
    @required String branchId,
  })  : id = Value(id),
        productId = Value(productId),
        branchId = Value(branchId);
  BranchProductTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> productId,
      Value<String> branchId}) {
    return BranchProductTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      productId: productId ?? this.productId,
      branchId: branchId ?? this.branchId,
    );
  }
}

class $BranchProductTableTable extends BranchProductTable
    with TableInfo<$BranchProductTableTable, BranchProductTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BranchProductTableTable(this._db, [this._alias]);
  final VerificationMeta _idLocalMeta = const VerificationMeta('idLocal');
  GeneratedIntColumn _idLocal;
  @override
  GeneratedIntColumn get idLocal => _idLocal ??= _constructIdLocal();
  GeneratedIntColumn _constructIdLocal() {
    return GeneratedIntColumn('id_local', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  GeneratedTextColumn _productId;
  @override
  GeneratedTextColumn get productId => _productId ??= _constructProductId();
  GeneratedTextColumn _constructProductId() {
    return GeneratedTextColumn(
      'product_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _branchIdMeta = const VerificationMeta('branchId');
  GeneratedTextColumn _branchId;
  @override
  GeneratedTextColumn get branchId => _branchId ??= _constructBranchId();
  GeneratedTextColumn _constructBranchId() {
    return GeneratedTextColumn(
      'branch_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [idLocal, id, productId, branchId];
  @override
  $BranchProductTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'branch_product_table';
  @override
  final String actualTableName = 'branch_product_table';
  @override
  VerificationContext validateIntegrity(BranchProductTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idLocal.present) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableValue(d.idLocal.value, _idLocalMeta));
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.productId.present) {
      context.handle(_productIdMeta,
          productId.isAcceptableValue(d.productId.value, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (d.branchId.present) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableValue(d.branchId.value, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  BranchProductTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BranchProductTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BranchProductTableCompanion d) {
    final map = <String, Variable>{};
    if (d.idLocal.present) {
      map['id_local'] = Variable<int, IntType>(d.idLocal.value);
    }
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.productId.present) {
      map['product_id'] = Variable<String, StringType>(d.productId.value);
    }
    if (d.branchId.present) {
      map['branch_id'] = Variable<String, StringType>(d.branchId.value);
    }
    return map;
  }

  @override
  $BranchProductTableTable createAlias(String alias) {
    return $BranchProductTableTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UserTableTable _userTable;
  $UserTableTable get userTable => _userTable ??= $UserTableTable(this);
  $BusinessTableTable _businessTable;
  $BusinessTableTable get businessTable =>
      _businessTable ??= $BusinessTableTable(this);
  $BranchTableTable _branchTable;
  $BranchTableTable get branchTable => _branchTable ??= $BranchTableTable(this);
  $UnitTableTable _unitTable;
  $UnitTableTable get unitTable => _unitTable ??= $UnitTableTable(this);
  $CategoryTableTable _categoryTable;
  $CategoryTableTable get categoryTable =>
      _categoryTable ??= $CategoryTableTable(this);
  $ProductTableTable _productTable;
  $ProductTableTable get productTable =>
      _productTable ??= $ProductTableTable(this);
  $TokenTableTable _tokenTable;
  $TokenTableTable get tokenTable => _tokenTable ??= $TokenTableTable(this);
  $BusinessUserTableTable _businessUserTable;
  $BusinessUserTableTable get businessUserTable =>
      _businessUserTable ??= $BusinessUserTableTable(this);
  $TabsTableTable _tabsTable;
  $TabsTableTable get tabsTable => _tabsTable ??= $TabsTableTable(this);
  $VariationTableTable _variationTable;
  $VariationTableTable get variationTable =>
      _variationTable ??= $VariationTableTable(this);
  $StockTableTable _stockTable;
  $StockTableTable get stockTable => _stockTable ??= $StockTableTable(this);
  $PriceTableTable _priceTable;
  $PriceTableTable get priceTable => _priceTable ??= $PriceTableTable(this);
  $StockHistoryTableTable _stockHistoryTable;
  $StockHistoryTableTable get stockHistoryTable =>
      _stockHistoryTable ??= $StockHistoryTableTable(this);
  $CartTableTable _cartTable;
  $CartTableTable get cartTable => _cartTable ??= $CartTableTable(this);
  $OrderTableTable _orderTable;
  $OrderTableTable get orderTable => _orderTable ??= $OrderTableTable(this);
  $ColorTableTable _colorTable;
  $ColorTableTable get colorTable => _colorTable ??= $ColorTableTable(this);
  $ActionsTableTable _actionsTable;
  $ActionsTableTable get actionsTable =>
      _actionsTable ??= $ActionsTableTable(this);
  $ReasonTableTable _reasonTable;
  $ReasonTableTable get reasonTable => _reasonTable ??= $ReasonTableTable(this);
  $TaxTableTable _taxTable;
  $TaxTableTable get taxTable => _taxTable ??= $TaxTableTable(this);
  $BranchProductTableTable _branchProductTable;
  $BranchProductTableTable get branchProductTable =>
      _branchProductTable ??= $BranchProductTableTable(this);
  UserDao _userDao;
  UserDao get userDao => _userDao ??= UserDao(this as Database);
  TokenDao _tokenDao;
  TokenDao get tokenDao => _tokenDao ??= TokenDao(this as Database);
  UnitDao _unitDao;
  UnitDao get unitDao => _unitDao ??= UnitDao(this as Database);
  BusinessDao _businessDao;
  BusinessDao get businessDao => _businessDao ??= BusinessDao(this as Database);
  BranchDao _branchDao;
  BranchDao get branchDao => _branchDao ??= BranchDao(this as Database);
  CategoryDao _categoryDao;
  CategoryDao get categoryDao => _categoryDao ??= CategoryDao(this as Database);
  TabsDao _tabsDao;
  TabsDao get tabsDao => _tabsDao ??= TabsDao(this as Database);
  VariationDao _variationDao;
  VariationDao get variationDao =>
      _variationDao ??= VariationDao(this as Database);
  ProductDao _productDao;
  ProductDao get productDao => _productDao ??= ProductDao(this as Database);
  StockHistoryDao _stockHistoryDao;
  StockHistoryDao get stockHistoryDao =>
      _stockHistoryDao ??= StockHistoryDao(this as Database);
  StockDao _stockDao;
  StockDao get stockDao => _stockDao ??= StockDao(this as Database);
  CartDao _cartDao;
  CartDao get cartDao => _cartDao ??= CartDao(this as Database);
  OrderDao _orderDao;
  OrderDao get orderDao => _orderDao ??= OrderDao(this as Database);
  ColorDao _colorDao;
  ColorDao get colorDao => _colorDao ??= ColorDao(this as Database);
  ActionsDao _actionsDao;
  ActionsDao get actionsDao => _actionsDao ??= ActionsDao(this as Database);
  TaxDao _taxDao;
  TaxDao get taxDao => _taxDao ??= TaxDao(this as Database);
  ReasonDao _reasonDao;
  ReasonDao get reasonDao => _reasonDao ??= ReasonDao(this as Database);
  BranchProductDao _branchProductDao;
  BranchProductDao get branchProductDao =>
      _branchProductDao ??= BranchProductDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userTable,
        businessTable,
        branchTable,
        unitTable,
        categoryTable,
        productTable,
        tokenTable,
        businessUserTable,
        tabsTable,
        variationTable,
        stockTable,
        priceTable,
        stockHistoryTable,
        cartTable,
        orderTable,
        colorTable,
        actionsTable,
        reasonTable,
        taxTable,
        branchProductTable
      ];
}
