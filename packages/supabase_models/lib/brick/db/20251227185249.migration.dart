// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227185249_up = [
  DropColumn('branch_id', onTable: 'Counter'),
  DropColumn('branch_id', onTable: 'Category'),
  DropColumn('branch_id', onTable: 'BusinessAnalytic'),
  DropColumn('branch_id', onTable: 'ITransaction'),
  DropColumn('branch_id', onTable: 'Configurations'),
  DropColumn('branch_id', onTable: 'PColor'),
  DropColumn('branch_id', onTable: 'Purchase'),
  DropColumn('branch_id', onTable: 'Device'),
  DropColumn('branch_id', onTable: 'Favorite'),
  DropColumn('branch_id', onTable: 'Composite'),
  DropColumn('branch_id', onTable: 'Pin'),
  DropColumn('branch_id', onTable: 'Customer'),
  DropColumn('branch_id', onTable: 'Report'),
  DropColumn('branch_id', onTable: 'Discount'),
  DropColumn('branch_id', onTable: 'SKU'),
  DropColumn('branch_id', onTable: 'IUnit'),
  DropColumn('branch_id', onTable: 'Receipt'),
  DropColumn('branch_id', onTable: 'Assets'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Assets'),
  InsertColumn('branch_id', Column.varchar, onTable: 'BusinessAnalytic'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Category'),
  InsertColumn('branch_id', Column.varchar, onTable: 'PColor'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Composite'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Configurations'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Counter'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Customer'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Device'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Discount'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Favorite'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Pin'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Purchase'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Receipt'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Report'),
  InsertColumn('branch_id', Column.varchar, onTable: 'SKU'),
  InsertColumn('branch_id', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('branch_id', Column.varchar, onTable: 'IUnit')
];

const List<MigrationCommand> _migration_20251227185249_down = [
  DropColumn('branch_id', onTable: 'Assets'),
  DropColumn('branch_id', onTable: 'BusinessAnalytic'),
  DropColumn('branch_id', onTable: 'Category'),
  DropColumn('branch_id', onTable: 'PColor'),
  DropColumn('branch_id', onTable: 'Composite'),
  DropColumn('branch_id', onTable: 'Configurations'),
  DropColumn('branch_id', onTable: 'Counter'),
  DropColumn('branch_id', onTable: 'Customer'),
  DropColumn('branch_id', onTable: 'Device'),
  DropColumn('branch_id', onTable: 'Discount'),
  DropColumn('branch_id', onTable: 'Favorite'),
  DropColumn('branch_id', onTable: 'Pin'),
  DropColumn('branch_id', onTable: 'Purchase'),
  DropColumn('branch_id', onTable: 'Receipt'),
  DropColumn('branch_id', onTable: 'Report'),
  DropColumn('branch_id', onTable: 'SKU'),
  DropColumn('branch_id', onTable: 'ITransaction'),
  DropColumn('branch_id', onTable: 'IUnit')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227185249',
  up: _migration_20251227185249_up,
  down: _migration_20251227185249_down,
)
class Migration20251227185249 extends Migration {
  const Migration20251227185249()
    : super(
        version: 20251227185249,
        up: _migration_20251227185249_up,
        down: _migration_20251227185249_down,
      );
}
