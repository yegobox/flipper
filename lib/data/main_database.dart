import 'dart:io' as Io;
import 'dart:io';

import 'package:flipper/data/actions_table.dart';
import 'package:flipper/data/branch.dart';
import 'package:flipper/data/business.dart';
import 'package:flipper/data/business_user.dart';
import 'package:flipper/data/category_table.dart';
import 'package:flipper/data/color_table.dart';
import 'package:flipper/data/dao/actions_dao.dart';
import 'package:flipper/data/dao/branch_dao.dart';
import 'package:flipper/data/dao/business_dao.dart';
import 'package:flipper/data/dao/category_dao.dart';
import 'package:flipper/data/dao/color_dao.dart';
import 'package:flipper/data/dao/history_dao.dart';
import 'package:flipper/data/dao/order_dao.dart';
import 'package:flipper/data/dao/order_detail_dao.dart';
import 'package:flipper/data/dao/product_dao.dart';
import 'package:flipper/data/dao/product_image_dao.dart';
import 'package:flipper/data/dao/products/branch_product_dao.dart';
import 'package:flipper/data/dao/reason_dao.dart';
import 'package:flipper/data/dao/stock_dao.dart';
import 'package:flipper/data/dao/tab_dao.dart';
import 'package:flipper/data/dao/tax_dao.dart';
import 'package:flipper/data/dao/unit_dao.dart';
import 'package:flipper/data/dao/variation_dao.dart';
import 'package:flipper/data/image_product.dart';
import 'package:flipper/data/order_detail_table.dart';
import 'package:flipper/data/order_table.dart';
import 'package:flipper/data/product_table.dart';
import 'package:flipper/data/products/branch_product_table.dart';
import 'package:flipper/data/reason_table.dart';
import 'package:flipper/data/stock_history_table.dart';
import 'package:flipper/data/stock_tabble.dart';
import 'package:flipper/data/tabs.dart';
import 'package:flipper/data/tax_table.dart';
import 'package:flipper/data/token.dart';
import 'package:flipper/data/unit_table.dart';
import 'package:flipper/data/user.dart';
import 'package:flipper/data/variation_table.dart';
import 'package:flipper/listeners/table_listeners.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dao/token_dao.dart';
import 'dao/user_dao.dart';

part 'main_database.g.dart';


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.

    final Io.Directory dbFolder = await getApplicationDocumentsDirectory();

    //development codes: todo: comment this code in production
    final Io.Directory dir = await getExternalStorageDirectory();
    final Io.Directory testdir = await Io.Directory('${dir.path}/database-development')
        .create(recursive: true);

//    print(testdir);

    // final Io.File file = File(p.join(testdir.path, 'db.sqlite'));
    //done development code : todo: end of code to be commented

//    final file = File(p.join(dbFolder.path, 'db.sqlite')); //todo: uncomment this code in production.
    // return VmDatabase(file);
   return LazyDatabase(() async {
       final Io.File file = File(p.join(testdir.path, 'db.sqlite'));
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        // copy the file from an asset, or network, or any other source
      }
      return VmDatabase(file);
    });
  });
}

//'/storage/emulated/0/Android/data/rw.flipper/files/database-development'
@UseMoor(tables: [
  UserTable,
  BusinessTable,
  BranchTable,
  UnitTable,
  CategoryTable,
  ProductTable,
  TokenTable,
  BusinessUserTable,
  TabsTable,
  VariationTable,
  StockTable,
  StockHistoryTable,
  OrderDetailTable,
  OrderTable,
  ColorTable,
  ActionsTable,
  ReasonTable,
  TaxTable,
  BranchProductTable,
  ProductImageTable,
], daos: [
  UserDao,
  TokenDao,
  UnitDao,
  BusinessDao,
  BranchDao,
  CategoryDao,
  TabsDao,
  VariationDao,
  ProductDao,
  StockHistoryDao,
  StockDao,
  OrderDetailDao,
  OrderDao,
  ColorDao,
  ActionsDao,
  TaxDao,
  ReasonDao,
  BranchProductDao,
  ProductImageDao,
  Listner
])
class Database extends _$Database {
  Database() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // this line is errorring.
        // customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (Migrator migrator, from, to) async {
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
