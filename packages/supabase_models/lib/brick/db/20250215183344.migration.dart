// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250215183344_up = [
  InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('branch_id', Column.varchar, onTable: 'InventoryRequest')
];

const List<MigrationCommand> _migration_20250215183344_down = [
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('branch_id', onTable: 'InventoryRequest')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250215183344',
  up: _migration_20250215183344_up,
  down: _migration_20250215183344_down,
)
class Migration20250215183344 extends Migration {
  const Migration20250215183344()
    : super(
        version: 20250215183344,
        up: _migration_20250215183344_up,
        down: _migration_20250215183344_down,
      );
}
