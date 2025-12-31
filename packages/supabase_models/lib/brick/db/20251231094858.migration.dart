// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251231094858_up = [
  InsertColumn('business_id', Column.varchar, onTable: 'Tenant')
];

const List<MigrationCommand> _migration_20251231094858_down = [
  DropColumn('business_id', onTable: 'Tenant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251231094858',
  up: _migration_20251231094858_up,
  down: _migration_20251231094858_down,
)
class Migration20251231094858 extends Migration {
  const Migration20251231094858()
    : super(
        version: 20251231094858,
        up: _migration_20251231094858_up,
        down: _migration_20251231094858_down,
      );
}
