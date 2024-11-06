// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241106112448_up = [
  DropColumn('branch_Branch_brick_id', onTable: 'Counter')
];

const List<MigrationCommand> _migration_20241106112448_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241106112448',
  up: _migration_20241106112448_up,
  down: _migration_20241106112448_down,
)
class Migration20241106112448 extends Migration {
  const Migration20241106112448()
    : super(
        version: 20241106112448,
        up: _migration_20241106112448_up,
        down: _migration_20241106112448_down,
      );
}
