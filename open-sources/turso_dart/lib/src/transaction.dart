import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';
import 'package:turso_dart/src/statement.dart';

class Transaction implements Finalizable {
  Transaction._(this._ptr) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
  }

  static final NativeFinalizer _finalizer = NativeFinalizer(
    Native.addressOf<NativeFunction<Void Function(Pointer<Void>)>>(
      g.transaction_dispose,
    ).cast(),
  );

  final Pointer<Void> _ptr;
  bool _disposed = false;

  Statement prepare(String sql) {
    if (_disposed) throw Exception('Transaction is disposed');
    return using((arena) {
      final result = g.transaction_prepare(
        _ptr,
        sql.toNativeUtf8(allocator: arena).cast(),
      );
      final g.FFIResponse(:ptr, :error_message) = result;
      checkIfError(error_message);
      return newStatement(ptr);
    });
  }

  void commit() {
    if (_disposed) return;
    _disposed = true;
    final result = g.transaction_commit(_ptr);
    final g.FFIResponse(:error_message) = result;
    _finalizer.detach(this);
    checkIfError(error_message);
  }

  void rollback() {
    if (_disposed) return;
    _disposed = true;
    final result = g.transaction_rollback(_ptr);
    final g.FFIResponse(:error_message) = result;
    _finalizer.detach(this);
    checkIfError(error_message);
  }
}

Transaction newTransaction(Pointer<Void> ptr) => Transaction._(ptr);

enum TransactionBehavior {
  deferred,
  immediate,
  exclusive,
}
