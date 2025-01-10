// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250110094310_up = [
  InsertTable('ImportPurchaseDates'),
  InsertColumn('id', Column.varchar, onTable: 'ImportPurchaseDates', unique: true),
  InsertColumn('last_request_date', Column.varchar, onTable: 'ImportPurchaseDates'),
  InsertColumn('branch_id', Column.varchar, onTable: 'ImportPurchaseDates'),
  InsertColumn('request_type', Column.varchar, onTable: 'ImportPurchaseDates'),
  CreateIndex(columns: ['id'], onTable: 'ImportPurchaseDates', unique: true)
];

const List<MigrationCommand> _migration_20250110094310_down = [
  DropTable('ImportPurchaseDates'),
  DropColumn('id', onTable: 'ImportPurchaseDates'),
  DropColumn('last_request_date', onTable: 'ImportPurchaseDates'),
  DropColumn('branch_id', onTable: 'ImportPurchaseDates'),
  DropColumn('request_type', onTable: 'ImportPurchaseDates'),
  DropIndex('index_ImportPurchaseDates_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250110094310',
  up: _migration_20250110094310_up,
  down: _migration_20250110094310_down,
)
class Migration20250110094310 extends Migration {
  const Migration20250110094310()
    : super(
        version: 20250110094310,
        up: _migration_20250110094310_up,
        down: _migration_20250110094310_down,
      );
}
