// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name
// Updated to current date (June 10, 2025) to ensure migration runs

const List<MigrationCommand> _migration_20250610185130_up = [
  InsertColumn('vat_enabled', Column.boolean, onTable: 'Ebm'),
];

const List<MigrationCommand> _migration_20250610185130_down = [
  DropColumn('vat_enabled', onTable: 'Ebm'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250610185130',
  up: _migration_20250610185130_up,
  down: _migration_20250610185130_down,
)
class Migration20250610185130 extends Migration {
  const Migration20250610185130()
      : super(
          version: 20250610185130,
          up: _migration_20250610185130_up,
          down: _migration_20250610185130_down,
        );
}
