// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227184119_up = [
  DropColumn('business_id', onTable: 'Counter'),
  DropColumn('business_id', onTable: 'UnversalProduct'),
  DropColumn('branch_id', onTable: 'Message'),
  DropColumn('business_id', onTable: 'Configurations'),
  DropColumn('business_id', onTable: 'Device'),
  DropColumn('business_id', onTable: 'Composite'),
  DropColumn('business_id', onTable: 'Setting'),
  DropColumn('business_id', onTable: 'Pin'),
  DropColumn('business_id', onTable: 'Log'),
  DropColumn('business_id', onTable: 'Report'),
  DropColumn('business_id', onTable: 'SKU'),
  DropColumn('business_id', onTable: 'Location'),
  DropColumn('business_id', onTable: 'Token'),
  DropColumn('business_id', onTable: 'Ebm'),
  DropColumn('business_id', onTable: 'Product'),
  DropColumn('business_id', onTable: 'Assets'),
  InsertColumn('business_id', Column.varchar, onTable: 'Assets'),
  InsertColumn('business_id', Column.varchar, onTable: 'Composite'),
  InsertColumn('business_id', Column.varchar, onTable: 'Configurations'),
  InsertColumn('business_id', Column.varchar, onTable: 'Counter'),
  InsertColumn('business_id', Column.varchar, onTable: 'Device'),
  InsertColumn('business_id', Column.varchar, onTable: 'Ebm'),
  InsertColumn('business_id', Column.varchar, onTable: 'Location'),
  InsertColumn('business_id', Column.varchar, onTable: 'Log'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Message'),
  InsertColumn('business_id', Column.varchar, onTable: 'Pin'),
  InsertColumn('business_id', Column.varchar, onTable: 'Product'),
  InsertColumn('business_id', Column.varchar, onTable: 'Report'),
  InsertColumn('business_id', Column.varchar, onTable: 'Setting'),
  InsertColumn('business_id', Column.varchar, onTable: 'SKU'),
  InsertColumn('business_id', Column.varchar, onTable: 'Token'),
  InsertColumn('business_id', Column.varchar, onTable: 'UnversalProduct')
];

const List<MigrationCommand> _migration_20251227184119_down = [
  DropColumn('business_id', onTable: 'Assets'),
  DropColumn('business_id', onTable: 'Composite'),
  DropColumn('business_id', onTable: 'Configurations'),
  DropColumn('business_id', onTable: 'Counter'),
  DropColumn('business_id', onTable: 'Device'),
  DropColumn('business_id', onTable: 'Ebm'),
  DropColumn('business_id', onTable: 'Location'),
  DropColumn('business_id', onTable: 'Log'),
  DropColumn('branch_id', onTable: 'Message'),
  DropColumn('business_id', onTable: 'Pin'),
  DropColumn('business_id', onTable: 'Product'),
  DropColumn('business_id', onTable: 'Report'),
  DropColumn('business_id', onTable: 'Setting'),
  DropColumn('business_id', onTable: 'SKU'),
  DropColumn('business_id', onTable: 'Token'),
  DropColumn('business_id', onTable: 'UnversalProduct')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227184119',
  up: _migration_20251227184119_up,
  down: _migration_20251227184119_down,
)
class Migration20251227184119 extends Migration {
  const Migration20251227184119()
    : super(
        version: 20251227184119,
        up: _migration_20251227184119_up,
        down: _migration_20251227184119_down,
      );
}
