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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<UserTableData> custom({
    Expression<int> id,
    Expression<int> userId,
    Expression<String> username,
    Expression<String> token,
    Expression<String> email,
    Expression<String> avatar,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (token != null) 'token': token,
      if (email != null) 'email': email,
      if (avatar != null) 'avatar': avatar,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
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
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username'], _usernameMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token'], _tokenMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar'], _avatarMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || active != null) {
      map['active'] = Variable<bool>(active);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || typeId != null) {
      map['type_id'] = Variable<String>(typeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || timeZone != null) {
      map['time_zone'] = Variable<String>(timeZone);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  BusinessTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<BusinessTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> name,
    Expression<bool> active,
    Expression<String> userId,
    Expression<String> typeId,
    Expression<String> categoryId,
    Expression<String> country,
    Expression<String> currency,
    Expression<String> timeZone,
    Expression<double> longitude,
    Expression<double> latitude,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
      if (userId != null) 'user_id': userId,
      if (typeId != null) 'type_id': typeId,
      if (categoryId != null) 'category_id': categoryId,
      if (country != null) 'country': country,
      if (currency != null) 'currency': currency,
      if (timeZone != null) 'time_zone': timeZone,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<String>(typeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessTableCompanion(')
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
  VerificationContext validateIntegrity(Insertable<BusinessTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active'], _activeMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id'], _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country'], _countryMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency'], _currencyMeta));
    }
    if (data.containsKey('time_zone')) {
      context.handle(_timeZoneMeta,
          timeZone.isAcceptableOrUnknown(data['time_zone'], _timeZoneMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude'], _longitudeMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude'], _latitudeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  $BusinessTableTable createAlias(String alias) {
    return $BusinessTableTable(_db, alias);
  }
}

class BranchTableData extends DataClass implements Insertable<BranchTableData> {
  final int idLocal;
  final String id;
  final String name;
  final bool isActive;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deletedAt;
  BranchTableData(
      {@required this.idLocal,
      @required this.id,
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
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool>(isActive);
    }
    if (!nullToAbsent || businessId != null) {
      map['business_id'] = Variable<String>(businessId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  BranchTableCompanion toCompanion(bool nullToAbsent) {
    return BranchTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
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

  factory BranchTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BranchTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
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
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'businessId': serializer.toJson<String>(businessId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  BranchTableData copyWith(
          {int idLocal,
          String id,
          String name,
          bool isActive,
          String businessId,
          DateTime createdAt,
          DateTime updatedAt,
          String deletedAt}) =>
      BranchTableData(
        idLocal: idLocal ?? this.idLocal,
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
          ..write('idLocal: $idLocal, ')
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
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  isActive.hashCode,
                  $mrjc(
                      businessId.hashCode,
                      $mrjc(createdAt.hashCode,
                          $mrjc(updatedAt.hashCode, deletedAt.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BranchTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.businessId == this.businessId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class BranchTableCompanion extends UpdateCompanion<BranchTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<String> businessId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deletedAt;
  const BranchTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.businessId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  BranchTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String name,
    this.isActive = const Value.absent(),
    @required String businessId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        businessId = Value(businessId);
  static Insertable<BranchTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> name,
    Expression<bool> isActive,
    Expression<String> businessId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (businessId != null) 'business_id': businessId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  BranchTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<bool> isActive,
      Value<String> businessId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deletedAt}) {
    return BranchTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchTableCompanion(')
          ..write('idLocal: $idLocal, ')
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
}

class $BranchTableTable extends BranchTable
    with TableInfo<$BranchTableTable, BranchTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BranchTableTable(this._db, [this._alias]);
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
  List<GeneratedColumn> get $columns => [
        idLocal,
        id,
        name,
        isActive,
        businessId,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  $BranchTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'branch_table';
  @override
  final String actualTableName = 'branch_table';
  @override
  VerificationContext validateIntegrity(Insertable<BranchTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active'], _isActiveMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id'], _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  BranchTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BranchTableData.fromData(data, _db, prefix: effectivePrefix);
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || focused != null) {
      map['focused'] = Variable<bool>(focused);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UnitTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<UnitTableData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> value,
    Expression<bool> focused,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (focused != null) 'focused': focused,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (focused.present) {
      map['focused'] = Variable<bool>(focused.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('focused: $focused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<UnitTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value'], _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('focused')) {
      context.handle(_focusedMeta,
          focused.isAcceptableOrUnknown(data['focused'], _focusedMeta));
    } else if (isInserting) {
      context.missing(_focusedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || focused != null) {
      map['focused'] = Variable<bool>(focused);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<CategoryTableData> custom({
    Expression<int> idLocal,
    Expression<bool> focused,
    Expression<String> id,
    Expression<String> name,
    Expression<String> branchId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (focused != null) 'focused': focused,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (branchId != null) 'branch_id': branchId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (focused.present) {
      map['focused'] = Variable<bool>(focused.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
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
  VerificationContext validateIntegrity(Insertable<CategoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('focused')) {
      context.handle(_focusedMeta,
          focused.isAcceptableOrUnknown(data['focused'], _focusedMeta));
    } else if (isInserting) {
      context.missing(_focusedMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id'], _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  final bool isImageLocal;
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
      @required this.isImageLocal,
      @required this.isDraft,
      @required this.isCurrentUpdate,
      this.description,
      this.color,
      @required this.businessId,
      @required this.supplierId,
      this.categoryId,
      this.taxId,
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
      isImageLocal: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_image_local']),
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
    }
    if (!nullToAbsent || active != null) {
      map['active'] = Variable<bool>(active);
    }
    if (!nullToAbsent || hasPicture != null) {
      map['has_picture'] = Variable<bool>(hasPicture);
    }
    if (!nullToAbsent || isImageLocal != null) {
      map['is_image_local'] = Variable<bool>(isImageLocal);
    }
    if (!nullToAbsent || isDraft != null) {
      map['is_draft'] = Variable<bool>(isDraft);
    }
    if (!nullToAbsent || isCurrentUpdate != null) {
      map['is_current_update'] = Variable<bool>(isCurrentUpdate);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || businessId != null) {
      map['business_id'] = Variable<String>(businessId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || taxId != null) {
      map['tax_id'] = Variable<String>(taxId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  ProductTableCompanion toCompanion(bool nullToAbsent) {
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
      isImageLocal: isImageLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(isImageLocal),
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
      isImageLocal: serializer.fromJson<bool>(json['isImageLocal']),
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
      'isImageLocal': serializer.toJson<bool>(isImageLocal),
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

  ProductTableData copyWith(
          {int idLocal,
          String id,
          String name,
          String picture,
          bool active,
          bool hasPicture,
          bool isImageLocal,
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
        isImageLocal: isImageLocal ?? this.isImageLocal,
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
          ..write('isImageLocal: $isImageLocal, ')
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
                              isImageLocal.hashCode,
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
                                                                          .hashCode))))))))))))))))));
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
          other.isImageLocal == this.isImageLocal &&
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
  final Value<bool> isImageLocal;
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
    this.isImageLocal = const Value.absent(),
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
    this.isImageLocal = const Value.absent(),
    @required bool isDraft,
    @required bool isCurrentUpdate,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    @required String businessId,
    @required String supplierId,
    this.categoryId = const Value.absent(),
    this.taxId = const Value.absent(),
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
        supplierId = Value(supplierId);
  static Insertable<ProductTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> name,
    Expression<String> picture,
    Expression<bool> active,
    Expression<bool> hasPicture,
    Expression<bool> isImageLocal,
    Expression<bool> isDraft,
    Expression<bool> isCurrentUpdate,
    Expression<String> description,
    Expression<String> color,
    Expression<String> businessId,
    Expression<String> supplierId,
    Expression<String> categoryId,
    Expression<String> taxId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (picture != null) 'picture': picture,
      if (active != null) 'active': active,
      if (hasPicture != null) 'has_picture': hasPicture,
      if (isImageLocal != null) 'is_image_local': isImageLocal,
      if (isDraft != null) 'is_draft': isDraft,
      if (isCurrentUpdate != null) 'is_current_update': isCurrentUpdate,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (businessId != null) 'business_id': businessId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (categoryId != null) 'category_id': categoryId,
      if (taxId != null) 'tax_id': taxId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ProductTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<String> picture,
      Value<bool> active,
      Value<bool> hasPicture,
      Value<bool> isImageLocal,
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
      isImageLocal: isImageLocal ?? this.isImageLocal,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (hasPicture.present) {
      map['has_picture'] = Variable<bool>(hasPicture.value);
    }
    if (isImageLocal.present) {
      map['is_image_local'] = Variable<bool>(isImageLocal.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (isCurrentUpdate.present) {
      map['is_current_update'] = Variable<bool>(isCurrentUpdate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (taxId.present) {
      map['tax_id'] = Variable<String>(taxId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('picture: $picture, ')
          ..write('active: $active, ')
          ..write('hasPicture: $hasPicture, ')
          ..write('isImageLocal: $isImageLocal, ')
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

  final VerificationMeta _isImageLocalMeta =
      const VerificationMeta('isImageLocal');
  GeneratedBoolColumn _isImageLocal;
  @override
  GeneratedBoolColumn get isImageLocal =>
      _isImageLocal ??= _constructIsImageLocal();
  GeneratedBoolColumn _constructIsImageLocal() {
    return GeneratedBoolColumn('is_image_local', $tableName, false,
        defaultValue: Constant(true));
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
      true,
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
        picture,
        active,
        hasPicture,
        isImageLocal,
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
  VerificationContext validateIntegrity(Insertable<ProductTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture'], _pictureMeta));
    } else if (isInserting) {
      context.missing(_pictureMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active'], _activeMeta));
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('has_picture')) {
      context.handle(
          _hasPictureMeta,
          hasPicture.isAcceptableOrUnknown(
              data['has_picture'], _hasPictureMeta));
    } else if (isInserting) {
      context.missing(_hasPictureMeta);
    }
    if (data.containsKey('is_image_local')) {
      context.handle(
          _isImageLocalMeta,
          isImageLocal.isAcceptableOrUnknown(
              data['is_image_local'], _isImageLocalMeta));
    }
    if (data.containsKey('is_draft')) {
      context.handle(_isDraftMeta,
          isDraft.isAcceptableOrUnknown(data['is_draft'], _isDraftMeta));
    } else if (isInserting) {
      context.missing(_isDraftMeta);
    }
    if (data.containsKey('is_current_update')) {
      context.handle(
          _isCurrentUpdateMeta,
          isCurrentUpdate.isAcceptableOrUnknown(
              data['is_current_update'], _isCurrentUpdateMeta));
    } else if (isInserting) {
      context.missing(_isCurrentUpdateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id'], _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id'], _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    }
    if (data.containsKey('tax_id')) {
      context.handle(
          _taxIdMeta, taxId.isAcceptableOrUnknown(data['tax_id'], _taxIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TokenTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<TokenTableData> custom({
    Expression<int> id,
    Expression<String> token,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokenTableCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<TokenTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token'], _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || businessId != null) {
      map['business_id'] = Variable<String>(businessId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BusinessUserTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<BusinessUserTableData> custom({
    Expression<int> id,
    Expression<String> userId,
    Expression<String> businessId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (businessId != null) 'business_id': businessId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessUserTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('businessId: $businessId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(
      Insertable<BusinessUserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id'], _businessIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tab != null) {
      map['tab'] = Variable<int>(tab);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TabsTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<TabsTableData> custom({
    Expression<int> id,
    Expression<int> tab,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tab != null) 'tab': tab,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tab.present) {
      map['tab'] = Variable<int>(tab.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TabsTableCompanion(')
          ..write('id: $id, ')
          ..write('tab: $tab, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<TabsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tab')) {
      context.handle(
          _tabMeta, tab.isAcceptableOrUnknown(data['tab'], _tabMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  final bool isActive;
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
      @required this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  factory VariationTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
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
      isActive:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool>(isActive);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  VariationTableCompanion toCompanion(bool nullToAbsent) {
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
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
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
      isActive: serializer.fromJson<bool>(json['isActive']),
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
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  VariationTableData copyWith(
          {int idLocal,
          String id,
          String name,
          String sku,
          String unit,
          String productId,
          bool isActive,
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
        isActive: isActive ?? this.isActive,
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
          ..write('isActive: $isActive, ')
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
                              isActive.hashCode,
                              $mrjc(
                                  createdAt.hashCode,
                                  $mrjc(updatedAt.hashCode,
                                      deletedAt.hashCode))))))))));
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
          other.isActive == this.isActive &&
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
  final Value<bool> isActive;
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
    this.isActive = const Value.absent(),
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
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        productId = Value(productId);
  static Insertable<VariationTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> name,
    Expression<String> sku,
    Expression<String> unit,
    Expression<String> productId,
    Expression<bool> isActive,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (unit != null) 'unit': unit,
      if (productId != null) 'product_id': productId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  VariationTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> name,
      Value<String> sku,
      Value<String> unit,
      Value<String> productId,
      Value<bool> isActive,
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
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariationTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('unit: $unit, ')
          ..write('productId: $productId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
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

  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  GeneratedBoolColumn _isActive;
  @override
  GeneratedBoolColumn get isActive => _isActive ??= _constructIsActive();
  GeneratedBoolColumn _constructIsActive() {
    return GeneratedBoolColumn('is_active', $tableName, false,
        defaultValue: Constant(false));
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
        isActive,
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
  VerificationContext validateIntegrity(Insertable<VariationTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku'], _skuMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit'], _unitMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id'], _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active'], _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  final String action;
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
      @required this.action,
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
      action:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}action']),
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || currentStock != null) {
      map['current_stock'] = Variable<int>(currentStock);
    }
    if (!nullToAbsent || lowStock != null) {
      map['low_stock'] = Variable<int>(lowStock);
    }
    if (!nullToAbsent || canTrackingStock != null) {
      map['can_tracking_stock'] = Variable<bool>(canTrackingStock);
    }
    if (!nullToAbsent || showLowStockAlert != null) {
      map['show_low_stock_alert'] = Variable<bool>(showLowStockAlert);
    }
    if (!nullToAbsent || action != null) {
      map['action'] = Variable<String>(action);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool>(isActive);
    }
    if (!nullToAbsent || supplyPrice != null) {
      map['supply_price'] = Variable<double>(supplyPrice);
    }
    if (!nullToAbsent || retailPrice != null) {
      map['retail_price'] = Variable<double>(retailPrice);
    }
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  StockTableCompanion toCompanion(bool nullToAbsent) {
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
      action:
          action == null && nullToAbsent ? const Value.absent() : Value(action),
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
      action: serializer.fromJson<String>(json['action']),
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
      'action': serializer.toJson<String>(action),
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

  StockTableData copyWith(
          {int idLocal,
          String id,
          int currentStock,
          int lowStock,
          bool canTrackingStock,
          bool showLowStockAlert,
          String action,
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
        action: action ?? this.action,
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
          ..write('action: $action, ')
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
                              action.hashCode,
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
                                                              updatedAt
                                                                  .hashCode,
                                                              deletedAt
                                                                  .hashCode))))))))))))))));
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
          other.action == this.action &&
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
  final Value<String> action;
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
    this.action = const Value.absent(),
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
    this.action = const Value.absent(),
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
  static Insertable<StockTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<int> currentStock,
    Expression<int> lowStock,
    Expression<bool> canTrackingStock,
    Expression<bool> showLowStockAlert,
    Expression<String> action,
    Expression<bool> isActive,
    Expression<double> supplyPrice,
    Expression<double> retailPrice,
    Expression<String> variantId,
    Expression<String> branchId,
    Expression<String> productId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (currentStock != null) 'current_stock': currentStock,
      if (lowStock != null) 'low_stock': lowStock,
      if (canTrackingStock != null) 'can_tracking_stock': canTrackingStock,
      if (showLowStockAlert != null) 'show_low_stock_alert': showLowStockAlert,
      if (action != null) 'action': action,
      if (isActive != null) 'is_active': isActive,
      if (supplyPrice != null) 'supply_price': supplyPrice,
      if (retailPrice != null) 'retail_price': retailPrice,
      if (variantId != null) 'variant_id': variantId,
      if (branchId != null) 'branch_id': branchId,
      if (productId != null) 'product_id': productId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  StockTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<int> currentStock,
      Value<int> lowStock,
      Value<bool> canTrackingStock,
      Value<bool> showLowStockAlert,
      Value<String> action,
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
      action: action ?? this.action,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<int>(currentStock.value);
    }
    if (lowStock.present) {
      map['low_stock'] = Variable<int>(lowStock.value);
    }
    if (canTrackingStock.present) {
      map['can_tracking_stock'] = Variable<bool>(canTrackingStock.value);
    }
    if (showLowStockAlert.present) {
      map['show_low_stock_alert'] = Variable<bool>(showLowStockAlert.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (supplyPrice.present) {
      map['supply_price'] = Variable<double>(supplyPrice.value);
    }
    if (retailPrice.present) {
      map['retail_price'] = Variable<double>(retailPrice.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('currentStock: $currentStock, ')
          ..write('lowStock: $lowStock, ')
          ..write('canTrackingStock: $canTrackingStock, ')
          ..write('showLowStockAlert: $showLowStockAlert, ')
          ..write('action: $action, ')
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

  final VerificationMeta _actionMeta = const VerificationMeta('action');
  GeneratedTextColumn _action;
  @override
  GeneratedTextColumn get action => _action ??= _constructAction();
  GeneratedTextColumn _constructAction() {
    return GeneratedTextColumn('action', $tableName, false,
        defaultValue: Constant('ADD'));
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
        action,
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
  VerificationContext validateIntegrity(Insertable<StockTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock'], _currentStockMeta));
    }
    if (data.containsKey('low_stock')) {
      context.handle(_lowStockMeta,
          lowStock.isAcceptableOrUnknown(data['low_stock'], _lowStockMeta));
    }
    if (data.containsKey('can_tracking_stock')) {
      context.handle(
          _canTrackingStockMeta,
          canTrackingStock.isAcceptableOrUnknown(
              data['can_tracking_stock'], _canTrackingStockMeta));
    }
    if (data.containsKey('show_low_stock_alert')) {
      context.handle(
          _showLowStockAlertMeta,
          showLowStockAlert.isAcceptableOrUnknown(
              data['show_low_stock_alert'], _showLowStockAlertMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action'], _actionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active'], _isActiveMeta));
    }
    if (data.containsKey('supply_price')) {
      context.handle(
          _supplyPriceMeta,
          supplyPrice.isAcceptableOrUnknown(
              data['supply_price'], _supplyPriceMeta));
    }
    if (data.containsKey('retail_price')) {
      context.handle(
          _retailPriceMeta,
          retailPrice.isAcceptableOrUnknown(
              data['retail_price'], _retailPriceMeta));
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id'], _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id'], _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id'], _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  $StockTableTable createAlias(String alias) {
    return $StockTableTable(_db, alias);
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || stockId != null) {
      map['stock_id'] = Variable<String>(stockId);
    }
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  StockHistoryTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<StockHistoryTableData> custom({
    Expression<int> idLocal,
    Expression<int> quantity,
    Expression<String> note,
    Expression<String> id,
    Expression<String> reason,
    Expression<String> stockId,
    Expression<String> variantId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (id != null) 'id': id,
      if (reason != null) 'reason': reason,
      if (stockId != null) 'stock_id': stockId,
      if (variantId != null) 'variant_id': variantId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (stockId.present) {
      map['stock_id'] = Variable<String>(stockId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHistoryTableCompanion(')
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
  VerificationContext validateIntegrity(
      Insertable<StockHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity'], _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note'], _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason'], _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('stock_id')) {
      context.handle(_stockIdMeta,
          stockId.isAcceptableOrUnknown(data['stock_id'], _stockIdMeta));
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id'], _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  $StockHistoryTableTable createAlias(String alias) {
    return $StockHistoryTableTable(_db, alias);
  }
}

class OrderDetailTableData extends DataClass
    implements Insertable<OrderDetailTableData> {
  final int idLocal;
  final String id;
  final String branchId;
  final int discountRate;
  final int discountAmount;
  final String unit;
  final String note;
  final int taxRate;
  final double taxAmount;
  final double quantity;
  final double subTotal;
  final String orderId;
  final String stockId;
  final String variationId;
  final String variantName;
  final String productName;
  final DateTime createdAt;
  final DateTime updatedAt;
  OrderDetailTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.branchId,
      @required this.discountRate,
      @required this.discountAmount,
      @required this.unit,
      @required this.note,
      @required this.taxRate,
      @required this.taxAmount,
      @required this.quantity,
      @required this.subTotal,
      @required this.orderId,
      @required this.stockId,
      @required this.variationId,
      @required this.variantName,
      @required this.productName,
      this.createdAt,
      this.updatedAt});
  factory OrderDetailTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return OrderDetailTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      discountRate: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}discount_rate']),
      discountAmount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}discount_amount']),
      unit: stringType.mapFromDatabaseResponse(data['${effectivePrefix}unit']),
      note: stringType.mapFromDatabaseResponse(data['${effectivePrefix}note']),
      taxRate:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tax_rate']),
      taxAmount: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_amount']),
      quantity: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity']),
      subTotal: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_total']),
      orderId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_id']),
      stockId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}stock_id']),
      variationId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variation_id']),
      variantName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}variant_name']),
      productName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}product_name']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || discountRate != null) {
      map['discount_rate'] = Variable<int>(discountRate);
    }
    if (!nullToAbsent || discountAmount != null) {
      map['discount_amount'] = Variable<int>(discountAmount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || taxRate != null) {
      map['tax_rate'] = Variable<int>(taxRate);
    }
    if (!nullToAbsent || taxAmount != null) {
      map['tax_amount'] = Variable<double>(taxAmount);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || subTotal != null) {
      map['sub_total'] = Variable<double>(subTotal);
    }
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    if (!nullToAbsent || stockId != null) {
      map['stock_id'] = Variable<String>(stockId);
    }
    if (!nullToAbsent || variationId != null) {
      map['variation_id'] = Variable<String>(variationId);
    }
    if (!nullToAbsent || variantName != null) {
      map['variant_name'] = Variable<String>(variantName);
    }
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  OrderDetailTableCompanion toCompanion(bool nullToAbsent) {
    return OrderDetailTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      discountRate: discountRate == null && nullToAbsent
          ? const Value.absent()
          : Value(discountRate),
      discountAmount: discountAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAmount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      taxRate: taxRate == null && nullToAbsent
          ? const Value.absent()
          : Value(taxRate),
      taxAmount: taxAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(taxAmount),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      subTotal: subTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(subTotal),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      stockId: stockId == null && nullToAbsent
          ? const Value.absent()
          : Value(stockId),
      variationId: variationId == null && nullToAbsent
          ? const Value.absent()
          : Value(variationId),
      variantName: variantName == null && nullToAbsent
          ? const Value.absent()
          : Value(variantName),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory OrderDetailTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OrderDetailTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      discountRate: serializer.fromJson<int>(json['discountRate']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      unit: serializer.fromJson<String>(json['unit']),
      note: serializer.fromJson<String>(json['note']),
      taxRate: serializer.fromJson<int>(json['taxRate']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      quantity: serializer.fromJson<double>(json['quantity']),
      subTotal: serializer.fromJson<double>(json['subTotal']),
      orderId: serializer.fromJson<String>(json['orderId']),
      stockId: serializer.fromJson<String>(json['stockId']),
      variationId: serializer.fromJson<String>(json['variationId']),
      variantName: serializer.fromJson<String>(json['variantName']),
      productName: serializer.fromJson<String>(json['productName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'discountRate': serializer.toJson<int>(discountRate),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'unit': serializer.toJson<String>(unit),
      'note': serializer.toJson<String>(note),
      'taxRate': serializer.toJson<int>(taxRate),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'quantity': serializer.toJson<double>(quantity),
      'subTotal': serializer.toJson<double>(subTotal),
      'orderId': serializer.toJson<String>(orderId),
      'stockId': serializer.toJson<String>(stockId),
      'variationId': serializer.toJson<String>(variationId),
      'variantName': serializer.toJson<String>(variantName),
      'productName': serializer.toJson<String>(productName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrderDetailTableData copyWith(
          {int idLocal,
          String id,
          String branchId,
          int discountRate,
          int discountAmount,
          String unit,
          String note,
          int taxRate,
          double taxAmount,
          double quantity,
          double subTotal,
          String orderId,
          String stockId,
          String variationId,
          String variantName,
          String productName,
          DateTime createdAt,
          DateTime updatedAt}) =>
      OrderDetailTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        discountRate: discountRate ?? this.discountRate,
        discountAmount: discountAmount ?? this.discountAmount,
        unit: unit ?? this.unit,
        note: note ?? this.note,
        taxRate: taxRate ?? this.taxRate,
        taxAmount: taxAmount ?? this.taxAmount,
        quantity: quantity ?? this.quantity,
        subTotal: subTotal ?? this.subTotal,
        orderId: orderId ?? this.orderId,
        stockId: stockId ?? this.stockId,
        variationId: variationId ?? this.variationId,
        variantName: variantName ?? this.variantName,
        productName: productName ?? this.productName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('OrderDetailTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('discountRate: $discountRate, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('quantity: $quantity, ')
          ..write('subTotal: $subTotal, ')
          ..write('orderId: $orderId, ')
          ..write('stockId: $stockId, ')
          ..write('variationId: $variationId, ')
          ..write('variantName: $variantName, ')
          ..write('productName: $productName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              branchId.hashCode,
              $mrjc(
                  discountRate.hashCode,
                  $mrjc(
                      discountAmount.hashCode,
                      $mrjc(
                          unit.hashCode,
                          $mrjc(
                              note.hashCode,
                              $mrjc(
                                  taxRate.hashCode,
                                  $mrjc(
                                      taxAmount.hashCode,
                                      $mrjc(
                                          quantity.hashCode,
                                          $mrjc(
                                              subTotal.hashCode,
                                              $mrjc(
                                                  orderId.hashCode,
                                                  $mrjc(
                                                      stockId.hashCode,
                                                      $mrjc(
                                                          variationId.hashCode,
                                                          $mrjc(
                                                              variantName
                                                                  .hashCode,
                                                              $mrjc(
                                                                  productName
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      createdAt
                                                                          .hashCode,
                                                                      updatedAt
                                                                          .hashCode))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OrderDetailTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.discountRate == this.discountRate &&
          other.discountAmount == this.discountAmount &&
          other.unit == this.unit &&
          other.note == this.note &&
          other.taxRate == this.taxRate &&
          other.taxAmount == this.taxAmount &&
          other.quantity == this.quantity &&
          other.subTotal == this.subTotal &&
          other.orderId == this.orderId &&
          other.stockId == this.stockId &&
          other.variationId == this.variationId &&
          other.variantName == this.variantName &&
          other.productName == this.productName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrderDetailTableCompanion extends UpdateCompanion<OrderDetailTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<String> branchId;
  final Value<int> discountRate;
  final Value<int> discountAmount;
  final Value<String> unit;
  final Value<String> note;
  final Value<int> taxRate;
  final Value<double> taxAmount;
  final Value<double> quantity;
  final Value<double> subTotal;
  final Value<String> orderId;
  final Value<String> stockId;
  final Value<String> variationId;
  final Value<String> variantName;
  final Value<String> productName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrderDetailTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.discountRate = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.quantity = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.orderId = const Value.absent(),
    this.stockId = const Value.absent(),
    this.variationId = const Value.absent(),
    this.variantName = const Value.absent(),
    this.productName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrderDetailTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required String branchId,
    @required int discountRate,
    @required int discountAmount,
    @required String unit,
    @required String note,
    @required int taxRate,
    @required double taxAmount,
    @required double quantity,
    @required double subTotal,
    @required String orderId,
    @required String stockId,
    @required String variationId,
    @required String variantName,
    @required String productName,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : id = Value(id),
        branchId = Value(branchId),
        discountRate = Value(discountRate),
        discountAmount = Value(discountAmount),
        unit = Value(unit),
        note = Value(note),
        taxRate = Value(taxRate),
        taxAmount = Value(taxAmount),
        quantity = Value(quantity),
        subTotal = Value(subTotal),
        orderId = Value(orderId),
        stockId = Value(stockId),
        variationId = Value(variationId),
        variantName = Value(variantName),
        productName = Value(productName);
  static Insertable<OrderDetailTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> branchId,
    Expression<int> discountRate,
    Expression<int> discountAmount,
    Expression<String> unit,
    Expression<String> note,
    Expression<int> taxRate,
    Expression<double> taxAmount,
    Expression<double> quantity,
    Expression<double> subTotal,
    Expression<String> orderId,
    Expression<String> stockId,
    Expression<String> variationId,
    Expression<String> variantName,
    Expression<String> productName,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (discountRate != null) 'discount_rate': discountRate,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (quantity != null) 'quantity': quantity,
      if (subTotal != null) 'sub_total': subTotal,
      if (orderId != null) 'order_id': orderId,
      if (stockId != null) 'stock_id': stockId,
      if (variationId != null) 'variation_id': variationId,
      if (variantName != null) 'variant_name': variantName,
      if (productName != null) 'product_name': productName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrderDetailTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<String> branchId,
      Value<int> discountRate,
      Value<int> discountAmount,
      Value<String> unit,
      Value<String> note,
      Value<int> taxRate,
      Value<double> taxAmount,
      Value<double> quantity,
      Value<double> subTotal,
      Value<String> orderId,
      Value<String> stockId,
      Value<String> variationId,
      Value<String> variantName,
      Value<String> productName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return OrderDetailTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      discountRate: discountRate ?? this.discountRate,
      discountAmount: discountAmount ?? this.discountAmount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
      orderId: orderId ?? this.orderId,
      stockId: stockId ?? this.stockId,
      variationId: variationId ?? this.variationId,
      variantName: variantName ?? this.variantName,
      productName: productName ?? this.productName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (discountRate.present) {
      map['discount_rate'] = Variable<int>(discountRate.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<int>(taxRate.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (subTotal.present) {
      map['sub_total'] = Variable<double>(subTotal.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (stockId.present) {
      map['stock_id'] = Variable<String>(stockId.value);
    }
    if (variationId.present) {
      map['variation_id'] = Variable<String>(variationId.value);
    }
    if (variantName.present) {
      map['variant_name'] = Variable<String>(variantName.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderDetailTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('discountRate: $discountRate, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('quantity: $quantity, ')
          ..write('subTotal: $subTotal, ')
          ..write('orderId: $orderId, ')
          ..write('stockId: $stockId, ')
          ..write('variationId: $variationId, ')
          ..write('variantName: $variantName, ')
          ..write('productName: $productName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderDetailTableTable extends OrderDetailTable
    with TableInfo<$OrderDetailTableTable, OrderDetailTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $OrderDetailTableTable(this._db, [this._alias]);
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
      false,
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
      false,
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

  final VerificationMeta _taxRateMeta = const VerificationMeta('taxRate');
  GeneratedIntColumn _taxRate;
  @override
  GeneratedIntColumn get taxRate => _taxRate ??= _constructTaxRate();
  GeneratedIntColumn _constructTaxRate() {
    return GeneratedIntColumn(
      'tax_rate',
      $tableName,
      false,
    );
  }

  final VerificationMeta _taxAmountMeta = const VerificationMeta('taxAmount');
  GeneratedRealColumn _taxAmount;
  @override
  GeneratedRealColumn get taxAmount => _taxAmount ??= _constructTaxAmount();
  GeneratedRealColumn _constructTaxAmount() {
    return GeneratedRealColumn(
      'tax_amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  GeneratedRealColumn _quantity;
  @override
  GeneratedRealColumn get quantity => _quantity ??= _constructQuantity();
  GeneratedRealColumn _constructQuantity() {
    return GeneratedRealColumn(
      'quantity',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subTotalMeta = const VerificationMeta('subTotal');
  GeneratedRealColumn _subTotal;
  @override
  GeneratedRealColumn get subTotal => _subTotal ??= _constructSubTotal();
  GeneratedRealColumn _constructSubTotal() {
    return GeneratedRealColumn(
      'sub_total',
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
      false,
    );
  }

  final VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  GeneratedTextColumn _productName;
  @override
  GeneratedTextColumn get productName =>
      _productName ??= _constructProductName();
  GeneratedTextColumn _constructProductName() {
    return GeneratedTextColumn(
      'product_name',
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
        id,
        branchId,
        discountRate,
        discountAmount,
        unit,
        note,
        taxRate,
        taxAmount,
        quantity,
        subTotal,
        orderId,
        stockId,
        variationId,
        variantName,
        productName,
        createdAt,
        updatedAt
      ];
  @override
  $OrderDetailTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'order_detail_table';
  @override
  final String actualTableName = 'order_detail_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<OrderDetailTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id'], _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('discount_rate')) {
      context.handle(
          _discountRateMeta,
          discountRate.isAcceptableOrUnknown(
              data['discount_rate'], _discountRateMeta));
    } else if (isInserting) {
      context.missing(_discountRateMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount'], _discountAmountMeta));
    } else if (isInserting) {
      context.missing(_discountAmountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit'], _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note'], _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate'], _taxRateMeta));
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount'], _taxAmountMeta));
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity'], _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('sub_total')) {
      context.handle(_subTotalMeta,
          subTotal.isAcceptableOrUnknown(data['sub_total'], _subTotalMeta));
    } else if (isInserting) {
      context.missing(_subTotalMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id'], _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('stock_id')) {
      context.handle(_stockIdMeta,
          stockId.isAcceptableOrUnknown(data['stock_id'], _stockIdMeta));
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('variation_id')) {
      context.handle(
          _variationIdMeta,
          variationId.isAcceptableOrUnknown(
              data['variation_id'], _variationIdMeta));
    } else if (isInserting) {
      context.missing(_variationIdMeta);
    }
    if (data.containsKey('variant_name')) {
      context.handle(
          _variantNameMeta,
          variantName.isAcceptableOrUnknown(
              data['variant_name'], _variantNameMeta));
    } else if (isInserting) {
      context.missing(_variantNameMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name'], _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  OrderDetailTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return OrderDetailTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $OrderDetailTableTable createAlias(String alias) {
    return $OrderDetailTableTable(_db, alias);
  }
}

class OrderTableData extends DataClass implements Insertable<OrderTableData> {
  final int idLocal;
  final String id;
  final int userId;
  final String branchId;
  final String deviceId;
  final String currency;
  final String reference;
  final int orderNUmber;
  final int supplierId;
  final int subTotal;
  final int supplierInvoiceNumber;
  final DateTime deliverDate;
  final DateTime orderDate;
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
  final bool isDraft;
  final String status;
  final String orderType;
  final int customerChangeDue;
  OrderTableData(
      {@required this.idLocal,
      @required this.id,
      @required this.userId,
      @required this.branchId,
      this.deviceId,
      this.currency,
      this.reference,
      this.orderNUmber,
      this.supplierId,
      this.subTotal,
      this.supplierInvoiceNumber,
      this.deliverDate,
      this.orderDate,
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
      @required this.isDraft,
      @required this.status,
      @required this.orderType,
      this.customerChangeDue});
  factory OrderTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return OrderTableData(
      idLocal:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}id_local']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      branchId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}branch_id']),
      deviceId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}device_id']),
      currency: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}currency']),
      reference: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reference']),
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
      orderDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_date']),
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
      isDraft:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_draft']),
      status:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
      orderType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_type']),
      customerChangeDue: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}customer_change_due']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || orderNUmber != null) {
      map['order_n_umber'] = Variable<int>(orderNUmber);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    if (!nullToAbsent || subTotal != null) {
      map['sub_total'] = Variable<int>(subTotal);
    }
    if (!nullToAbsent || supplierInvoiceNumber != null) {
      map['supplier_invoice_number'] = Variable<int>(supplierInvoiceNumber);
    }
    if (!nullToAbsent || deliverDate != null) {
      map['deliver_date'] = Variable<DateTime>(deliverDate);
    }
    if (!nullToAbsent || orderDate != null) {
      map['order_date'] = Variable<DateTime>(orderDate);
    }
    if (!nullToAbsent || taxRate != null) {
      map['tax_rate'] = Variable<int>(taxRate);
    }
    if (!nullToAbsent || taxAmount != null) {
      map['tax_amount'] = Variable<int>(taxAmount);
    }
    if (!nullToAbsent || count != null) {
      map['count'] = Variable<int>(count);
    }
    if (!nullToAbsent || variantName != null) {
      map['variant_name'] = Variable<String>(variantName);
    }
    if (!nullToAbsent || discountRate != null) {
      map['discount_rate'] = Variable<int>(discountRate);
    }
    if (!nullToAbsent || discountAmount != null) {
      map['discount_amount'] = Variable<int>(discountAmount);
    }
    if (!nullToAbsent || cashReceived != null) {
      map['cash_received'] = Variable<int>(cashReceived);
    }
    if (!nullToAbsent || saleTotal != null) {
      map['sale_total'] = Variable<int>(saleTotal);
    }
    if (!nullToAbsent || customerSaving != null) {
      map['customer_saving'] = Variable<int>(customerSaving);
    }
    if (!nullToAbsent || paymentId != null) {
      map['payment_id'] = Variable<int>(paymentId);
    }
    if (!nullToAbsent || orderNote != null) {
      map['order_note'] = Variable<String>(orderNote);
    }
    if (!nullToAbsent || isDraft != null) {
      map['is_draft'] = Variable<bool>(isDraft);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || orderType != null) {
      map['order_type'] = Variable<String>(orderType);
    }
    if (!nullToAbsent || customerChangeDue != null) {
      map['customer_change_due'] = Variable<int>(customerChangeDue);
    }
    return map;
  }

  OrderTableCompanion toCompanion(bool nullToAbsent) {
    return OrderTableCompanion(
      idLocal: idLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(idLocal),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
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
      orderDate: orderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(orderDate),
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
      isDraft: isDraft == null && nullToAbsent
          ? const Value.absent()
          : Value(isDraft),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      orderType: orderType == null && nullToAbsent
          ? const Value.absent()
          : Value(orderType),
      customerChangeDue: customerChangeDue == null && nullToAbsent
          ? const Value.absent()
          : Value(customerChangeDue),
    );
  }

  factory OrderTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OrderTableData(
      idLocal: serializer.fromJson<int>(json['idLocal']),
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      branchId: serializer.fromJson<String>(json['branchId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      currency: serializer.fromJson<String>(json['currency']),
      reference: serializer.fromJson<String>(json['reference']),
      orderNUmber: serializer.fromJson<int>(json['orderNUmber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      subTotal: serializer.fromJson<int>(json['subTotal']),
      supplierInvoiceNumber:
          serializer.fromJson<int>(json['supplierInvoiceNumber']),
      deliverDate: serializer.fromJson<DateTime>(json['deliverDate']),
      orderDate: serializer.fromJson<DateTime>(json['orderDate']),
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
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      status: serializer.fromJson<String>(json['status']),
      orderType: serializer.fromJson<String>(json['orderType']),
      customerChangeDue: serializer.fromJson<int>(json['customerChangeDue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idLocal': serializer.toJson<int>(idLocal),
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<int>(userId),
      'branchId': serializer.toJson<String>(branchId),
      'deviceId': serializer.toJson<String>(deviceId),
      'currency': serializer.toJson<String>(currency),
      'reference': serializer.toJson<String>(reference),
      'orderNUmber': serializer.toJson<int>(orderNUmber),
      'supplierId': serializer.toJson<int>(supplierId),
      'subTotal': serializer.toJson<int>(subTotal),
      'supplierInvoiceNumber': serializer.toJson<int>(supplierInvoiceNumber),
      'deliverDate': serializer.toJson<DateTime>(deliverDate),
      'orderDate': serializer.toJson<DateTime>(orderDate),
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
      'isDraft': serializer.toJson<bool>(isDraft),
      'status': serializer.toJson<String>(status),
      'orderType': serializer.toJson<String>(orderType),
      'customerChangeDue': serializer.toJson<int>(customerChangeDue),
    };
  }

  OrderTableData copyWith(
          {int idLocal,
          String id,
          int userId,
          String branchId,
          String deviceId,
          String currency,
          String reference,
          int orderNUmber,
          int supplierId,
          int subTotal,
          int supplierInvoiceNumber,
          DateTime deliverDate,
          DateTime orderDate,
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
          bool isDraft,
          String status,
          String orderType,
          int customerChangeDue}) =>
      OrderTableData(
        idLocal: idLocal ?? this.idLocal,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        branchId: branchId ?? this.branchId,
        deviceId: deviceId ?? this.deviceId,
        currency: currency ?? this.currency,
        reference: reference ?? this.reference,
        orderNUmber: orderNUmber ?? this.orderNUmber,
        supplierId: supplierId ?? this.supplierId,
        subTotal: subTotal ?? this.subTotal,
        supplierInvoiceNumber:
            supplierInvoiceNumber ?? this.supplierInvoiceNumber,
        deliverDate: deliverDate ?? this.deliverDate,
        orderDate: orderDate ?? this.orderDate,
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
        isDraft: isDraft ?? this.isDraft,
        status: status ?? this.status,
        orderType: orderType ?? this.orderType,
        customerChangeDue: customerChangeDue ?? this.customerChangeDue,
      );
  @override
  String toString() {
    return (StringBuffer('OrderTableData(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('branchId: $branchId, ')
          ..write('deviceId: $deviceId, ')
          ..write('currency: $currency, ')
          ..write('reference: $reference, ')
          ..write('orderNUmber: $orderNUmber, ')
          ..write('supplierId: $supplierId, ')
          ..write('subTotal: $subTotal, ')
          ..write('supplierInvoiceNumber: $supplierInvoiceNumber, ')
          ..write('deliverDate: $deliverDate, ')
          ..write('orderDate: $orderDate, ')
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
          ..write('isDraft: $isDraft, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('customerChangeDue: $customerChangeDue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      idLocal.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              userId.hashCode,
              $mrjc(
                  branchId.hashCode,
                  $mrjc(
                      deviceId.hashCode,
                      $mrjc(
                          currency.hashCode,
                          $mrjc(
                              reference.hashCode,
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
                                                      orderDate.hashCode,
                                                      $mrjc(
                                                          taxRate.hashCode,
                                                          $mrjc(
                                                              taxAmount
                                                                  .hashCode,
                                                              $mrjc(
                                                                  count
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      variantName
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          discountRate
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              discountAmount.hashCode,
                                                                              $mrjc(cashReceived.hashCode, $mrjc(saleTotal.hashCode, $mrjc(customerSaving.hashCode, $mrjc(paymentId.hashCode, $mrjc(orderNote.hashCode, $mrjc(isDraft.hashCode, $mrjc(status.hashCode, $mrjc(orderType.hashCode, customerChangeDue.hashCode))))))))))))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OrderTableData &&
          other.idLocal == this.idLocal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.branchId == this.branchId &&
          other.deviceId == this.deviceId &&
          other.currency == this.currency &&
          other.reference == this.reference &&
          other.orderNUmber == this.orderNUmber &&
          other.supplierId == this.supplierId &&
          other.subTotal == this.subTotal &&
          other.supplierInvoiceNumber == this.supplierInvoiceNumber &&
          other.deliverDate == this.deliverDate &&
          other.orderDate == this.orderDate &&
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
          other.isDraft == this.isDraft &&
          other.status == this.status &&
          other.orderType == this.orderType &&
          other.customerChangeDue == this.customerChangeDue);
}

class OrderTableCompanion extends UpdateCompanion<OrderTableData> {
  final Value<int> idLocal;
  final Value<String> id;
  final Value<int> userId;
  final Value<String> branchId;
  final Value<String> deviceId;
  final Value<String> currency;
  final Value<String> reference;
  final Value<int> orderNUmber;
  final Value<int> supplierId;
  final Value<int> subTotal;
  final Value<int> supplierInvoiceNumber;
  final Value<DateTime> deliverDate;
  final Value<DateTime> orderDate;
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
  final Value<bool> isDraft;
  final Value<String> status;
  final Value<String> orderType;
  final Value<int> customerChangeDue;
  const OrderTableCompanion({
    this.idLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.currency = const Value.absent(),
    this.reference = const Value.absent(),
    this.orderNUmber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.supplierInvoiceNumber = const Value.absent(),
    this.deliverDate = const Value.absent(),
    this.orderDate = const Value.absent(),
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
    this.isDraft = const Value.absent(),
    this.status = const Value.absent(),
    this.orderType = const Value.absent(),
    this.customerChangeDue = const Value.absent(),
  });
  OrderTableCompanion.insert({
    this.idLocal = const Value.absent(),
    @required String id,
    @required int userId,
    @required String branchId,
    this.deviceId = const Value.absent(),
    this.currency = const Value.absent(),
    this.reference = const Value.absent(),
    this.orderNUmber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.supplierInvoiceNumber = const Value.absent(),
    this.deliverDate = const Value.absent(),
    this.orderDate = const Value.absent(),
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
    this.isDraft = const Value.absent(),
    this.status = const Value.absent(),
    this.orderType = const Value.absent(),
    this.customerChangeDue = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        branchId = Value(branchId);
  static Insertable<OrderTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<int> userId,
    Expression<String> branchId,
    Expression<String> deviceId,
    Expression<String> currency,
    Expression<String> reference,
    Expression<int> orderNUmber,
    Expression<int> supplierId,
    Expression<int> subTotal,
    Expression<int> supplierInvoiceNumber,
    Expression<DateTime> deliverDate,
    Expression<DateTime> orderDate,
    Expression<int> taxRate,
    Expression<int> taxAmount,
    Expression<int> count,
    Expression<String> variantName,
    Expression<int> discountRate,
    Expression<int> discountAmount,
    Expression<int> cashReceived,
    Expression<int> saleTotal,
    Expression<int> customerSaving,
    Expression<int> paymentId,
    Expression<String> orderNote,
    Expression<bool> isDraft,
    Expression<String> status,
    Expression<String> orderType,
    Expression<int> customerChangeDue,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (branchId != null) 'branch_id': branchId,
      if (deviceId != null) 'device_id': deviceId,
      if (currency != null) 'currency': currency,
      if (reference != null) 'reference': reference,
      if (orderNUmber != null) 'order_n_umber': orderNUmber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (subTotal != null) 'sub_total': subTotal,
      if (supplierInvoiceNumber != null)
        'supplier_invoice_number': supplierInvoiceNumber,
      if (deliverDate != null) 'deliver_date': deliverDate,
      if (orderDate != null) 'order_date': orderDate,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (count != null) 'count': count,
      if (variantName != null) 'variant_name': variantName,
      if (discountRate != null) 'discount_rate': discountRate,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (cashReceived != null) 'cash_received': cashReceived,
      if (saleTotal != null) 'sale_total': saleTotal,
      if (customerSaving != null) 'customer_saving': customerSaving,
      if (paymentId != null) 'payment_id': paymentId,
      if (orderNote != null) 'order_note': orderNote,
      if (isDraft != null) 'is_draft': isDraft,
      if (status != null) 'status': status,
      if (orderType != null) 'order_type': orderType,
      if (customerChangeDue != null) 'customer_change_due': customerChangeDue,
    });
  }

  OrderTableCompanion copyWith(
      {Value<int> idLocal,
      Value<String> id,
      Value<int> userId,
      Value<String> branchId,
      Value<String> deviceId,
      Value<String> currency,
      Value<String> reference,
      Value<int> orderNUmber,
      Value<int> supplierId,
      Value<int> subTotal,
      Value<int> supplierInvoiceNumber,
      Value<DateTime> deliverDate,
      Value<DateTime> orderDate,
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
      Value<bool> isDraft,
      Value<String> status,
      Value<String> orderType,
      Value<int> customerChangeDue}) {
    return OrderTableCompanion(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      branchId: branchId ?? this.branchId,
      deviceId: deviceId ?? this.deviceId,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      orderNUmber: orderNUmber ?? this.orderNUmber,
      supplierId: supplierId ?? this.supplierId,
      subTotal: subTotal ?? this.subTotal,
      supplierInvoiceNumber:
          supplierInvoiceNumber ?? this.supplierInvoiceNumber,
      deliverDate: deliverDate ?? this.deliverDate,
      orderDate: orderDate ?? this.orderDate,
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
      isDraft: isDraft ?? this.isDraft,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      customerChangeDue: customerChangeDue ?? this.customerChangeDue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (orderNUmber.present) {
      map['order_n_umber'] = Variable<int>(orderNUmber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (subTotal.present) {
      map['sub_total'] = Variable<int>(subTotal.value);
    }
    if (supplierInvoiceNumber.present) {
      map['supplier_invoice_number'] =
          Variable<int>(supplierInvoiceNumber.value);
    }
    if (deliverDate.present) {
      map['deliver_date'] = Variable<DateTime>(deliverDate.value);
    }
    if (orderDate.present) {
      map['order_date'] = Variable<DateTime>(orderDate.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<int>(taxRate.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<int>(taxAmount.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (variantName.present) {
      map['variant_name'] = Variable<String>(variantName.value);
    }
    if (discountRate.present) {
      map['discount_rate'] = Variable<int>(discountRate.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (cashReceived.present) {
      map['cash_received'] = Variable<int>(cashReceived.value);
    }
    if (saleTotal.present) {
      map['sale_total'] = Variable<int>(saleTotal.value);
    }
    if (customerSaving.present) {
      map['customer_saving'] = Variable<int>(customerSaving.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (orderNote.present) {
      map['order_note'] = Variable<String>(orderNote.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (customerChangeDue.present) {
      map['customer_change_due'] = Variable<int>(customerChangeDue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('branchId: $branchId, ')
          ..write('deviceId: $deviceId, ')
          ..write('currency: $currency, ')
          ..write('reference: $reference, ')
          ..write('orderNUmber: $orderNUmber, ')
          ..write('supplierId: $supplierId, ')
          ..write('subTotal: $subTotal, ')
          ..write('supplierInvoiceNumber: $supplierInvoiceNumber, ')
          ..write('deliverDate: $deliverDate, ')
          ..write('orderDate: $orderDate, ')
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
          ..write('isDraft: $isDraft, ')
          ..write('status: $status, ')
          ..write('orderType: $orderType, ')
          ..write('customerChangeDue: $customerChangeDue')
          ..write(')'))
        .toString();
  }
}

class $OrderTableTable extends OrderTable
    with TableInfo<$OrderTableTable, OrderTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $OrderTableTable(this._db, [this._alias]);
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

  final VerificationMeta _deviceIdMeta = const VerificationMeta('deviceId');
  GeneratedTextColumn _deviceId;
  @override
  GeneratedTextColumn get deviceId => _deviceId ??= _constructDeviceId();
  GeneratedTextColumn _constructDeviceId() {
    return GeneratedTextColumn(
      'device_id',
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

  final VerificationMeta _referenceMeta = const VerificationMeta('reference');
  GeneratedTextColumn _reference;
  @override
  GeneratedTextColumn get reference => _reference ??= _constructReference();
  GeneratedTextColumn _constructReference() {
    return GeneratedTextColumn(
      'reference',
      $tableName,
      true,
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

  final VerificationMeta _orderDateMeta = const VerificationMeta('orderDate');
  GeneratedDateTimeColumn _orderDate;
  @override
  GeneratedDateTimeColumn get orderDate => _orderDate ??= _constructOrderDate();
  GeneratedDateTimeColumn _constructOrderDate() {
    return GeneratedDateTimeColumn(
      'order_date',
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

  final VerificationMeta _isDraftMeta = const VerificationMeta('isDraft');
  GeneratedBoolColumn _isDraft;
  @override
  GeneratedBoolColumn get isDraft => _isDraft ??= _constructIsDraft();
  GeneratedBoolColumn _constructIsDraft() {
    return GeneratedBoolColumn('is_draft', $tableName, false,
        defaultValue: Constant(true));
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedTextColumn _status;
  @override
  GeneratedTextColumn get status => _status ??= _constructStatus();
  GeneratedTextColumn _constructStatus() {
    return GeneratedTextColumn('status', $tableName, false,
        defaultValue: Constant("draft"));
  }

  final VerificationMeta _orderTypeMeta = const VerificationMeta('orderType');
  GeneratedTextColumn _orderType;
  @override
  GeneratedTextColumn get orderType => _orderType ??= _constructOrderType();
  GeneratedTextColumn _constructOrderType() {
    return GeneratedTextColumn('order_type', $tableName, false,
        defaultValue: Constant("sales"));
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
        idLocal,
        id,
        userId,
        branchId,
        deviceId,
        currency,
        reference,
        orderNUmber,
        supplierId,
        subTotal,
        supplierInvoiceNumber,
        deliverDate,
        orderDate,
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
        isDraft,
        status,
        orderType,
        customerChangeDue
      ];
  @override
  $OrderTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'order_table';
  @override
  final String actualTableName = 'order_table';
  @override
  VerificationContext validateIntegrity(Insertable<OrderTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id'], _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id'], _deviceIdMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency'], _currencyMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference'], _referenceMeta));
    }
    if (data.containsKey('order_n_umber')) {
      context.handle(
          _orderNUmberMeta,
          orderNUmber.isAcceptableOrUnknown(
              data['order_n_umber'], _orderNUmberMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id'], _supplierIdMeta));
    }
    if (data.containsKey('sub_total')) {
      context.handle(_subTotalMeta,
          subTotal.isAcceptableOrUnknown(data['sub_total'], _subTotalMeta));
    }
    if (data.containsKey('supplier_invoice_number')) {
      context.handle(
          _supplierInvoiceNumberMeta,
          supplierInvoiceNumber.isAcceptableOrUnknown(
              data['supplier_invoice_number'], _supplierInvoiceNumberMeta));
    }
    if (data.containsKey('deliver_date')) {
      context.handle(
          _deliverDateMeta,
          deliverDate.isAcceptableOrUnknown(
              data['deliver_date'], _deliverDateMeta));
    }
    if (data.containsKey('order_date')) {
      context.handle(_orderDateMeta,
          orderDate.isAcceptableOrUnknown(data['order_date'], _orderDateMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate'], _taxRateMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount'], _taxAmountMeta));
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count'], _countMeta));
    }
    if (data.containsKey('variant_name')) {
      context.handle(
          _variantNameMeta,
          variantName.isAcceptableOrUnknown(
              data['variant_name'], _variantNameMeta));
    }
    if (data.containsKey('discount_rate')) {
      context.handle(
          _discountRateMeta,
          discountRate.isAcceptableOrUnknown(
              data['discount_rate'], _discountRateMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount'], _discountAmountMeta));
    }
    if (data.containsKey('cash_received')) {
      context.handle(
          _cashReceivedMeta,
          cashReceived.isAcceptableOrUnknown(
              data['cash_received'], _cashReceivedMeta));
    }
    if (data.containsKey('sale_total')) {
      context.handle(_saleTotalMeta,
          saleTotal.isAcceptableOrUnknown(data['sale_total'], _saleTotalMeta));
    }
    if (data.containsKey('customer_saving')) {
      context.handle(
          _customerSavingMeta,
          customerSaving.isAcceptableOrUnknown(
              data['customer_saving'], _customerSavingMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id'], _paymentIdMeta));
    }
    if (data.containsKey('order_note')) {
      context.handle(_orderNoteMeta,
          orderNote.isAcceptableOrUnknown(data['order_note'], _orderNoteMeta));
    }
    if (data.containsKey('is_draft')) {
      context.handle(_isDraftMeta,
          isDraft.isAcceptableOrUnknown(data['is_draft'], _isDraftMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type'], _orderTypeMeta));
    }
    if (data.containsKey('customer_change_due')) {
      context.handle(
          _customerChangeDueMeta,
          customerChangeDue.isAcceptableOrUnknown(
              data['customer_change_due'], _customerChangeDueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idLocal};
  @override
  OrderTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return OrderTableData.fromData(data, _db, prefix: effectivePrefix);
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool>(isActive);
    }
    return map;
  }

  ColorTableCompanion toCompanion(bool nullToAbsent) {
    return ColorTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
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
  static Insertable<ColorTableData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<bool> isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ColorTableCompanion copyWith(
      {Value<int> id, Value<String> name, Value<bool> isActive}) {
    return ColorTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColorTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<ColorTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active'], _isActiveMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || isLocked != null) {
      map['is_locked'] = Variable<bool>(isLocked);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  ActionsTableCompanion toCompanion(bool nullToAbsent) {
    return ActionsTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      isLocked: isLocked == null && nullToAbsent
          ? const Value.absent()
          : Value(isLocked),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
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
  static Insertable<ActionsTableData> custom({
    Expression<int> id,
    Expression<bool> isLocked,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isLocked != null) 'is_locked': isLocked,
      if (name != null) 'name': name,
    });
  }

  ActionsTableCompanion copyWith(
      {Value<int> id, Value<bool> isLocked, Value<String> name}) {
    return ActionsTableCompanion(
      id: id ?? this.id,
      isLocked: isLocked ?? this.isLocked,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionsTableCompanion(')
          ..write('id: $id, ')
          ..write('isLocked: $isLocked, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<ActionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked'], _isLockedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || action != null) {
      map['action'] = Variable<String>(action);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  ReasonTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<ReasonTableData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> action,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<String> deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReasonTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(Insertable<ReasonTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action'], _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isDefault != null) {
      map['is_default'] = Variable<bool>(isDefault);
    }
    if (!nullToAbsent || percentage != null) {
      map['percentage'] = Variable<double>(percentage);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || businessId != null) {
      map['business_id'] = Variable<String>(businessId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TaxTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<TaxTableData> custom({
    Expression<int> idLocal,
    Expression<String> name,
    Expression<bool> isDefault,
    Expression<double> percentage,
    Expression<String> id,
    Expression<String> businessId,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (percentage != null) 'percentage': percentage,
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxTableCompanion(')
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
  VerificationContext validateIntegrity(Insertable<TaxTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default'], _isDefaultMeta));
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage'], _percentageMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id'], _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idLocal != null) {
      map['id_local'] = Variable<int>(idLocal);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    return map;
  }

  BranchProductTableCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<BranchProductTableData> custom({
    Expression<int> idLocal,
    Expression<String> id,
    Expression<String> productId,
    Expression<String> branchId,
  }) {
    return RawValuesInsertable({
      if (idLocal != null) 'id_local': idLocal,
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (branchId != null) 'branch_id': branchId,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idLocal.present) {
      map['id_local'] = Variable<int>(idLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchProductTableCompanion(')
          ..write('idLocal: $idLocal, ')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('branchId: $branchId')
          ..write(')'))
        .toString();
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
  VerificationContext validateIntegrity(
      Insertable<BranchProductTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_local')) {
      context.handle(_idLocalMeta,
          idLocal.isAcceptableOrUnknown(data['id_local'], _idLocalMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id'], _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id'], _branchIdMeta));
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
  $BranchProductTableTable createAlias(String alias) {
    return $BranchProductTableTable(_db, alias);
  }
}

class ProductImageTableData extends DataClass
    implements Insertable<ProductImageTableData> {
  final int id;
  final String localPath;
  final String productId;
  ProductImageTableData(
      {@required this.id, @required this.localPath, this.productId});
  factory ProductImageTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ProductImageTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      localPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}local_path']),
      productId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    return map;
  }

  ProductImageTableCompanion toCompanion(bool nullToAbsent) {
    return ProductImageTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
    );
  }

  factory ProductImageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProductImageTableData(
      id: serializer.fromJson<int>(json['id']),
      localPath: serializer.fromJson<String>(json['localPath']),
      productId: serializer.fromJson<String>(json['productId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localPath': serializer.toJson<String>(localPath),
      'productId': serializer.toJson<String>(productId),
    };
  }

  ProductImageTableData copyWith(
          {int id, String localPath, String productId}) =>
      ProductImageTableData(
        id: id ?? this.id,
        localPath: localPath ?? this.localPath,
        productId: productId ?? this.productId,
      );
  @override
  String toString() {
    return (StringBuffer('ProductImageTableData(')
          ..write('id: $id, ')
          ..write('localPath: $localPath, ')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(localPath.hashCode, productId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ProductImageTableData &&
          other.id == this.id &&
          other.localPath == this.localPath &&
          other.productId == this.productId);
}

class ProductImageTableCompanion
    extends UpdateCompanion<ProductImageTableData> {
  final Value<int> id;
  final Value<String> localPath;
  final Value<String> productId;
  const ProductImageTableCompanion({
    this.id = const Value.absent(),
    this.localPath = const Value.absent(),
    this.productId = const Value.absent(),
  });
  ProductImageTableCompanion.insert({
    this.id = const Value.absent(),
    @required String localPath,
    this.productId = const Value.absent(),
  }) : localPath = Value(localPath);
  static Insertable<ProductImageTableData> custom({
    Expression<int> id,
    Expression<String> localPath,
    Expression<String> productId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localPath != null) 'local_path': localPath,
      if (productId != null) 'product_id': productId,
    });
  }

  ProductImageTableCompanion copyWith(
      {Value<int> id, Value<String> localPath, Value<String> productId}) {
    return ProductImageTableCompanion(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      productId: productId ?? this.productId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductImageTableCompanion(')
          ..write('id: $id, ')
          ..write('localPath: $localPath, ')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }
}

class $ProductImageTableTable extends ProductImageTable
    with TableInfo<$ProductImageTableTable, ProductImageTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProductImageTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _localPathMeta = const VerificationMeta('localPath');
  GeneratedTextColumn _localPath;
  @override
  GeneratedTextColumn get localPath => _localPath ??= _constructLocalPath();
  GeneratedTextColumn _constructLocalPath() {
    return GeneratedTextColumn(
      'local_path',
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
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, localPath, productId];
  @override
  $ProductImageTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'product_image_table';
  @override
  final String actualTableName = 'product_image_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductImageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path'], _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id'], _productIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductImageTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ProductImageTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProductImageTableTable createAlias(String alias) {
    return $ProductImageTableTable(_db, alias);
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
  $StockHistoryTableTable _stockHistoryTable;
  $StockHistoryTableTable get stockHistoryTable =>
      _stockHistoryTable ??= $StockHistoryTableTable(this);
  $OrderDetailTableTable _orderDetailTable;
  $OrderDetailTableTable get orderDetailTable =>
      _orderDetailTable ??= $OrderDetailTableTable(this);
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
  $ProductImageTableTable _productImageTable;
  $ProductImageTableTable get productImageTable =>
      _productImageTable ??= $ProductImageTableTable(this);
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
  OrderDetailDao _orderDetailDao;
  OrderDetailDao get orderDetailDao =>
      _orderDetailDao ??= OrderDetailDao(this as Database);
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
  ProductImageDao _productImageDao;
  ProductImageDao get productImageDao =>
      _productImageDao ??= ProductImageDao(this as Database);
  Listner _listner;
  Listner get listner => _listner ??= Listner(this as Database);
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
        stockHistoryTable,
        orderDetailTable,
        orderTable,
        colorTable,
        actionsTable,
        reasonTable,
        taxTable,
        branchProductTable,
        productImageTable
      ];
}
