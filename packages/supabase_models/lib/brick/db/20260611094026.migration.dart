// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260611094026_up = [
  InsertColumn('reg_ty_cd', Column.varchar, onTable: 'Purchase')
];

const List<MigrationCommand> _migration_20260611094026_down = [
  DropColumn('reg_ty_cd', onTable: 'Purchase')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260611094026',
  up: _migration_20260611094026_up,
  down: _migration_20260611094026_down,
)
class Migration20260611094026 extends Migration {
  const Migration20260611094026()
    : super(
        version: 20260611094026,
        up: _migration_20260611094026_up,
        down: _migration_20260611094026_down,
      );
}
