// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251212052427_up = [
  DropColumn('parsed_tags', onTable: 'Log'),
  DropColumn('parsed_extra', onTable: 'Log')
];

const List<MigrationCommand> _migration_20251212052427_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251212052427',
  up: _migration_20251212052427_up,
  down: _migration_20251212052427_down,
)
class Migration20251212052427 extends Migration {
  const Migration20251212052427()
    : super(
        version: 20251212052427,
        up: _migration_20251212052427_up,
        down: _migration_20251212052427_down,
      );
}
