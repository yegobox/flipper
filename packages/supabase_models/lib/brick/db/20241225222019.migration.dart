// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241225222019_up = [
  CreateIndex(columns: ['id'], onTable: 'Stock', unique: true)
];

const List<MigrationCommand> _migration_20241225222019_down = [
  DropIndex('index_Stock_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241225222019',
  up: _migration_20241225222019_up,
  down: _migration_20241225222019_down,
)
class Migration20241225222019 extends Migration {
  const Migration20241225222019()
    : super(
        version: 20241225222019,
        up: _migration_20241225222019_up,
        down: _migration_20241225222019_down,
      );
}
