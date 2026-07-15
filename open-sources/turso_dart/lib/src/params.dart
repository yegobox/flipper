import 'dart:convert';
import 'dart:typed_data';

sealed class Params {
  const Params();

  const factory Params.none() = _None;
  const factory Params.positional(List<dynamic> values) = _Positional;
  const factory Params.named(Map<String, dynamic> pairs) = _Named;

  String? encode() => switch (this) {
    _None() => null,
    _Positional(:final values) => jsonEncode(_encodeList(values)),
    _Named(:final pairs) => jsonEncode(_encodeMap(pairs)),
  };
}

class _None extends Params {
  const _None();
}

class _Positional extends Params {
  const _Positional(this.values);
  final List<dynamic> values;
}

class _Named extends Params {
  const _Named(this.pairs);
  final Map<String, dynamic> pairs;
}

Object? _encodeValue(dynamic v) => switch (v) {
  null => null,
  int() => v,
  double() => v,
  bool() => v ? 1 : 0, // SQLite has no bool
  String() => v,
  Uint8List() => {r'$blob': base64Encode(v)},
  _ => throw ArgumentError('unsupported param type: ${v.runtimeType}'),
};

List<Object?> _encodeList(List<dynamic> values) =>
    values.map(_encodeValue).toList();

Map<String, Object?> _encodeMap(Map<String, dynamic> pairs) =>
    pairs.map((k, v) => MapEntry(k, _encodeValue(v)));
