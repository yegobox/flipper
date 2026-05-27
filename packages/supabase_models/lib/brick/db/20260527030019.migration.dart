// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260527030019_up = [
  InsertColumn('allow_selling_below_stock', Column.boolean, onTable: 'Setting')
];

const List<MigrationCommand> _migration_20260527030019_down = [
  DropColumn('allow_selling_below_stock', onTable: 'Setting')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260527030019',
  up: _migration_20260527030019_up,
  down: _migration_20260527030019_down,
)
class Migration20260527030019 extends Migration {
  const Migration20260527030019()
    : super(
        version: 20260527030019,
        up: _migration_20260527030019_up,
        down: _migration_20260527030019_down,
      );
}
