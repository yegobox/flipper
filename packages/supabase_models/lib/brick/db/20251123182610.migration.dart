// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251123182610_up = [
  InsertTable('TransactionDelegation'),
  InsertColumn('id', Column.varchar, onTable: 'TransactionDelegation', unique: true),
  InsertColumn('transaction_id', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('branch_id', Column.integer, onTable: 'TransactionDelegation'),
  InsertColumn('status', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('receipt_type', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('payment_type', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('sub_total', Column.Double, onTable: 'TransactionDelegation'),
  InsertColumn('customer_name', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('customer_tin', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('customer_bhf_id', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('is_auto_print', Column.boolean, onTable: 'TransactionDelegation'),
  InsertColumn('delegated_from_device', Column.varchar, onTable: 'TransactionDelegation'),
  InsertColumn('delegated_at', Column.datetime, onTable: 'TransactionDelegation'),
  InsertColumn('updated_at', Column.datetime, onTable: 'TransactionDelegation'),
  CreateIndex(columns: ['id'], onTable: 'TransactionDelegation', unique: true),
  CreateIndex(columns: ['transaction_id'], onTable: 'TransactionDelegation', unique: false),
  CreateIndex(columns: ['branch_id'], onTable: 'TransactionDelegation', unique: false),
  CreateIndex(columns: ['status'], onTable: 'TransactionDelegation', unique: false)
];

const List<MigrationCommand> _migration_20251123182610_down = [
  DropTable('TransactionDelegation'),
  DropColumn('id', onTable: 'TransactionDelegation'),
  DropColumn('transaction_id', onTable: 'TransactionDelegation'),
  DropColumn('branch_id', onTable: 'TransactionDelegation'),
  DropColumn('status', onTable: 'TransactionDelegation'),
  DropColumn('receipt_type', onTable: 'TransactionDelegation'),
  DropColumn('payment_type', onTable: 'TransactionDelegation'),
  DropColumn('sub_total', onTable: 'TransactionDelegation'),
  DropColumn('customer_name', onTable: 'TransactionDelegation'),
  DropColumn('customer_tin', onTable: 'TransactionDelegation'),
  DropColumn('customer_bhf_id', onTable: 'TransactionDelegation'),
  DropColumn('is_auto_print', onTable: 'TransactionDelegation'),
  DropColumn('delegated_from_device', onTable: 'TransactionDelegation'),
  DropColumn('delegated_at', onTable: 'TransactionDelegation'),
  DropColumn('updated_at', onTable: 'TransactionDelegation'),
  DropIndex('index_TransactionDelegation_on_id'),
  DropIndex('index_TransactionDelegation_on_transaction_id'),
  DropIndex('index_TransactionDelegation_on_branch_id'),
  DropIndex('index_TransactionDelegation_on_status')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251123182610',
  up: _migration_20251123182610_up,
  down: _migration_20251123182610_down,
)
class Migration20251123182610 extends Migration {
  const Migration20251123182610()
    : super(
        version: 20251123182610,
        up: _migration_20251123182610_up,
        down: _migration_20251123182610_down,
      );
}
