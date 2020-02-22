import 'dart:io';

import 'package:flipper/data/actions_table.dart';
import 'package:flipper/data/branch.dart';
import 'package:flipper/data/business.dart';
import 'package:flipper/data/business_user.dart';
import 'package:flipper/data/cart_table.dart';

import 'package:flipper/data/category_table.dart';
import 'package:flipper/data/color_table.dart';
import 'package:flipper/data/dao/actions_dao.dart';
import 'package:flipper/data/dao/branch_dao.dart';
import 'package:flipper/data/dao/business_dao.dart';
import 'package:flipper/data/dao/cart_dao.dart';
import 'package:flipper/data/dao/category_dao.dart';
import 'package:flipper/data/dao/color_dao.dart';
import 'package:flipper/data/dao/history_dao.dart';
import 'package:flipper/data/dao/item_dao.dart';
import 'package:flipper/data/dao/order_dao.dart';
import 'package:flipper/data/dao/reason_dao.dart';
import 'package:flipper/data/dao/stock_dao.dart';
import 'package:flipper/data/dao/tab_dao.dart';
import 'package:flipper/data/dao/tax_dao.dart';
import 'package:flipper/data/dao/unit_dao.dart';
import 'package:flipper/data/dao/variation_dao.dart';
import 'package:flipper/data/item_table.dart';
import 'package:flipper/data/order.dart';
import 'package:flipper/data/price_table.dart';
import 'package:flipper/data/reason_table.dart';
import 'package:flipper/data/stock_history_table.dart';
import 'package:flipper/data/stock_tabble.dart';
import 'package:flipper/data/tabs.dart';
import 'package:flipper/data/tax_table.dart';
import 'package:flipper/data/token.dart';
import 'package:flipper/data/unit_table.dart';
import 'package:flipper/data/user.dart';
import 'package:flipper/data/variation_table.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
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
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [
  UserTable,
  BusinessTable,
  BranchTable,
  UnitTable,
  CategoryTable,
  ItemTable,
  TokenTable,
  BusinessUserTable,
  TabsTable,
  VariationTable,
  StockTable,
  PriceTable,
  StockHistoryTable,
  CartTable,
  OrderTable,
  ColorTable,
  ActionsTable,
  ReasonTable,
  TaxTable
], daos: [
  UserDao,
  TokenDao,
  UnitDao,
  BusinessDao,
  BranchDao,
  CategoryDao,
  TabsDao,
  VariationDao,
  ItemDao,
  StockHistoryDao,
  StockDao,
  CartDao,
  OrderDao,
  ColorDao,
  ActionsDao,
  TaxDao,
  ReasonDao
])
class Database extends _$Database {
  Database() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (Migrator migrator, from, to) async {
//        if (from == 2) {
//          await migrator.createTable(actionsTable);
//        }
      },
      onCreate: (Migrator m) {
        return m.createAllTables();
      },
    );
  }
}
