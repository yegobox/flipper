// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260603185233_up = [
  InsertColumn('refunded_amount', Column.Double, onTable: 'ITransaction'),
  InsertColumn('refund_reason', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('refund_method', Column.varchar, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20260603185233_down = [
  DropColumn('refunded_amount', onTable: 'ITransaction'),
  DropColumn('refund_reason', onTable: 'ITransaction'),
  DropColumn('refund_method', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260603185233',
  up: _migration_20260603185233_up,
  down: _migration_20260603185233_down,
)
class Migration20260603185233 extends Migration {
  const Migration20260603185233()
    : super(
        version: 20260603185233,
        up: _migration_20260603185233_up,
        down: _migration_20260603185233_down,
      );
}
