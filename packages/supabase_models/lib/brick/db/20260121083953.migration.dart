// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260121083953_up = [
  InsertTable('_brick_ITransaction_payments'),
  InsertTable('TransactionPayment'),
  InsertForeignKey('_brick_ITransaction_payments', 'ITransaction', foreignKeyColumn: 'l_ITransaction_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_ITransaction_payments', 'TransactionPayment', foreignKeyColumn: 'f_TransactionPayment_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertColumn('total_paid', Column.Double, onTable: 'ITransaction'),
  InsertColumn('calculated_remaining_balance', Column.Double, onTable: 'ITransaction'),
  InsertColumn('is_fully_paid', Column.boolean, onTable: 'ITransaction'),
  InsertColumn('id', Column.varchar, onTable: 'TransactionPayment', unique: true),
  InsertColumn('transaction_id', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('amount', Column.Double, onTable: 'TransactionPayment'),
  InsertColumn('payment_method', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('created_at', Column.datetime, onTable: 'TransactionPayment'),
  InsertColumn('branch_id', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('agent_id', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('reference', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('notes', Column.varchar, onTable: 'TransactionPayment'),
  InsertColumn('hash_code', Column.integer, onTable: 'TransactionPayment'),
  CreateIndex(columns: ['l_ITransaction_brick_id', 'f_TransactionPayment_brick_id'], onTable: '_brick_ITransaction_payments', unique: true),
  CreateIndex(columns: ['id'], onTable: 'TransactionPayment', unique: true),
  CreateIndex(columns: ['transaction_id'], onTable: 'TransactionPayment', unique: false)
];

const List<MigrationCommand> _migration_20260121083953_down = [
  DropTable('_brick_ITransaction_payments'),
  DropTable('TransactionPayment'),
  DropColumn('l_ITransaction_brick_id', onTable: '_brick_ITransaction_payments'),
  DropColumn('f_TransactionPayment_brick_id', onTable: '_brick_ITransaction_payments'),
  DropColumn('total_paid', onTable: 'ITransaction'),
  DropColumn('calculated_remaining_balance', onTable: 'ITransaction'),
  DropColumn('is_fully_paid', onTable: 'ITransaction'),
  DropColumn('id', onTable: 'TransactionPayment'),
  DropColumn('transaction_id', onTable: 'TransactionPayment'),
  DropColumn('amount', onTable: 'TransactionPayment'),
  DropColumn('payment_method', onTable: 'TransactionPayment'),
  DropColumn('created_at', onTable: 'TransactionPayment'),
  DropColumn('branch_id', onTable: 'TransactionPayment'),
  DropColumn('agent_id', onTable: 'TransactionPayment'),
  DropColumn('reference', onTable: 'TransactionPayment'),
  DropColumn('notes', onTable: 'TransactionPayment'),
  DropColumn('hash_code', onTable: 'TransactionPayment'),
  DropIndex('index__brick_ITransaction_payments_on_l_ITransaction_brick_id_f_TransactionPayment_brick_id'),
  DropIndex('index_TransactionPayment_on_id'),
  DropIndex('index_TransactionPayment_on_transaction_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260121083953',
  up: _migration_20260121083953_up,
  down: _migration_20260121083953_down,
)
class Migration20260121083953 extends Migration {
  const Migration20260121083953()
    : super(
        version: 20260121083953,
        up: _migration_20260121083953_up,
        down: _migration_20260121083953_down,
      );
}
