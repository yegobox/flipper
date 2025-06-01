// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250601143831_up = [
  InsertColumn('vat_enabled', Column.boolean, onTable: 'Ebm'),
];

const List<MigrationCommand> _migration_20250601143831_down = [
  DropColumn('vat_enabled', onTable: 'Ebm'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250601143831',
  up: _migration_20250601143831_up,
  down: _migration_20250601143831_down,
)
class Migration20250601143831 extends Migration {
  const Migration20250601143831()
      : super(
          version: 20250601143831,
          up: _migration_20250601143831_up,
          down: _migration_20250601143831_down,
        );
}
