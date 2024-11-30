// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241130104344_up = [
  InsertColumn('search_match', Column.boolean, onTable: 'Product')
];

const List<MigrationCommand> _migration_20241130104344_down = [
  DropColumn('search_match', onTable: 'Product')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241130104344',
  up: _migration_20241130104344_up,
  down: _migration_20241130104344_down,
)
class Migration20241130104344 extends Migration {
  const Migration20241130104344()
    : super(
        version: 20241130104344,
        up: _migration_20241130104344_up,
        down: _migration_20241130104344_down,
      );
}
