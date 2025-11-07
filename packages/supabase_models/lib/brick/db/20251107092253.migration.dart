// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251107092253_up = [
  InsertColumn('stock_remained_at_the_time_of_sale', Column.num, onTable: 'BusinessAnalytic')
];

const List<MigrationCommand> _migration_20251107092253_down = [
  DropColumn('stock_remained_at_the_time_of_sale', onTable: 'BusinessAnalytic')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251107092253',
  up: _migration_20251107092253_up,
  down: _migration_20251107092253_down,
)
class Migration20251107092253 extends Migration {
  const Migration20251107092253()
    : super(
        version: 20251107092253,
        up: _migration_20251107092253_up,
        down: _migration_20251107092253_down,
      );
}
