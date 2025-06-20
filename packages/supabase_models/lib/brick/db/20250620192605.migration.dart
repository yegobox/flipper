// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250620192605_up = [
  InsertTable('_brick_ITransaction_items'),
  InsertForeignKey('_brick_ITransaction_items', 'ITransaction', foreignKeyColumn: 'l_ITransaction_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_ITransaction_items', 'TransactionItem', foreignKeyColumn: 'f_TransactionItem_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  CreateIndex(columns: ['l_ITransaction_brick_id', 'f_TransactionItem_brick_id'], onTable: '_brick_ITransaction_items', unique: true)
];

const List<MigrationCommand> _migration_20250620192605_down = [
  DropTable('_brick_ITransaction_items'),
  DropColumn('l_ITransaction_brick_id', onTable: '_brick_ITransaction_items'),
  DropColumn('f_TransactionItem_brick_id', onTable: '_brick_ITransaction_items'),
  DropIndex('index__brick_ITransaction_items_on_l_ITransaction_brick_id_f_TransactionItem_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250620192605',
  up: _migration_20250620192605_up,
  down: _migration_20250620192605_down,
)
class Migration20250620192605 extends Migration {
  const Migration20250620192605()
    : super(
        version: 20250620192605,
        up: _migration_20250620192605_up,
        down: _migration_20250620192605_down,
      );
}
