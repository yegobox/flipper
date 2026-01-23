// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260121124148_up = [
  CreateIndex(columns: ['l_ITransaction_brick_id', 'f_TransactionPayment_brick_id'], onTable: '_brick_ITransaction_payments', unique: true)
];

const List<MigrationCommand> _migration_20260121124148_down = [
  DropIndex('index__brick_ITransaction_payments_on_l_ITransaction_brick_id_f_TransactionPayment_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260121124148',
  up: _migration_20260121124148_up,
  down: _migration_20260121124148_down,
)
class Migration20260121124148 extends Migration {
  const Migration20260121124148()
    : super(
        version: 20260121124148,
        up: _migration_20260121124148_up,
        down: _migration_20260121124148_down,
      );
}
