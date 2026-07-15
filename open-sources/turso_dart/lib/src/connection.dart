import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';
import 'package:turso_dart/src/params.dart';
import 'package:turso_dart/src/statement.dart';
import 'package:turso_dart/src/transaction.dart';

class Connection implements Finalizable {
  Connection._(this._ptr) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
  }

  static final NativeFinalizer _finalizer = NativeFinalizer(
    Native.addressOf<NativeFunction<Void Function(Pointer<Void>)>>(
      g.connection_dispose,
    ).cast(),
  );

  final Pointer<Void> _ptr;

  List<Map<String, dynamic>> query(String sql, {Params? params}) {
    return using((arena) {
      final result = g.connection_query(
        _ptr,
        sql.toNativeUtf8(allocator: arena).cast(),
        params?.encode()?.toNativeUtf8(allocator: arena).cast() ?? nullptr,
      );
      final g.FFIStringResponse(:value, :error_message) = result;
      checkIfError(error_message);
      final json = value.toDartString();
      g.free_string(value);
      final rows = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
      return rows;
    });
  }

  void execute(String sql, {Params? params}) {
    return using((arena) {
      final result = g.connection_execute(
        _ptr,
        sql.toNativeUtf8(allocator: arena).cast(),
        params?.encode()?.toNativeUtf8(allocator: arena).cast() ?? nullptr,
      );
      final g.FFIResponse(:error_message) = result;
      checkIfError(error_message);
    });
  }

  Statement prepare(String sql) {
    return using((arena) {
      final result = g.connection_prepare(
        _ptr,
        sql.toNativeUtf8(allocator: arena).cast(),
      );
      final g.FFIResponse(:ptr, :error_message) = result;
      checkIfError(error_message);
      return newStatement(ptr);
    });
  }

  Transaction transaction({
    TransactionBehavior behavior = TransactionBehavior.deferred,
  }) {
    return using((arena) {
      final result = g.connection_transaction(
        _ptr,
        behavior.name.toNativeUtf8(allocator: arena).cast(),
      );
      final g.FFIResponse(:ptr, :error_message) = result;
      checkIfError(error_message);
      return newTransaction(ptr);
    });
  }
}

Connection newConnection(Pointer<Void> ptr) => Connection._(ptr);
