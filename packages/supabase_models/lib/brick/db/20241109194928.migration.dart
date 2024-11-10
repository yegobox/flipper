// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241109194928_up = [
  DropColumn('pay_stack_customer_id', onTable: 'Plan'),
  InsertColumn('paystack_customer_id', Column.integer, onTable: 'Plan')
];

const List<MigrationCommand> _migration_20241109194928_down = [
  DropColumn('paystack_customer_id', onTable: 'Plan')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241109194928',
  up: _migration_20241109194928_up,
  down: _migration_20241109194928_down,
)
class Migration20241109194928 extends Migration {
  const Migration20241109194928()
    : super(
        version: 20241109194928,
        up: _migration_20241109194928_up,
        down: _migration_20241109194928_down,
      );
}
