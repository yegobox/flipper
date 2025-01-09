// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250109125327_up = [
  DropColumn('binded_to_tenant_id', onTable: 'Product'),
  InsertColumn('binded_to_tenant_id', Column.varchar, onTable: 'Product')
];

const List<MigrationCommand> _migration_20250109125327_down = [
  DropColumn('binded_to_tenant_id', onTable: 'Product')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250109125327',
  up: _migration_20250109125327_up,
  down: _migration_20250109125327_down,
)
class Migration20250109125327 extends Migration {
  const Migration20250109125327()
    : super(
        version: 20250109125327,
        up: _migration_20250109125327_up,
        down: _migration_20250109125327_down,
      );
}
