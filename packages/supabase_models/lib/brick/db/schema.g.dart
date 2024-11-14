// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20241113200548.migration.dart';
part '20241113144615.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20241113200548(),const Migration20241113144615()};

/// A consumable database structure including the latest generated migration.
final schema = Schema(20241113200548, generatorVersion: 1, tables: <SchemaTable>{
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
  }, indices: <SchemaIndex>{}),
  SchemaTable('_brick_Plan_addons', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('l_Plan_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Plan',
        onDeleteCascade: true,
        onDeleteSetDefault: false),
    SchemaColumn('f_PlanAddon_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'PlanAddon',
        onDeleteCascade: true,
        onDeleteSetDefault: false)
  }, indices: <SchemaIndex>{
    SchemaIndex(
        columns: ['l_Plan_brick_id', 'f_PlanAddon_brick_id'], unique: true)
  }),
  SchemaTable('Plan', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('selected_plan', Column.varchar),
    SchemaColumn('additional_devices', Column.integer),
    SchemaColumn('is_yearly_plan', Column.boolean),
    SchemaColumn('total_price', Column.integer),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('payment_completed_by_user', Column.boolean),
    SchemaColumn('pay_stack_customer_id', Column.integer),
    SchemaColumn('rule', Column.varchar),
    SchemaColumn('payment_method', Column.varchar)
  }, indices: <SchemaIndex>{}),
  SchemaTable('PlanAddon', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('plan_id', Column.integer),
    SchemaColumn('addon_name', Column.varchar),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{})
});
