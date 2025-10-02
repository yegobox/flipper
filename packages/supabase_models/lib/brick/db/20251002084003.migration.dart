// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251002084003_up = [
  DropColumn('is_draft', onTable: 'StockRecount'),
  DropColumn('is_submitted', onTable: 'StockRecount'),
  DropColumn('is_synced', onTable: 'StockRecount'),
  DropColumn('is_increase', onTable: 'StockRecountItem'),
  DropColumn('is_decrease', onTable: 'StockRecountItem'),
  DropColumn('is_unchanged', onTable: 'StockRecountItem')
];

const List<MigrationCommand> _migration_20251002084003_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251002084003',
  up: _migration_20251002084003_up,
  down: _migration_20251002084003_down,
)
class Migration20251002084003 extends Migration {
  const Migration20251002084003()
    : super(
        version: 20251002084003,
        up: _migration_20251002084003_up,
        down: _migration_20251002084003_down,
      );
}
