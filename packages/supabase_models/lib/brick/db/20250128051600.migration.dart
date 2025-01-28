// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250128051600_up = [
  InsertColumn('taxbl_amt', Column.Double, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20250128051600_down = [
  DropColumn('taxbl_amt', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250128051600',
  up: _migration_20250128051600_up,
  down: _migration_20250128051600_down,
)
class Migration20250128051600 extends Migration {
  const Migration20250128051600()
      : super(
          version: 20250128051600,
          up: _migration_20250128051600_up,
          down: _migration_20250128051600_down,
        );
}
