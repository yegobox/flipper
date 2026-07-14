import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;

extension PointerCharExt on Pointer<Char> {
  bool get isEmpty => this == nullptr || toDartString().isEmpty;

  bool get isNotEmpty => !isEmpty;

  String toDartString() => cast<Utf8>().toDartString();
}

void checkIfError(Pointer<Char> errorMessage) {
  if (errorMessage.isNotEmpty) {
    final message = errorMessage.toDartString();
    g.free_string(errorMessage);
    throw Exception(message);
  }
}
