// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250215093115_up = [
  DropColumn('interest_rate', onTable: 'FinanceProvider'),
  InsertColumn('interest_rate', Column.num, onTable: 'FinanceProvider')
];

const List<MigrationCommand> _migration_20250215093115_down = [
  DropColumn('interest_rate', onTable: 'FinanceProvider')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250215093115',
  up: _migration_20250215093115_up,
  down: _migration_20250215093115_down,
)
class Migration20250215093115 extends Migration {
  const Migration20250215093115()
    : super(
        version: 20250215093115,
        up: _migration_20250215093115_up,
        down: _migration_20250215093115_down,
      );
}
