// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260130104720_up = [
  InsertTable('ActualOutput'),
  InsertTable('WorkOrder'),
  InsertColumn('id', Column.varchar, onTable: 'ActualOutput', unique: true),
  InsertColumn('work_order_id', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('branch_id', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('actual_quantity', Column.Double, onTable: 'ActualOutput'),
  InsertColumn('recorded_at', Column.datetime, onTable: 'ActualOutput'),
  InsertColumn('user_id', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('user_name', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('variance_reason', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('notes', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('shift_id', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('quality_status', Column.varchar, onTable: 'ActualOutput'),
  InsertColumn('rework_quantity', Column.num, onTable: 'ActualOutput'),
  InsertColumn('scrap_quantity', Column.num, onTable: 'ActualOutput'),
  InsertColumn('last_touched', Column.datetime, onTable: 'ActualOutput'),
  InsertColumn('id', Column.varchar, onTable: 'WorkOrder', unique: true),
  InsertColumn('branch_id', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('business_id', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('variant_id', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('variant_name', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('planned_quantity', Column.Double, onTable: 'WorkOrder'),
  InsertColumn('actual_quantity', Column.num, onTable: 'WorkOrder'),
  InsertColumn('target_date', Column.datetime, onTable: 'WorkOrder'),
  InsertColumn('shift_id', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('status', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('unit_of_measure', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('notes', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('created_by', Column.varchar, onTable: 'WorkOrder'),
  InsertColumn('created_at', Column.datetime, onTable: 'WorkOrder'),
  InsertColumn('started_at', Column.datetime, onTable: 'WorkOrder'),
  InsertColumn('completed_at', Column.datetime, onTable: 'WorkOrder'),
  InsertColumn('last_touched', Column.datetime, onTable: 'WorkOrder'),
  CreateIndex(columns: ['id'], onTable: 'ActualOutput', unique: true),
  CreateIndex(columns: ['work_order_id'], onTable: 'ActualOutput', unique: false),
  CreateIndex(columns: ['branch_id'], onTable: 'ActualOutput', unique: false),
  CreateIndex(columns: ['id'], onTable: 'WorkOrder', unique: true),
  CreateIndex(columns: ['branch_id'], onTable: 'WorkOrder', unique: false),
  CreateIndex(columns: ['business_id'], onTable: 'WorkOrder', unique: false),
  CreateIndex(columns: ['variant_id'], onTable: 'WorkOrder', unique: false)
];

const List<MigrationCommand> _migration_20260130104720_down = [
  DropTable('ActualOutput'),
  DropTable('WorkOrder'),
  DropColumn('id', onTable: 'ActualOutput'),
  DropColumn('work_order_id', onTable: 'ActualOutput'),
  DropColumn('branch_id', onTable: 'ActualOutput'),
  DropColumn('actual_quantity', onTable: 'ActualOutput'),
  DropColumn('recorded_at', onTable: 'ActualOutput'),
  DropColumn('user_id', onTable: 'ActualOutput'),
  DropColumn('user_name', onTable: 'ActualOutput'),
  DropColumn('variance_reason', onTable: 'ActualOutput'),
  DropColumn('notes', onTable: 'ActualOutput'),
  DropColumn('shift_id', onTable: 'ActualOutput'),
  DropColumn('quality_status', onTable: 'ActualOutput'),
  DropColumn('rework_quantity', onTable: 'ActualOutput'),
  DropColumn('scrap_quantity', onTable: 'ActualOutput'),
  DropColumn('last_touched', onTable: 'ActualOutput'),
  DropColumn('id', onTable: 'WorkOrder'),
  DropColumn('branch_id', onTable: 'WorkOrder'),
  DropColumn('business_id', onTable: 'WorkOrder'),
  DropColumn('variant_id', onTable: 'WorkOrder'),
  DropColumn('variant_name', onTable: 'WorkOrder'),
  DropColumn('planned_quantity', onTable: 'WorkOrder'),
  DropColumn('actual_quantity', onTable: 'WorkOrder'),
  DropColumn('target_date', onTable: 'WorkOrder'),
  DropColumn('shift_id', onTable: 'WorkOrder'),
  DropColumn('status', onTable: 'WorkOrder'),
  DropColumn('unit_of_measure', onTable: 'WorkOrder'),
  DropColumn('notes', onTable: 'WorkOrder'),
  DropColumn('created_by', onTable: 'WorkOrder'),
  DropColumn('created_at', onTable: 'WorkOrder'),
  DropColumn('last_touched', onTable: 'WorkOrder'),
  DropIndex('index_ActualOutput_on_id'),
  DropIndex('index_ActualOutput_on_work_order_id'),
  DropIndex('index_ActualOutput_on_branch_id'),
  DropIndex('index_WorkOrder_on_id'),
  DropIndex('index_WorkOrder_on_branch_id'),
  DropIndex('index_WorkOrder_on_business_id'),
  DropIndex('index_WorkOrder_on_variant_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260130104720',
  up: _migration_20260130104720_up,
  down: _migration_20260130104720_down,
)
class Migration20260130104720 extends Migration {
  const Migration20260130104720()
    : super(
        version: 20260130104720,
        up: _migration_20260130104720_up,
        down: _migration_20260130104720_down,
      );
}
