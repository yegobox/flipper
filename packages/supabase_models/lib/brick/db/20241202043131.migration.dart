// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241202043131_up = [
  DropColumn('sub_total', onTable: 'ITransaction'),
  DropColumn('customer_change_due', onTable: 'ITransaction'),
  InsertColumn('sub_total', Column.integer, onTable: 'ITransaction'),
  InsertColumn('customer_change_due', Column.integer, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20241202043131_down = [
  DropColumn('sub_total', onTable: 'ITransaction'),
  DropColumn('customer_change_due', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241202043131',
  up: _migration_20241202043131_up,
  down: _migration_20241202043131_down,
)
class Migration20241202043131 extends Migration {
  const Migration20241202043131()
    : super(
        version: 20241202043131,
        up: _migration_20241202043131_up,
        down: _migration_20241202043131_down,
      );
}
