// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227184946_up = [
  DropColumn('branch_id', onTable: 'ItemCode'),
  DropColumn('branch_id', onTable: 'Sar'),
  DropColumn('branch_id', onTable: 'StockRecount'),
  DropColumn('branch_id', onTable: 'Conversation'),
  DropColumn('branch_id', onTable: 'BranchSmsConfig'),
  DropColumn('branch_id', onTable: 'TransactionDelegation'),
  DropColumn('branch_id', onTable: 'Ebm'),
  InsertColumn('branch_id', Column.varchar, onTable: 'BranchSmsConfig'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Conversation'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Ebm'),
  InsertColumn('branch_id', Column.varchar, onTable: 'ItemCode'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Sar'),
  InsertColumn('branch_id', Column.varchar, onTable: 'StockRecount'),
  InsertColumn('branch_id', Column.varchar, onTable: 'TransactionDelegation')
];

const List<MigrationCommand> _migration_20251227184946_down = [
  DropColumn('branch_id', onTable: 'BranchSmsConfig'),
  DropColumn('branch_id', onTable: 'Conversation'),
  DropColumn('branch_id', onTable: 'Ebm'),
  DropColumn('branch_id', onTable: 'ItemCode'),
  DropColumn('branch_id', onTable: 'Sar'),
  DropColumn('branch_id', onTable: 'StockRecount'),
  DropColumn('branch_id', onTable: 'TransactionDelegation')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227184946',
  up: _migration_20251227184946_up,
  down: _migration_20251227184946_down,
)
class Migration20251227184946 extends Migration {
  const Migration20251227184946()
    : super(
        version: 20251227184946,
        up: _migration_20251227184946_up,
        down: _migration_20251227184946_down,
      );
}
