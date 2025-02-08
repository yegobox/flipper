// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250208181424_up = [
  InsertForeignKey('TransactionItem', 'StockRequest', foreignKeyColumn: 'stock_request_StockRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false)
];

const List<MigrationCommand> _migration_20250208181424_down = [
  DropColumn('stock_request_StockRequest_brick_id', onTable: 'TransactionItem')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250208181424',
  up: _migration_20250208181424_up,
  down: _migration_20250208181424_down,
)
class Migration20250208181424 extends Migration {
  const Migration20250208181424()
    : super(
        version: 20250208181424,
        up: _migration_20250208181424_up,
        down: _migration_20250208181424_down,
      );
}
