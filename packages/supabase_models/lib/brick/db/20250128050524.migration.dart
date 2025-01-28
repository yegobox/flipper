// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250128050524_up = [
  InsertColumn('tax_amt', Column.Double, onTable: 'Variant'),
  InsertColumn('tot_amt', Column.Double, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20250128050524_down = [
  DropColumn('tax_amt', onTable: 'Variant'),
  DropColumn('tot_amt', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250128050524',
  up: _migration_20250128050524_up,
  down: _migration_20250128050524_down,
)
class Migration20250128050524 extends Migration {
  const Migration20250128050524()
    : super(
        version: 20250128050524,
        up: _migration_20250128050524_up,
        down: _migration_20250128050524_down,
      );
}
