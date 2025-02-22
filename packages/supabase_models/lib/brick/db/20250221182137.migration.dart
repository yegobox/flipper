// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221182137_up = [
  DropColumn('source_branch_id', onTable: 'VariantBranch'),
  InsertColumn('source_branch_id', Column.varchar, onTable: 'VariantBranch')
];

const List<MigrationCommand> _migration_20250221182137_down = [
  DropColumn('source_branch_id', onTable: 'VariantBranch')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221182137',
  up: _migration_20250221182137_up,
  down: _migration_20250221182137_down,
)
class Migration20250221182137 extends Migration {
  const Migration20250221182137()
    : super(
        version: 20250221182137,
        up: _migration_20250221182137_up,
        down: _migration_20250221182137_down,
      );
}
