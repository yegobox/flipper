// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250603134014_up = [
  InsertColumn('is_auto_billed', Column.boolean, onTable: 'ITransaction'),
  InsertColumn('next_billing_date', Column.datetime, onTable: 'ITransaction'),
  InsertColumn('billing_frequency', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('billing_amount', Column.Double, onTable: 'ITransaction'),
  InsertColumn('total_installments', Column.integer, onTable: 'ITransaction'),
  InsertColumn('paid_installments', Column.integer, onTable: 'ITransaction'),
  InsertColumn('last_billed_date', Column.datetime, onTable: 'ITransaction'),
  InsertColumn('original_loan_amount', Column.Double, onTable: 'ITransaction'),
  InsertColumn('remaining_balance', Column.Double, onTable: 'ITransaction'),
  InsertColumn('last_payment_date', Column.datetime, onTable: 'ITransaction'),
  InsertColumn('last_payment_amount', Column.Double, onTable: 'ITransaction'),
];

const List<MigrationCommand> _migration_20250603134014_down = [
  DropColumn('is_auto_billed', onTable: 'ITransaction'),
  DropColumn('next_billing_date', onTable: 'ITransaction'),
  DropColumn('billing_frequency', onTable: 'ITransaction'),
  DropColumn('billing_amount', onTable: 'ITransaction'),
  DropColumn('total_installments', onTable: 'ITransaction'),
  DropColumn('paid_installments', onTable: 'ITransaction'),
  DropColumn('last_billed_date', onTable: 'ITransaction'),
  DropColumn('original_loan_amount', onTable: 'ITransaction'),
  DropColumn('remaining_balance', onTable: 'ITransaction'),
  DropColumn('last_payment_date', onTable: 'ITransaction'),
  DropColumn('last_payment_amount', onTable: 'ITransaction'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250603134014',
  up: _migration_20250603134014_up,
  down: _migration_20250603134014_down,
)
class Migration20250603134014 extends Migration {
  const Migration20250603134014()
      : super(
          version: 20250603134014,
          up: _migration_20250603134014_up,
          down: _migration_20250603134014_down,
        );
}
