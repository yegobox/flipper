import 'package:built_value/built_value.dart';

part 'couch_db_client_instance.g.dart';

abstract class CouchDbClient
    implements Built<CouchDbClient, CouchDbClientBuilder> {
  @nullable
  String get name;

  CouchDbClient._();
  factory CouchDbClient([void Function(CouchDbClientBuilder) updates]) =
      _$CouchDbClient;
}
