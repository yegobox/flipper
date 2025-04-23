// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250423035546_up = [
  DropColumn('branch_id', onTable: 'TransactionItem'),
  InsertColumn('branch_id', Column.varchar, onTable: 'TransactionItem'),
  CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250423035546_down = [
  DropColumn('branch_id', onTable: 'TransactionItem'),
  DropIndex('index_BranchSmsConfig_on_branch_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250423035546',
  up: _migration_20250423035546_up,
  down: _migration_20250423035546_down,
)
class Migration20250423035546 extends Migration {
  const Migration20250423035546()
      : super(
          version: 20250423035546,
          up: _migration_20250423035546_up,
          down: _migration_20250423035546_down,
        );
}
