// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241201190309_up = [
  DropColumn('dft_prc', onTable: 'Variant'),
  InsertColumn('dft_prc', Column.integer, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20241201190309_down = [
  DropColumn('dft_prc', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241201190309',
  up: _migration_20241201190309_up,
  down: _migration_20241201190309_down,
)
class Migration20241201190309 extends Migration {
  const Migration20241201190309()
    : super(
        version: 20241201190309,
        up: _migration_20241201190309_up,
        down: _migration_20241201190309_down,
      );
}
