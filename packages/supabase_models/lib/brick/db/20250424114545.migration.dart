// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250424114545_up = [
  InsertColumn('created_at', Column.datetime, onTable: 'Purchase'),
  CreateIndex(columns: ['created_at'], onTable: 'Purchase', unique: false),
];

const List<MigrationCommand> _migration_20250424114545_down = [
  DropColumn('created_at', onTable: 'Purchase'),
  DropIndex('index_Purchase_on_created_at'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250424114545',
  up: _migration_20250424114545_up,
  down: _migration_20250424114545_down,
)
class Migration20250424114545 extends Migration {
  const Migration20250424114545()
      : super(
          version: 20250424114545,
          up: _migration_20250424114545_up,
          down: _migration_20250424114545_down,
        );
}
