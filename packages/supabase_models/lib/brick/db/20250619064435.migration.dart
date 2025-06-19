// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250619064435_up = [
  CreateIndex(columns: ['transaction_id'], onTable: 'TransactionItem', unique: false),
  CreateIndex(columns: ['variant_id'], onTable: 'TransactionItem', unique: false)
];

const List<MigrationCommand> _migration_20250619064435_down = [
  DropIndex('index_TransactionItem_on_transaction_id'),
  DropIndex('index_TransactionItem_on_variant_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250619064435',
  up: _migration_20250619064435_up,
  down: _migration_20250619064435_down,
)
class Migration20250619064435 extends Migration {
  const Migration20250619064435()
    : super(
        version: 20250619064435,
        up: _migration_20250619064435_up,
        down: _migration_20250619064435_down,
      );
}
