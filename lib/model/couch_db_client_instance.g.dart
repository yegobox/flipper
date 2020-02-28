// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couch_db_client_instance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CouchDbClient extends CouchDbClient {
  @override
  final String name;

  factory _$CouchDbClient([void Function(CouchDbClientBuilder) updates]) =>
      (new CouchDbClientBuilder()..update(updates)).build();

  _$CouchDbClient._({this.name}) : super._();

  @override
  CouchDbClient rebuild(void Function(CouchDbClientBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CouchDbClientBuilder toBuilder() => new CouchDbClientBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CouchDbClient && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CouchDbClient')..add('name', name))
        .toString();
  }
}

class CouchDbClientBuilder
    implements Builder<CouchDbClient, CouchDbClientBuilder> {
  _$CouchDbClient _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  CouchDbClientBuilder();

  CouchDbClientBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CouchDbClient other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CouchDbClient;
  }

  @override
  void update(void Function(CouchDbClientBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CouchDbClient build() {
    final _$result = _$v ?? new _$CouchDbClient._(name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
