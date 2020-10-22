import 'dart:io';

import 'package:flipper/data/color_table.dart';
import 'package:flipper/data/dao/color_dao.dart';

import 'package:flipper/data/user.dart';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dao/user_dao.dart';

part 'main_database.g.dart';


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.

    final Directory dbFolder = await getApplicationDocumentsDirectory();

    final File file = File(p.join(dbFolder.path, 'db.sqlite'));
    // if (!await file.exists()) {}
    return VmDatabase(file);
  });
}

//'/storage/emulated/0/Android/data/rw.flipper/files/database-development'
@UseMoor(tables: [
  UserTable,
 
  ColorTable,
  
], daos: [
  UserDao,
  ColorDao,
])
class Database extends _$Database {
  Database() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (OpeningDetails details) async {
        // this line is errorring.
        // customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (Migrator migrator, int from, int to) async {
        // if (from == 1) {
        // await migrator.createTable(actionsTable);
        // }
      },
      onCreate: (Migrator m) {
        return m.createAll();
      },
    );
  }
}
