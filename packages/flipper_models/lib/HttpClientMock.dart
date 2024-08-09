import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClientInterface extends Mock implements HttpClientInterface {}

class MockHttpClient extends Mock implements http.Client {}

class MockStreamedResponse extends Mock implements http.StreamedResponse {}

class MockResponse extends Mock implements http.Response {}

class MockRetryClient extends Mock implements http.Client {}

class MockProxyService extends Mock implements ProxyService {}

class MockRequest extends Mock implements http.BaseRequest {}

class MockUri extends Mock implements Uri {}

class MockEncoding extends Mock implements Encoding {}

class MockException extends Mock implements Exception {}

class MockSocketException extends Mock implements SocketException {}

class MockHandshakeException extends Mock implements HandshakeException {}

class MockStackTrace extends Mock implements StackTrace {}

class MockArgumentError extends Mock implements ArgumentError {}

class MockList extends Mock implements List {}

class MockMap extends Mock implements Map {}

// class MockString extends Mock implements String {}

// class MockInt extends Mock implements int {}

class MockDateTime extends Mock implements DateTime {}

class MockDuration extends Mock implements Duration {}

// class MockList<T> extends Mock implements List<T> {}

class MockSet<T> extends Mock implements Set<T> {}

// class MockMap<K, V> extends Mock implements Map<K, V> {}

class MockIterable<T> extends Mock implements Iterable<T> {}

class MockIterator<T> extends Mock implements Iterator<T> {}

class MockFuture<T> extends Mock implements Future<T> {}

class MockCompleter<T> extends Mock implements Completer<T> {}

class MockStream<T> extends Mock implements Stream<T> {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}
