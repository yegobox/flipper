// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260617083057_up = [
  InsertColumn('is_fuel_managed', Column.boolean, onTable: 'Variant'),
  InsertColumn('rrp', Column.Double, onTable: 'Variant'),
  InsertColumn('rrp_effective_dt', Column.datetime, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20260617083057_down = [
  DropColumn('is_fuel_managed', onTable: 'Variant'),
  DropColumn('rrp', onTable: 'Variant'),
  DropColumn('rrp_effective_dt', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260617083057',
  up: _migration_20260617083057_up,
  down: _migration_20260617083057_down,
)
class Migration20260617083057 extends Migration {
  const Migration20260617083057()
    : super(
        version: 20260617083057,
        up: _migration_20260617083057_up,
        down: _migration_20260617083057_down,
      );
}
