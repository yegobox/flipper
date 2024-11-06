// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20241105105510.migration.dart';
part '20241106081113.migration.dart';
part '20241106083137.migration.dart';
part '20241106083218.migration.dart';
part '20241106090504.migration.dart';
part '20241106090549.migration.dart';
part '20241106090846.migration.dart';
part '20241106090910.migration.dart';
part '20241106091652.migration.dart';
part '20241106091734.migration.dart';
part '20241106093749.migration.dart';
part '20241106093750.migration.dart';
part '20241106093753.migration.dart';
part '20241106093755.migration.dart';
part '20241106093758.migration.dart';
part '20241106093825.migration.dart';
part '20241106112436.migration.dart';
part '20241106112448.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20241105105510(),
  const Migration20241106081113(),
  const Migration20241106083137(),
  const Migration20241106083218(),
  const Migration20241106090504(),
  const Migration20241106090549(),
  const Migration20241106090846(),
  const Migration20241106090910(),
  const Migration20241106091652(),
  const Migration20241106091734(),
  const Migration20241106093749(),
  const Migration20241106093750(),
  const Migration20241106093753(),
  const Migration20241106093755(),
  const Migration20241106093758(),
  const Migration20241106093825(),
  const Migration20241106112436(),
  const Migration20241106112448()
};

/// A consumable database structure including the latest generated migration.
final schema =
    Schema(20241106112448, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Counter', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('tot_rcpt_no', Column.integer),
    SchemaColumn('cur_rcpt_no', Column.integer),
    SchemaColumn('invc_no', Column.integer),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{}),
  SchemaTable('Branch', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('server_id', Column.integer),
    SchemaColumn('location', Column.varchar),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('latitude', Column.varchar),
    SchemaColumn('longitude', Column.varchar),
    SchemaColumn('is_default', Column.boolean),
    SchemaColumn('is_online', Column.boolean)
  }, indices: <SchemaIndex>{})
});
