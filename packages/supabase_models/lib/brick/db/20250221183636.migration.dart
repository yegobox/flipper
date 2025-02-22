// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221183636_up = [
  DropColumn('destination_branch_id', onTable: 'VariantBranch'),
  InsertColumn('destination_branch_id', Column.varchar, onTable: 'VariantBranch')
];

const List<MigrationCommand> _migration_20250221183636_down = [
  DropColumn('destination_branch_id', onTable: 'VariantBranch')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221183636',
  up: _migration_20250221183636_up,
  down: _migration_20250221183636_down,
)
class Migration20250221183636 extends Migration {
  const Migration20250221183636()
    : super(
        version: 20250221183636,
        up: _migration_20250221183636_up,
        down: _migration_20250221183636_down,
      );
}
