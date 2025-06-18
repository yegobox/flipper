// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250618092427_up = [
  InsertColumn('assigned', Column.boolean, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20250618092427_down = [
  DropColumn('assigned', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250618092427',
  up: _migration_20250618092427_up,
  down: _migration_20250618092427_down,
)
class Migration20250618092427 extends Migration {
  const Migration20250618092427()
    : super(
        version: 20250618092427,
        up: _migration_20250618092427_up,
        down: _migration_20250618092427_down,
      );
}
