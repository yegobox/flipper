// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250603073308_up = [
  InsertColumn('created_at', Column.datetime, onTable: 'InventoryRequest'),
  CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250603073308_down = [
  DropColumn('created_at', onTable: 'InventoryRequest'),
  DropIndex('index_BranchSmsConfig_on_branch_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250603073308',
  up: _migration_20250603073308_up,
  down: _migration_20250603073308_down,
)
class Migration20250603073308 extends Migration {
  const Migration20250603073308()
      : super(
          version: 20250603073308,
          up: _migration_20250603073308_up,
          down: _migration_20250603073308_down,
        );
}
