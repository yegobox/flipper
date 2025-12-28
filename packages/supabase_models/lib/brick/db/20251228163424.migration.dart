// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251228163424_up = [
  DropColumn('latitude', onTable: 'Business'),
  DropColumn('longitude', onTable: 'Business'),
  DropColumn('branch_id', onTable: 'Product'),
  InsertColumn('latitude', Column.num, onTable: 'Business'),
  InsertColumn('longitude', Column.num, onTable: 'Business'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Product')
];

const List<MigrationCommand> _migration_20251228163424_down = [
  DropColumn('latitude', onTable: 'Business'),
  DropColumn('longitude', onTable: 'Business'),
  DropColumn('branch_id', onTable: 'Product')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251228163424',
  up: _migration_20251228163424_up,
  down: _migration_20251228163424_down,
)
class Migration20251228163424 extends Migration {
  const Migration20251228163424()
    : super(
        version: 20251228163424,
        up: _migration_20251228163424_up,
        down: _migration_20251228163424_down,
      );
}
