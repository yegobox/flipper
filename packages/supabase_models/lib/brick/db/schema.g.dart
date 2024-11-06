// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20241105105510.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{const Migration20241105105510()};

/// A consumable database structure including the latest generated migration.
final schema =
    Schema(20241105105510, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Counter', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('frozen', Column.boolean),
    SchemaColumn('branch_Branch_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Branch',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('tot_rcpt_no', Column.integer),
    SchemaColumn('cur_rcpt_no', Column.integer),
    SchemaColumn('invc_no', Column.integer)
  }, indices: <SchemaIndex>{}),
  SchemaTable('Branch', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar)
  }, indices: <SchemaIndex>{})
});
