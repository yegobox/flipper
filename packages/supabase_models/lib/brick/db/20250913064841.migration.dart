// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250913064841_up = [
  InsertColumn('property_ty_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('room_type_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('tt_cat_cd', Column.varchar, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20250913064841_down = [
  DropColumn('property_ty_cd', onTable: 'Variant'),
  DropColumn('room_type_cd', onTable: 'Variant'),
  DropColumn('tt_cat_cd', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250913064841',
  up: _migration_20250913064841_up,
  down: _migration_20250913064841_down,
)
class Migration20250913064841 extends Migration {
  const Migration20250913064841()
    : super(
        version: 20250913064841,
        up: _migration_20250913064841_up,
        down: _migration_20250913064841_down,
      );
}
