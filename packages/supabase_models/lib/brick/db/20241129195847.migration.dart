// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241129195847_up = [
  InsertTable('Assets'),
  InsertColumn('id', Column.integer, onTable: 'Assets', unique: true),
  InsertColumn('branch_id', Column.integer, onTable: 'Assets'),
  InsertColumn('business_id', Column.integer, onTable: 'Assets'),
  InsertColumn('asset_name', Column.varchar, onTable: 'Assets'),
  InsertColumn('product_id', Column.integer, onTable: 'Assets')
];

const List<MigrationCommand> _migration_20241129195847_down = [
  DropTable('Assets'),
  DropColumn('id', onTable: 'Assets'),
  DropColumn('branch_id', onTable: 'Assets'),
  DropColumn('business_id', onTable: 'Assets'),
  DropColumn('asset_name', onTable: 'Assets'),
  DropColumn('product_id', onTable: 'Assets')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241129195847',
  up: _migration_20241129195847_up,
  down: _migration_20241129195847_down,
)
class Migration20241129195847 extends Migration {
  const Migration20241129195847()
    : super(
        version: 20241129195847,
        up: _migration_20241129195847_up,
        down: _migration_20241129195847_down,
      );
}
