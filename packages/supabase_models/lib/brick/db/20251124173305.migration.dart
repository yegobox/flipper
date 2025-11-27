// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251124173305_up = [
  InsertColumn('selected_delegation_device_id', Column.varchar, onTable: 'TransactionDelegation')
];

const List<MigrationCommand> _migration_20251124173305_down = [
  DropColumn('selected_delegation_device_id', onTable: 'TransactionDelegation')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251124173305',
  up: _migration_20251124173305_up,
  down: _migration_20251124173305_down,
)
class Migration20251124173305 extends Migration {
  const Migration20251124173305()
    : super(
        version: 20251124173305,
        up: _migration_20251124173305_up,
        down: _migration_20251124173305_down,
      );
}
