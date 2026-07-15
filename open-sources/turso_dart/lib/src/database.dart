import 'dart:ffi';

import 'package:turso_dart/src/connection.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';

class Database implements Finalizable {
  Database._(this._ptr) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
  }

  static final NativeFinalizer _finalizer = NativeFinalizer(
    Native.addressOf<NativeFunction<Void Function(Pointer<Void>)>>(
      g.database_dispose,
    ).cast(),
  );

  final Pointer<Void> _ptr;

  Connection connect() {
    final result = g.database_connect(_ptr);
    final g.FFIResponse(:ptr, :error_message) = result;
    checkIfError(error_message);
    return newConnection(ptr);
  }

  bool pull() {
    final result = g.database_pull(_ptr);
    final g.FFIBoolResponse(:value, :error_message) = result;
    checkIfError(error_message);
    return value;
  }

  void push() {
    final result = g.database_push(_ptr);
    final g.FFIResponse(:error_message) = result;
    checkIfError(error_message);
  }
}

Database newDatabase(Pointer<Void> ptr) => Database._(ptr);
