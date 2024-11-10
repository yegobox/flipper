// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241109193742_up = [
  DropColumn('total_price', onTable: 'Plan'),
  InsertColumn('total_price', Column.integer, onTable: 'Plan')
];

const List<MigrationCommand> _migration_20241109193742_down = [
  DropColumn('total_price', onTable: 'Plan')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241109193742',
  up: _migration_20241109193742_up,
  down: _migration_20241109193742_down,
)
class Migration20241109193742 extends Migration {
  const Migration20241109193742()
    : super(
        version: 20241109193742,
        up: _migration_20241109193742_up,
        down: _migration_20241109193742_down,
      );
}
