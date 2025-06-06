// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250606053104_up = [
  InsertColumn('financing_Financing_brick_id', Column.varchar,
      onTable: 'InventoryRequest'),
];

const List<MigrationCommand> _migration_20250606053104_down = [
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250606053104',
  up: _migration_20250606053104_up,
  down: _migration_20250606053104_down,
)
class Migration20250606053104 extends Migration {
  const Migration20250606053104()
      : super(
          version: 20250606053104,
          up: _migration_20250606053104_up,
          down: _migration_20250606053104_down,
        );
}
