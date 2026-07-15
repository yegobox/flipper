import 'dart:convert';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/config.dart';
import 'package:turso_dart/src/database.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';

Database connect(LocalDbConfig config) {
  return using((arena) {
    g.init();
    final result = g.connect_local(
      jsonEncode(config).toNativeUtf8(allocator: arena).cast(),
    );
    final g.FFIResponse(:ptr, :error_message) = result;
    checkIfError(error_message);
    return newDatabase(ptr);
  });
}

Database connectSync(SyncDbConfig config) {
  return using((arena) {
    g.init();
    final result = g.connect_sync(
      jsonEncode(config).toNativeUtf8(allocator: arena).cast(),
    );
    final g.FFIResponse(:ptr, :error_message) = result;
    checkIfError(error_message);
    return newDatabase(ptr);
  });
}
