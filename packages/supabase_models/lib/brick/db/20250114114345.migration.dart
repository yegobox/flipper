// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250114114345_up = [
  InsertTable('CustomerPayments'),
  InsertColumn('id', Column.varchar, onTable: 'CustomerPayments', unique: true),
  InsertColumn('customer_id', Column.varchar, onTable: 'CustomerPayments'),
  InsertColumn('phone_number', Column.varchar, onTable: 'CustomerPayments'),
  InsertColumn('payment_status', Column.varchar, onTable: 'CustomerPayments'),
  InsertColumn('transaction_id', Column.varchar, onTable: 'CustomerPayments'),
  CreateIndex(columns: ['id'], onTable: 'CustomerPayments', unique: true)
];

const List<MigrationCommand> _migration_20250114114345_down = [
  DropTable('CustomerPayments'),
  DropColumn('id', onTable: 'CustomerPayments'),
  DropColumn('customer_id', onTable: 'CustomerPayments'),
  DropColumn('phone_number', onTable: 'CustomerPayments'),
  DropColumn('payment_status', onTable: 'CustomerPayments'),
  DropColumn('transaction_id', onTable: 'CustomerPayments'),
  DropIndex('index_CustomerPayments_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250114114345',
  up: _migration_20250114114345_up,
  down: _migration_20250114114345_down,
)
class Migration20250114114345 extends Migration {
  const Migration20250114114345()
    : super(
        version: 20250114114345,
        up: _migration_20250114114345_up,
        down: _migration_20250114114345_down,
      );
}
