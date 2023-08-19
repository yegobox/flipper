//ignore: implementation_imports
// TODO:bellow line was not commented
// import 'package:objectbox/src/transaction.dart';

/// READ: Dummy file to allow objectbox related code to compile on Web. We use
/// conditional imports at compile time, so any references to objectbox stuff
/// in [database.dart], [main.dart] and [background_isolate.dart] will error if
/// this file is removed. The below classes and methods are the ones that those
/// files use, in case we need to add more objectbox functionality to those files,
/// the new classes/methods must be added here.

/// Box put (write) mode.
enum PutMode {
  /// Insert (if given object's ID is zero) or update an existing object.
  put,

  /// Insert a new object.
  insert,

  /// Update an existing object, fails if the given ID doesn't exist.
  update,
}

class Box<T> {
  /// Puts the given [objects] into this Box in a single transaction.
  ///
  /// Returns a list of all IDs of the inserted Objects.
  List<int> putMany(List<T> objects, {PutMode mode = PutMode.put}) =>
      throw Exception('Unsupported Platform');

  /// Removes (deletes) ALL Objects in a single transaction.
  int removeAll() => throw Exception('Unsupported Platform');

  bool isEmpty() => throw Exception('Unsupported Platform');
}

class Store {
  Box<T> box<T>() => throw Exception('Unsupported Platform');
// TODO:bellow line was not commented
  // R runInTransaction<R>(TxMode mode, R Function() fn) => throw Exception('Unsupported Platform');

  dynamic get reference => throw Exception('Unsupported Platform');

  Store.fromReference(dynamic _, dynamic __);
}

Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    throw Exception('Unsupported Platform');

dynamic getObjectBoxModel() => throw Exception('Unsupported Platform');
