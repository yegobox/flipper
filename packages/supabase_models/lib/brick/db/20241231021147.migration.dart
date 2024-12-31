// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241231021147_up = [
  InsertTable('TransactionPaymentRecord'),
  InsertColumn('id', Column.varchar, onTable: 'TransactionPaymentRecord', unique: true),
  InsertColumn('transaction_id', Column.varchar, onTable: 'TransactionPaymentRecord'),
  InsertColumn('amount', Column.Double, onTable: 'TransactionPaymentRecord'),
  InsertColumn('payment_method', Column.varchar, onTable: 'TransactionPaymentRecord'),
  InsertColumn('created_at', Column.datetime, onTable: 'TransactionPaymentRecord')
];

const List<MigrationCommand> _migration_20241231021147_down = [
  DropTable('TransactionPaymentRecord'),
  DropColumn('id', onTable: 'TransactionPaymentRecord'),
  DropColumn('transaction_id', onTable: 'TransactionPaymentRecord'),
  DropColumn('amount', onTable: 'TransactionPaymentRecord'),
  DropColumn('payment_method', onTable: 'TransactionPaymentRecord'),
  DropColumn('created_at', onTable: 'TransactionPaymentRecord')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241231021147',
  up: _migration_20241231021147_up,
  down: _migration_20241231021147_down,
)
class Migration20241231021147 extends Migration {
  const Migration20241231021147()
    : super(
        version: 20241231021147,
        up: _migration_20241231021147_up,
        down: _migration_20241231021147_down,
      );
}
